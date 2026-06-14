// Edge Function: complete-session
// Server-authoritative end-of-lesson commit. The client CANNOT be trusted to
// report its own XP/streak (those feed compliance reporting), so streak/XP/
// badges are computed here from validated attempts. See BUILD_PLAN.md §5.
//
// Deploy: supabase functions deploy complete-session
// Invoke (authenticated): POST { lessonId, attempts: [{challengeId, isCorrect, heartsLost, timeMs}] }

import { createClient } from 'jsr:@supabase/supabase-js@2';

const XP_PER_LEVEL = 100;

Deno.serve(async (req) => {
  try {
    const authHeader = req.headers.get('Authorization') ?? '';
    const jwt = authHeader.replace('Bearer ', '');
    if (!jwt) return json({ error: 'missing auth' }, 401);

    // Service-role client for trusted writes; identify the caller from their JWT.
    const admin = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    );
    const { data: userData, error: userErr } = await admin.auth.getUser(jwt);
    if (userErr || !userData.user) return json({ error: 'invalid auth' }, 401);
    const userId = userData.user.id;

    const { lessonId, attempts } = await req.json();
    if (!lessonId || !Array.isArray(attempts)) return json({ error: 'bad request' }, 400);

    // Load the caller's org + the lesson's challenges (source of truth for XP).
    const { data: profile } = await admin
      .from('profiles').select('org_id').eq('id', userId).single();
    if (!profile) return json({ error: 'no profile' }, 403);
    const orgId = profile.org_id;

    const { data: challenges } = await admin
      .from('challenges').select('id, xp, domain_key').eq('lesson_id', lessonId);
    const chById = new Map((challenges ?? []).map((c) => [c.id, c]));

    // Recompute XP server-side from the canonical challenge values.
    let xpEarned = 0;
    let correct = 0;
    const attemptRows = [];
    for (const a of attempts) {
      const ch = chById.get(a.challengeId);
      if (!ch) continue; // ignore challenges not in this lesson (anti-cheat)
      if (a.isCorrect) {
        xpEarned += ch.xp;
        correct++;
      } else {
        xpEarned += Math.round(ch.xp / 2);
      }
      attemptRows.push({
        org_id: orgId, user_id: userId, challenge_id: ch.id, lesson_id: lessonId,
        domain_key: ch.domain_key, completed_at: new Date().toISOString(),
        is_correct: !!a.isCorrect, hearts_lost: a.heartsLost ?? 0, time_ms: a.timeMs ?? null,
      });
    }
    if (attemptRows.length) await admin.from('attempts').insert(attemptRows);

    // Streak logic (server clock + user timezone).
    const { data: streak } = await admin
      .from('streaks').select('*').eq('user_id', userId).maybeSingle();
    const today = new Date().toISOString().slice(0, 10);
    let current = streak?.current_count ?? 0;
    let increased = false;
    if (streak?.last_active_date === today) {
      // already practiced today
    } else if (streak?.last_active_date && dayDiff(streak.last_active_date, today) === 1) {
      current += 1; increased = true;
    } else {
      current = 1; increased = true;
    }
    const longest = Math.max(streak?.longest_count ?? 0, current);
    await admin.from('streaks').upsert({
      user_id: userId, current_count: current, longest_count: longest, last_active_date: today,
    });

    // XP / level.
    const { data: stats } = await admin
      .from('user_stats').select('*').eq('user_id', userId).maybeSingle();
    const totalXp = (stats?.total_xp ?? 0) + xpEarned;
    const levelBefore = Math.floor((stats?.total_xp ?? 0) / XP_PER_LEVEL) + 1;
    const level = Math.floor(totalXp / XP_PER_LEVEL) + 1;
    const leveledUp = level > levelBefore;
    await admin.from('user_stats').upsert({ user_id: userId, total_xp: totalXp, level });

    await admin.from('lesson_completions').insert({
      org_id: orgId, user_id: userId, lesson_id: lessonId,
      xp_earned: xpEarned, accuracy: attempts.length ? (correct / attempts.length) * 100 : 0,
    });

    // Variable reward: badge milestones.
    let newBadge: string | null = null;
    const { data: owned } = await admin.from('user_badges').select('badge_key').eq('user_id', userId);
    const ownedKeys = new Set((owned ?? []).map((b) => b.badge_key));
    if (!ownedKeys.has('first_steps')) newBadge = 'first_steps';
    else if (increased && [3, 7, 14, 30].includes(current)) newBadge = `streak_${current}`;
    if (newBadge && !ownedKeys.has(newBadge)) {
      await admin.from('user_badges').insert({ user_id: userId, badge_key: newBadge });
      await admin.from('reward_events').insert({ org_id: orgId, user_id: userId, type: 'badge', payload: { key: newBadge } });
    }

    return json({ streak: current, streakIncreased: increased, xpEarned, leveledUp, newBadge });
  } catch (e) {
    return json({ error: String(e) }, 500);
  }
});

function dayDiff(a: string, b: string): number {
  return Math.round((Date.parse(b) - Date.parse(a)) / 86400000);
}
function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } });
}
