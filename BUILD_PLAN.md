# CyberSpark — Technical Build Plan (by Reveal Risk)

Companion to `BLUEPRINT.md`. This is the engineering architecture, data model, screen map,
and phased roadmap.

---

## 1. Tech stack

**Client (single cross-platform codebase): Expo (React Native + react-native-web).**

Chosen over Flutter for decisive, environment-grounded reasons:

| Reason | Detail |
|---|---|
| Runs a web prototype **today** | `npx expo start --web` runs on pure Node — no Xcode, no macOS (our build env has neither) |
| iOS later **without a Mac** | **EAS Build** compiles iOS in Expo's cloud — a Mac is never required |
| Talent | JS/TS is ubiquitous for a consulting firm + contractors; Dart is rarer |
| Web-first manager dashboard | react-native-web renders real, accessible DOM (Flutter web paints a canvas — worse for an SEO/accessible B2B dashboard) |

**Layers**

- **Language:** TypeScript (strict).
- **Navigation:** Expo Router (file-based; deep-linkable so a push notification opens a
  specific lesson).
- **State:** **Zustand** (+ `persist`) for game state now; **TanStack Query** later for
  server cache.
- **Storage:** AsyncStorage / localStorage now → `expo-sqlite` / MMKV for offline content +
  attempt queue later.
- **Feel:** Reanimated, Lottie, Moti for the celebratory/streak animations.
- **Notifications:** `expo-notifications` (native) + web push (service worker) later.

**Future backend (Phase 3+)**

- **Supabase** (Postgres + Row-Level Security) as the spine — RLS enforces org/team
  isolation (critical multi-tenancy for a security vendor).
- **Auth/SSO:** Supabase Auth for MVP; **WorkOS / Auth0** bolted on for enterprise
  SAML SSO + SCIM provisioning.
- **Leagues:** Redis sorted sets (or Postgres materialized views) for hot weekly standings;
  a weekly cron promotes/demotes.
- **Analytics + experimentation:** **PostHog** — events, funnels, cohorts, feature flags
  **and** A/B experiments in one self-hostable tool (the closest single-tool analog to
  a best-in-class internal experimentation engine).
- **Trusted logic:** Deno edge functions for **server-authoritative** XP/streak validation,
  league rollover, Human-Risk Score computation, anti-cheat.
- **Content:** authored as **versioned JSON** in Postgres + CDN for media — data-driven so
  Reveal Risk consultants (non-engineers) can author challenges.

---

## 2. Data model

Multi-tenant B2B2C. **Every user-generated row carries `org_id`** for RLS isolation.

**Structure**
- `Org` — id, name, plan, sso_config, settings
- `Team` — id, **org_id**, name, manager_user_id
- `User` — id, **org_id**, team_id?, email, display_name, role (`employee` | `manager` |
  `org_admin` | `rr_admin`), avatar, locale, timezone
- `Streak` (1—1 User) — current_count, longest_count, last_active_date, freeze_count, timezone
- `UserStats` (1—1 User) — total_xp, level (derived), hearts_current, hearts_max, hearts_refill_at

**Content (data-driven, versioned)**
- `ThreatDomain` — key (`phishing`,`passwords`,`social_eng`,`data_handling`,`physical`,`ai_deepfakes`), name, icon, color, sort_order
- `Unit` — domain_id, title, sort_order, prerequisite_unit_id? *(defines the skill-tree ordering)*
- `Lesson` — unit_id, title, sort_order, xp_reward, est_seconds
- `Challenge` — lesson_id, **type** (`spot_the_phish` | `mcq` | `branching_scenario`),
  order, **payload (JSONB — polymorphic, type-specific)**, explanation, difficulty, domain_id
- `ContentVersion` — entity_ref, version, published_at, author_id *(safe iteration + A/B content variants)*

**Progress / economy**
- `Attempt` — user_id, challenge_id, lesson_id, **org_id**, started_at, completed_at,
  is_correct, score, hearts_lost, time_ms, answer_payload — **the source of truth for
  analytics + risk scoring**
- `LessonCompletion` — user_id, lesson_id, xp_earned, accuracy, completed_at
- `Wallet` — gems/currency (buy streak-freezes / heart refills)
- `RewardEvent` — user_id, type (`mystery_box`|`badge`|`xp_bonus`), payload, granted_at *(variable rewards)*

**Social / competitive**
- `League` — tier (Bronze…Diamond), week_start
- `LeagueMembership` — league_id, **subject_type** (`user`|`team`), subject_id, period_xp,
  rank *(one model serves individual **and** team leagues — a B2B differentiator)*
- `Badge` / `UserBadge` — earned achievements

**B2B reporting**
- `HumanRiskScore` — subject_type (`user`|`team`|`org`), subject_id, **org_id**, score
  (0–100), components (per-domain JSON), computed_at, trend — snapshotted over time;
  computed server-side from `Attempt` data, aggregated User → Team → Org.

