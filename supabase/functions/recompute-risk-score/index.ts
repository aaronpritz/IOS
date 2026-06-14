// Edge Function: recompute-risk-score
// Scheduled job (e.g. nightly cron) that turns raw attempt data into the
// Human-Risk Score snapshots the manager dashboard reads. Server-only — this
// number drives reporting and must never be client-reported. See BUILD_PLAN.md §5.
//
// Methodology (illustrative — a real program tunes the weights with Reveal Risk):
//   per-domain accuracy over a recency window → 0..100, weighted by domain risk,
//   blended with an engagement (streak) factor. Higher = more resilient.
//
// Deploy:  supabase functions deploy recompute-risk-score
// Schedule: supabase functions schedule create nightly --cron "0 6 * * *" ...

import { createClient } from 'jsr:@supabase/supabase-js@2';

const WINDOW_DAYS = 30;
const DOMAIN_WEIGHT: Record<string, number> = {
  phishing: 1.3, social_eng: 1.2, ai_deepfakes: 1.2,
  passwords: 1.0, data_handling: 1.0, physical: 0.8,
};

Deno.serve(async (req) => {
  const admin = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );
  const { orgId } = await req.json().catch(() => ({ orgId: null }));

  const since = new Date(Date.now() - WINDOW_DAYS * 86400000).toISOString();
  let q = admin.from('attempts')
    .select('org_id, user_id, domain_key, is_correct')
    .gte('completed_at', since);
  if (orgId) q = q.eq('org_id', orgId);
  const { data: attempts, error } = await q;
  if (error) return json({ error: error.message }, 500);

  // Aggregate accuracy per (user, domain).
  type Acc = { correct: number; total: number };
  const perUser = new Map<string, { org: string; domains: Map<string, Acc> }>();
  for (const a of attempts ?? []) {
    const u = perUser.get(a.user_id) ?? { org: a.org_id, domains: new Map() };
    const d = u.domains.get(a.domain_key) ?? { correct: 0, total: 0 };
    d.total++; if (a.is_correct) d.correct++;
    u.domains.set(a.domain_key, d);
    perUser.set(a.user_id, u);
  }

  // Pull streaks for the engagement factor.
  const { data: streaks } = await admin.from('streaks').select('user_id, current_count');
  const streakByUser = new Map((streaks ?? []).map((s) => [s.user_id, s.current_count]));

  const snapshots = [];
  const teamRollup = new Map<string, { org: string; sum: number; n: number }>(); // by team via profiles
  const { data: profiles } = await admin.from('profiles').select('id, team_id, org_id');
  const teamOf = new Map((profiles ?? []).map((p) => [p.id, p.team_id]));

  for (const [userId, u] of perUser) {
    let wSum = 0, wTot = 0;
    const components: Record<string, number> = {};
    for (const [domain, acc] of u.domains) {
      const accuracy = acc.total ? acc.correct / acc.total : 0;
      const sub = Math.round(accuracy * 100);
      components[domain] = sub;
      const w = DOMAIN_WEIGHT[domain] ?? 1;
      wSum += sub * w; wTot += w;
    }
    const knowledge = wTot ? wSum / wTot : 50;
    const engagement = Math.min(100, (streakByUser.get(userId) ?? 0) * 5);
    const score = Math.round(0.8 * knowledge + 0.2 * engagement);
    snapshots.push({
      org_id: u.org, subject_kind: 'user', subject_id: userId, score, components,
    });
    // accumulate for team rollup
    const team = teamOf.get(userId);
    if (team) {
      const t = teamRollup.get(team) ?? { org: u.org, sum: 0, n: 0 };
      t.sum += score; t.n++; teamRollup.set(team, t);
    }
  }

  for (const [teamId, t] of teamRollup) {
    snapshots.push({
      org_id: t.org, subject_kind: 'team', subject_id: teamId,
      score: Math.round(t.sum / Math.max(1, t.n)), components: {},
    });
  }

  if (snapshots.length) await admin.from('human_risk_scores').insert(snapshots);
  return json({ inserted: snapshots.length });
});

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}
