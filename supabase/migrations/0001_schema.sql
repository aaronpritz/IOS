-- Reveal Risk Cyber App — core schema (Phase 3)
-- Multi-tenant B2B2C. Every tenant row carries org_id and is protected by RLS.
-- See BUILD_PLAN.md §2 for the model and §5 for the trust boundary.

create extension if not exists "pgcrypto";

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------
create type user_role as enum ('employee', 'manager', 'org_admin', 'rr_admin');
create type challenge_type as enum ('spot_the_phish', 'mcq', 'branching_scenario');
create type league_tier as enum ('bronze', 'silver', 'gold', 'diamond');
create type subject_type as enum ('user', 'team', 'org');
create type reward_type as enum ('mystery_box', 'badge', 'xp_bonus');

-- ---------------------------------------------------------------------------
-- Tenancy: orgs, teams, profiles
-- ---------------------------------------------------------------------------
create table orgs (
  id          uuid primary key default gen_random_uuid(),
  name        text not null,
  plan        text not null default 'trial',
  sso_config  jsonb not null default '{}'::jsonb,
  settings    jsonb not null default '{}'::jsonb,
  created_at  timestamptz not null default now()
);

create table teams (
  id              uuid primary key default gen_random_uuid(),
  org_id          uuid not null references orgs(id) on delete cascade,
  name            text not null,
  manager_user_id uuid,
  created_at      timestamptz not null default now()
);
create index on teams (org_id);

-- profiles extends Supabase auth.users (1:1 by id)
create table profiles (
  id            uuid primary key references auth.users(id) on delete cascade,
  org_id        uuid not null references orgs(id) on delete cascade,
  team_id       uuid references teams(id) on delete set null,
  email         text not null,
  display_name  text not null default 'New User',
  role          user_role not null default 'employee',
  avatar        text,
  locale        text not null default 'en',
  timezone      text not null default 'UTC',
  created_at    timestamptz not null default now()
);
create index on profiles (org_id);
create index on profiles (team_id);

alter table teams
  add constraint teams_manager_fk
  foreign key (manager_user_id) references profiles(id) on delete set null;

-- ---------------------------------------------------------------------------
-- Per-user gamification state (server-authoritative)
-- ---------------------------------------------------------------------------
create table streaks (
  user_id          uuid primary key references profiles(id) on delete cascade,
  current_count    int not null default 0,
  longest_count    int not null default 0,
  last_active_date date,
  freeze_count     int not null default 0,
  timezone         text not null default 'UTC'
);

create table user_stats (
  user_id          uuid primary key references profiles(id) on delete cascade,
  total_xp         int not null default 0,
  level            int not null default 1,
  hearts_current   int not null default 3,
  hearts_max       int not null default 3,
  hearts_refill_at timestamptz
);

create table wallets (
  user_id uuid primary key references profiles(id) on delete cascade,
  gems    int not null default 0
);

-- ---------------------------------------------------------------------------
-- Content (data-driven, versioned) — global, not tenant-scoped
-- ---------------------------------------------------------------------------
create table threat_domains (
  key        text primary key,             -- 'phishing', 'passwords', ...
  name       text not null,
  icon       text not null,
  color      text not null,
  sort_order int not null default 0
);

create table units (
  id                   uuid primary key default gen_random_uuid(),
  domain_key           text not null references threat_domains(key),
  title                text not null,
  sort_order           int not null default 0,
  prerequisite_unit_id uuid references units(id)
);
create index on units (domain_key);

create table lessons (
  id          uuid primary key default gen_random_uuid(),
  unit_id     uuid not null references units(id) on delete cascade,
  title       text not null,
  sort_order  int not null default 0,
  xp_reward   int not null default 0,
  est_seconds int not null default 120
);
create index on lessons (unit_id);

create table challenges (
  id          uuid primary key default gen_random_uuid(),
  lesson_id   uuid not null references lessons(id) on delete cascade,
  domain_key  text not null references threat_domains(key),
  type        challenge_type not null,
  ordinal     int not null default 0,
  payload     jsonb not null,              -- polymorphic, type-specific
  explanation text not null default '',
  difficulty  int not null default 1,
  xp          int not null default 10
);
create index on challenges (lesson_id);

create table content_versions (
  id           uuid primary key default gen_random_uuid(),
  entity_ref   text not null,              -- e.g. 'challenge:<id>'
  version      int not null,
  published_at timestamptz,
  author_id    uuid references profiles(id)
);

-- ---------------------------------------------------------------------------
-- Progress / economy (tenant-scoped)
-- ---------------------------------------------------------------------------
create table attempts (
  id             uuid primary key default gen_random_uuid(),
  org_id         uuid not null references orgs(id) on delete cascade,
  user_id        uuid not null references profiles(id) on delete cascade,
  challenge_id   uuid not null references challenges(id),
  lesson_id      uuid not null references lessons(id),
  domain_key     text not null references threat_domains(key),
  started_at     timestamptz not null default now(),
  completed_at   timestamptz,
  is_correct     boolean,
  score          int,
  hearts_lost    int not null default 0,
  time_ms        int,
  answer_payload jsonb
);
create index on attempts (org_id);
create index on attempts (user_id, completed_at);
create index on attempts (domain_key);

create table lesson_completions (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references orgs(id) on delete cascade,
  user_id      uuid not null references profiles(id) on delete cascade,
  lesson_id    uuid not null references lessons(id),
  xp_earned    int not null default 0,
  accuracy     numeric(5,2),
  completed_at timestamptz not null default now()
);
create index on lesson_completions (user_id);

create table reward_events (
  id         uuid primary key default gen_random_uuid(),
  org_id     uuid not null references orgs(id) on delete cascade,
  user_id    uuid not null references profiles(id) on delete cascade,
  type       reward_type not null,
  payload    jsonb not null default '{}'::jsonb,
  granted_at timestamptz not null default now()
);
create index on reward_events (user_id);

-- ---------------------------------------------------------------------------
-- Social / competitive
-- ---------------------------------------------------------------------------
create table leagues (
  id         uuid primary key default gen_random_uuid(),
  org_id     uuid not null references orgs(id) on delete cascade,
  tier       league_tier not null,
  week_start date not null
);
create index on leagues (org_id, week_start);

create table league_memberships (
  id           uuid primary key default gen_random_uuid(),
  league_id    uuid not null references leagues(id) on delete cascade,
  subject_kind subject_type not null,      -- 'user' or 'team'
  subject_id   uuid not null,              -- profiles.id or teams.id
  period_xp    int not null default 0,
  rank         int
);
create index on league_memberships (league_id);

create table badges (
  key         text primary key,
  name        text not null,
  description text not null default '',
  icon        text not null,
  criteria    jsonb not null default '{}'::jsonb
);

create table user_badges (
  user_id   uuid not null references profiles(id) on delete cascade,
  badge_key text not null references badges(key),
  earned_at timestamptz not null default now(),
  primary key (user_id, badge_key)
);

-- ---------------------------------------------------------------------------
-- B2B reporting: Human-Risk Score (server-computed snapshots)
-- ---------------------------------------------------------------------------
create table human_risk_scores (
  id           uuid primary key default gen_random_uuid(),
  org_id       uuid not null references orgs(id) on delete cascade,
  subject_kind subject_type not null,
  subject_id   uuid not null,             -- user | team | org id
  score        int not null check (score between 0 and 100),
  components   jsonb not null default '{}'::jsonb,   -- per-domain sub-scores
  computed_at  timestamptz not null default now()
);
create index on human_risk_scores (org_id, subject_kind, subject_id, computed_at desc);
