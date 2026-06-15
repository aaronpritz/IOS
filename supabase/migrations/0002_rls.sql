-- Row-Level Security: tenant isolation is existential for a security vendor.
-- A user may only ever read/write rows inside their own org; managers/admins
-- get broader read within their org. Content tables are world-readable.

-- ---------------------------------------------------------------------------
-- Helper functions (security definer) read the caller's profile once.
-- ---------------------------------------------------------------------------
create or replace function auth_org_id() returns uuid
  language sql stable security definer set search_path = public as $$
  select org_id from profiles where id = auth.uid()
$$;

create or replace function auth_role() returns user_role
  language sql stable security definer set search_path = public as $$
  select role from profiles where id = auth.uid()
$$;

create or replace function is_manager() returns boolean
  language sql stable security definer set search_path = public as $$
  select coalesce(auth_role() in ('manager','org_admin','rr_admin'), false)
$$;

-- ---------------------------------------------------------------------------
-- Enable RLS everywhere
-- ---------------------------------------------------------------------------
alter table orgs                enable row level security;
alter table teams               enable row level security;
alter table profiles            enable row level security;
alter table streaks             enable row level security;
alter table user_stats          enable row level security;
alter table wallets             enable row level security;
alter table attempts            enable row level security;
alter table lesson_completions  enable row level security;
alter table reward_events       enable row level security;
alter table leagues             enable row level security;
alter table league_memberships  enable row level security;
alter table user_badges         enable row level security;
alter table human_risk_scores   enable row level security;

-- Content tables: readable by any authenticated user, writable only by service role.
alter table threat_domains   enable row level security;
alter table units            enable row level security;
alter table lessons          enable row level security;
alter table challenges       enable row level security;
alter table badges           enable row level security;
alter table content_versions enable row level security;

create policy content_read_domains   on threat_domains   for select to authenticated using (true);
create policy content_read_units     on units            for select to authenticated using (true);
create policy content_read_lessons   on lessons          for select to authenticated using (true);
create policy content_read_chal      on challenges       for select to authenticated using (true);
create policy content_read_badges    on badges           for select to authenticated using (true);
create policy content_read_versions  on content_versions for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- Org / team
-- ---------------------------------------------------------------------------
create policy org_read  on orgs  for select using (id = auth_org_id());
create policy team_read on teams for select using (org_id = auth_org_id());

-- ---------------------------------------------------------------------------
-- Profiles: read others in your org; only edit yourself.
-- ---------------------------------------------------------------------------
create policy profile_read_org   on profiles for select using (org_id = auth_org_id());
create policy profile_update_self on profiles for update using (id = auth.uid()) with check (id = auth.uid());

-- ---------------------------------------------------------------------------
-- Own gamification rows: a user sees only their own streak/stats/wallet.
-- (Writes are performed by edge functions using the service role.)
-- ---------------------------------------------------------------------------
create policy streak_self    on streaks    for select using (user_id = auth.uid());
create policy stats_self      on user_stats for select using (user_id = auth.uid());
create policy wallet_self     on wallets    for select using (user_id = auth.uid());
create policy badges_self     on user_badges for select using (user_id = auth.uid());
create policy rewards_self    on reward_events for select using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- Attempts: a user reads their own; managers read their whole org.
-- A user may insert attempts only for themselves within their org.
-- ---------------------------------------------------------------------------
create policy attempts_read on attempts for select
  using (user_id = auth.uid() or (is_manager() and org_id = auth_org_id()));
create policy attempts_insert on attempts for insert
  with check (user_id = auth.uid() and org_id = auth_org_id());

create policy completions_read on lesson_completions for select
  using (user_id = auth.uid() or (is_manager() and org_id = auth_org_id()));

-- ---------------------------------------------------------------------------
-- Leagues & memberships: visible within the org.
-- ---------------------------------------------------------------------------
create policy leagues_read on leagues for select using (org_id = auth_org_id());
create policy league_mem_read on league_memberships for select
  using (exists (select 1 from leagues l where l.id = league_id and l.org_id = auth_org_id()));

-- ---------------------------------------------------------------------------
-- Human-Risk Scores: a user sees their own; managers see all subjects in org.
-- ---------------------------------------------------------------------------
create policy risk_read on human_risk_scores for select
  using (
    (subject_kind = 'user' and subject_id = auth.uid())
    or (is_manager() and org_id = auth_org_id())
  );
