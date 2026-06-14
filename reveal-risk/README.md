# Reveal Risk — Cyber Training Prototype

A runnable prototype of the **"Duolingo for cybersecurity"** daily-streak loop.
Cross-platform (Expo / React Native + react-native-web) so it runs on iOS, Android, **and
the browser** — which is how you demo it here (no Xcode/Mac required).

See [`../BLUEPRINT.md`](../BLUEPRINT.md) (strategy) and [`../BUILD_PLAN.md`](../BUILD_PLAN.md)
(architecture + roadmap) for the full concept.

## Run it (browser)

```bash
cd reveal-risk
npm install
npm run web        # opens the Metro web dev server (localhost:8081)
```

Or build a static bundle:

```bash
npx expo export --platform web   # outputs to dist/
```

## What the prototype demonstrates (the daily loop)

1. **Path / Home** — the Phishing skill-tree, with the live HUD: 🔥 streak · ⚡ XP/level ·
   ❤️ shields. Tap **Start today's challenge**.
2. **Lesson Player** — a richly interactive **Spot-the-Phish**: tap the red flags in a fake
   Microsoft 365 email, press **Check**, and see per-flag rationale. A wrong tap or a missed
   flag costs a shield. Followed by 2 quick multiple-choice questions = a believable
   ~2-minute, 3-challenge micro-session.
3. **Results** — "Day N streak!" with XP, accuracy, shields left, and a **tap-to-open
   mystery box** (variable reward → a badge or bonus). Returns to the path with everything
   **persisted** (refresh the page — your streak/XP survive).

Other tabs are v1 stubs that preview the B2B story:
- **Leagues** — weekly league with an **Individual ↔ Teams** toggle (team leagues are the
  B2B culture driver).
- **Profile** — stats, badges, per-domain mastery, and the per-user **Human-Risk Score**.

### Dev controls (top bar)
- **+1 day** — simulate returning tomorrow to watch the streak increment (or reset on a gap).
- **reset** — wipe local progress.

## How this maps to the real model

All content is hardcoded in `src/data/` but authored in the **real `Challenge.payload`
shape** (`src/data/types.ts`) so it's forward-compatible with the future Supabase backend.
The game engine (`src/store/useGameStore.ts`) is a **client-side prototype trust model
only** — in production, streak/XP/Human-Risk Score are server-authoritative (see
`BUILD_PLAN.md §5`).

## Structure

```
App.tsx                         # root: tabs + lesson/results flow + dev panel
src/
  theme/tokens.ts               # design tokens
  data/{types,domains,phishingLesson}.ts   # types mirror the backend model + seed content
  store/useGameStore.ts         # streak / XP / hearts engine (Zustand + persist)
  components/
    hud/Hud.tsx                 # streak · XP · shields HUD
    challenges/SpotThePhish.tsx # the flagship interactive challenge
    challenges/Mcq.tsx
    rewards/MysteryBox.tsx      # variable-reward box
    ui/Button.tsx
  screens/{Path,Lesson,Results,Leagues,Profile}Screen.tsx
```
