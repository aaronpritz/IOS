# Reveal Risk — Supabase Backend (Phase 3)

Deployable backend for the cyber-training app: a multi-tenant Postgres schema with
Row-Level Security, seed content, and server-authoritative edge functions. This is the
**Phase 3** layer from [`../BUILD_PLAN.md`](../BUILD_PLAN.md) — the prototype in
[`../reveal-risk`](../reveal-risk) runs offline without it.

> ⚠️ Nothing here is provisioned automatically. These are migrations + functions ready to
> `supabase db push` / `supabase functions deploy` against a project you create.

## Layout

```
supabase/
├── migrations/
│   ├── 0001_schema.sql   # tables, enums, indexes (multi-tenant; every row carries org_id)
│   ├── 0002_rls.sql      # Row-Level Security — tenant isolation (existential for a security vendor)
│   └── 0003_seed.sql     # threat domains, badges, the starter Phishing lesson
└── functions/
    ├── complete-session/      # server-authoritative streak/XP/badge commit (anti-cheat)
    └── recompute-risk-score/  # nightly job → Human-Risk Score snapshots for the dashboard
```

## Deploy

```bash
# 1. Create a project at supabase.com, then link it
supabase link --project-ref <your-ref>

# 2. Apply schema + RLS + seed
supabase db push

# 3. Deploy edge functions
supabase functions deploy complete-session
supabase functions deploy recompute-risk-score

# 4. Schedule the nightly risk recompute (example)
supabase functions schedule create nightly-risk \
  --function recompute-risk-score --cron "0 6 * * *"
```

Point the app at it by setting `EXPO_PUBLIC_SUPABASE_URL` and
`EXPO_PUBLIC_SUPABASE_ANON_KEY` (see `../reveal-risk/.env.example`). The app's
`src/lib/supabase.ts` auto-detects config and routes session commits through the
`complete-session` function.

## Design notes

- **Tenant isolation via RLS** — `auth_org_id()` / `is_manager()` helpers gate every
  tenant table. A user only ever reads rows in their own org; managers get org-wide read.
  Content tables (`threat_domains`, `lessons`, `challenges`, …) are world-readable to
  authenticated users.
- **Server-authoritative scoring** — clients never write `streaks`, `user_stats`, or
  `human_risk_scores`. Those are written only by the edge functions using the service role,
  which recompute XP from the canonical `challenges.xp` values (ignoring client claims).
- **Human-Risk Score is a methodology** — `recompute-risk-score` blends recency-windowed
  per-domain accuracy (risk-weighted) with an engagement factor. Weights are placeholders
  to tune with Reveal Risk; frame the score as growth, not surveillance (mind GDPR /
  employee-monitoring law).
- **Content is data-driven** — `challenges.payload` is polymorphic JSONB matching
  `reveal-risk/src/data/types.ts`, so consultants can author challenges without code.
- **Enterprise SSO/SCIM** (WorkOS/Auth0) bolts onto Supabase Auth — see BUILD_PLAN.md §1.