**Relationship summary:** `Org` 1—* `Team` 1—* `User` 1—1 `Streak`/`UserStats`;
`ThreatDomain` 1—* `Unit` 1—* `Lesson` 1—* `Challenge`; `User` 1—* `Attempt` *—1 `Challenge`;
`User`/`Team` *—* `League` via `LeagueMembership`; `HumanRiskScore` aggregates up from `Attempt`.

---

## 3. Screen / navigation map (v1)

**Employee app — bottom tabs**
1. **Learn / Path (home)** — winding skill-tree trail of lesson nodes per domain
   (locked/unlocked/done). HUD: streak flame + count, XP/level bar, hearts, gems.
   "Continue" = today's 1–3 challenge micro-session.
2. **Leagues** — weekly league, your rank, promotion/demotion zones, **Individual ↔ Team**
   toggle, countdown to week end.
3. **Profile** — total XP, level, longest streak, badges grid, per-domain mastery rings,
   settings (notifications, streak-freeze inventory).

**Pushed (full-screen) stack**
- **Lesson Player** — one challenge at a time; progress bar + hearts; prompt → interact →
  **Check** → inline feedback + explanation → Continue.
- **Results / Session Complete** — XP animation, streak increment ("Day 4!"), accuracy,
  hearts left, **variable-reward mystery box**. *This is where the dopamine lands.*
- **Out of hearts** — wait for refill / spend gems / practice to earn back.
- **Onboarding** — pick focus domain, daily goal + reminder time, name/avatar.

**Manager dashboard (web-first, role-gated, Phase 3)** — `/dashboard/*`
- Overview: org/team **Human-Risk Score** gauge + trend, % active (streak health), funnel
- Team roster: employee, streak, XP, risk score, last active, weakest domain, at-risk flag
- Domain **heatmap**: where the org is weak (phishing vs passwords vs deepfakes)
- Team-vs-team leaderboards (culture driver)
- Campaign controls: assign mandatory units, deadlines, export compliance report

Navigation is Expo Router file tree: `(tabs)/learn`, `(tabs)/leagues`, `(tabs)/profile`,
`lesson/[id]`, `results`, `(dashboard)/...`. Deep links route push → `lesson/[id]`.

---

## 4. Phased roadmap

**Phase 1 — Prototype (this session).** Web-only Expo app. Mechanics: streak, XP/levels,
hearts, one rich `spot_the_phish` + MCQs, mystery-box reward, local persistence. Hardcoded
content in the real `Challenge.payload` shape, single user, no backend. *Proves the core
loop runs on Linux/web.*

**Phase 2 — MVP.** All 6 domains; full path with prerequisites; `branching_scenario` type;
streak freezes; daily-goal selection; local notifications; onboarding; offline content via
SQLite/MMKV. Ship to **TestFlight via EAS Build** (no Mac) for internal dogfooding.

**Phase 3 — B2B layer + backend.** Supabase + RLS multi-tenancy; SSO/SCIM
(WorkOS/Auth0); server-authoritative XP/streak (anti-cheat); real **leagues** (individual +
team); **Human-Risk Score** job; **manager dashboard** (web); PostHog events. *This is the
actual B2B value.*

**Phase 4 — Scale + experimentation.** PostHog feature-flag **A/B engine** on notification
copy, lesson order, reward cadence, difficulty (the engagement-engine edge); consultant content-
authoring tools (versioned variants); adaptive difficulty + spaced-repetition review;
seasons/cross-domain leaderboards; SCIM/SIEM/Slack-Teams integrations; native + web push at
scale; accessibility hardening.

---

## 5. Key risks / decisions

1. **RLS multi-tenancy must be airtight** — a security vendor leaking across orgs is
   existential. Shared DB + RLS, relentlessly enforced and pen-tested.
2. **Server-authoritative scoring (P3)** — clients can't be trusted to report XP/streak/
   **Human-Risk Score** that feed compliance reporting. The prototype's client store is an
   explicit throwaway trust model.
3. **Human-Risk Score = methodology + privacy decision**, not just code. Growth not
   surveillance; GDPR / employee-monitoring law.
4. **react-native-web parity gaps** — keep the prototype to web-safe primitives; test the
   phish-tap pointer events on web; gate native-only features behind `Platform.OS`.
5. **No Mac is permanent** — commit to EAS Build from day one (paid at volume — budget it).
6. **Content authoring is the long-term bottleneck**, not the app shell. Get the
   polymorphic `Challenge.payload` schema right early (why the prototype hardcodes data in
   the real shape).
7. **B2B SSO/SCIM is table stakes** — choosing the auth provider is a P3 gating decision;
   underestimating it stalls enterprise deals.
8. **Mystery boxes stay non-purchasable / cosmetic** — avoid App Store loot-box scrutiny.
