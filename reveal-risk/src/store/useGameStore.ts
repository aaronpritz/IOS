import { create } from 'zustand';
import { persist, createJSONStorage, StateStorage } from 'zustand/middleware';
import { QUEST_DEFS, QUEST_CHEST_GEMS } from '../data/quests';

/**
 * The daily-loop engine: streak, XP/level, hearts, badges — persisted so a
 * returning user keeps their progress (proving the daily-return value).
 *
 * NOTE: This is a CLIENT-SIDE prototype trust model only. In production these
 * values are server-authoritative (see BUILD_PLAN.md §5) so they can't be
 * self-reported into compliance reporting.
 */

const MAX_HEARTS = 3;
const XP_PER_LEVEL = 100;
const FREEZE_COST = 50;
const HEART_REFILL_COST = 100;
const SESSION_GEMS = 5;

/** localStorage on web, in-memory fallback elsewhere — keeps the prototype web-safe. */
const memory = new Map<string, string>();
const safeStorage: StateStorage = {
  getItem: (name) => {
    try {
      if (typeof localStorage !== 'undefined') return localStorage.getItem(name);
    } catch {}
    return memory.get(name) ?? null;
  },
  setItem: (name, value) => {
    try {
      if (typeof localStorage !== 'undefined') return localStorage.setItem(name, value);
    } catch {}
    memory.set(name, value);
  },
  removeItem: (name) => {
    try {
      if (typeof localStorage !== 'undefined') return localStorage.removeItem(name);
    } catch {}
    memory.delete(name);
  },
};

/** YYYY-MM-DD for "today", shifted by the dev day-offset to simulate returning tomorrow. */
function dateKey(offsetDays: number): string {
  const d = new Date();
  d.setDate(d.getDate() + offsetDays);
  return d.toISOString().slice(0, 10);
}

function daysBetween(a: string, b: string): number {
  const ms = new Date(b + 'T00:00:00').getTime() - new Date(a + 'T00:00:00').getTime();
  return Math.round(ms / 86400000);
}

/** Monday-of-week key for the league period, shifted by the dev day-offset. */
function weekStartKey(offsetDays: number): string {
  const d = new Date();
  d.setDate(d.getDate() + offsetDays);
  const dow = (d.getDay() + 6) % 7; // Monday = 0
  d.setDate(d.getDate() - dow);
  return d.toISOString().slice(0, 10);
}

export interface SessionResult {
  streak: number;
  streakIncreased: boolean;
  xpEarned: number;
  newBadge: string | null;
  leveledUp: boolean;
  freezeUsed: boolean;
  gemsEarned: number;
}

interface GameState {
  streak: number;
  longestStreak: number;
  lastActiveDate: string | null;
  xp: number;
  hearts: number;
  badges: string[];
  /** Lesson ids the user has completed (drives path unlocks + domain mastery). */
  completedLessons: string[];
  /** Challenge ids answered incorrectly — resurfaced in spaced-repetition review. */
  missedChallenges: string[];
  /** First-run onboarding completed + the chosen preferences. */
  onboarded: boolean;
  focusDomain: string | null;
  dailyGoal: number;
  reminderTime: string | null;
  /** Gems currency + owned streak freezes (the economy). */
  gems: number;
  streakFreezes: number;
  /** Weekly league XP + the current league period and tier. */
  weeklyXp: number;
  leagueWeekStart: string | null;
  leagueTier: string;
  /** Daily-quest progress (resets each day). */
  questDate: string | null;
  questXp: number;
  questLessons: number;
  questPerfect: number;
  questClaimed: boolean;
  /** Dev toggle: simulate the passage of days to test streak logic. */
  dayOffset: number;

  // selectors
  level: () => number;
  xpIntoLevel: () => number;
  xpForLevel: () => number;
  questsComplete: () => boolean;

  // actions
  loseHeart: () => void;
  refillHearts: () => void;
  completeSession: (xpEarned: number, perfect?: boolean) => SessionResult;
  markLessonComplete: (lessonId: string) => void;
  addMissedChallenge: (id: string) => void;
  removeMissedChallenge: (id: string) => void;
  completeOnboarding: (prefs: { focusDomain: string; dailyGoal: number; reminderTime: string }) => void;
  buyStreakFreeze: () => boolean;
  buyHeartRefill: () => boolean;
  claimDailyQuests: () => boolean;
  advanceDay: () => void;
  resetProgress: () => void;
}

export const useGameStore = create<GameState>()(
  persist(
    (set, get) => ({
      streak: 0,
      longestStreak: 0,
      lastActiveDate: null,
      xp: 0,
      hearts: MAX_HEARTS,
      badges: [],
      completedLessons: [],
      missedChallenges: [],
      onboarded: false,
      focusDomain: null,
      dailyGoal: 1,
      reminderTime: null,
      gems: 30,
      streakFreezes: 0,
      weeklyXp: 0,
      leagueWeekStart: null,
      leagueTier: 'Silver',
      questDate: null,
      questXp: 0,
      questLessons: 0,
      questPerfect: 0,
      questClaimed: false,
      dayOffset: 0,

      level: () => Math.floor(get().xp / XP_PER_LEVEL) + 1,
      xpIntoLevel: () => get().xp % XP_PER_LEVEL,
      xpForLevel: () => XP_PER_LEVEL,
      questsComplete: () => {
        const s = get();
        return QUEST_DEFS.every((q) => (s[q.field] as number) >= q.goal);
      },

      loseHeart: () => set((s) => ({ hearts: Math.max(0, s.hearts - 1) })),
      refillHearts: () => set({ hearts: MAX_HEARTS }),

      markLessonComplete: (lessonId) =>
        set((s) =>
          s.completedLessons.includes(lessonId)
            ? s
            : { completedLessons: [...s.completedLessons, lessonId] }
        ),

      addMissedChallenge: (id) =>
        set((s) => (s.missedChallenges.includes(id) ? s : { missedChallenges: [...s.missedChallenges, id] })),

      removeMissedChallenge: (id) =>
        set((s) => ({ missedChallenges: s.missedChallenges.filter((x) => x !== id) })),

      completeOnboarding: (prefs) =>
        set({
          onboarded: true,
          focusDomain: prefs.focusDomain,
          dailyGoal: prefs.dailyGoal,
          reminderTime: prefs.reminderTime,
        }),

      completeSession: (xpEarned, perfect = false) => {
        const s = get();
        const today = dateKey(s.dayOffset);
        const wk = weekStartKey(s.dayOffset);
        const levelBefore = Math.floor(s.xp / XP_PER_LEVEL) + 1;

        // Streak logic with freeze protection.
        let streak = s.streak;
        let streakIncreased = false;
        let streakFreezes = s.streakFreezes;
        let freezeUsed = false;
        if (s.lastActiveDate === today) {
          // already practiced today — streak unchanged
        } else if (s.lastActiveDate && daysBetween(s.lastActiveDate, today) === 1) {
          streak = s.streak + 1;
          streakIncreased = true;
        } else if (s.lastActiveDate && daysBetween(s.lastActiveDate, today) > 1 && streakFreezes > 0) {
          // Missed a day, but a streak freeze saves it.
          streak = s.streak + 1;
          streakIncreased = true;
          streakFreezes -= 1;
          freezeUsed = true;
        } else {
          streak = 1;
          streakIncreased = true;
        }

        const xp = s.xp + xpEarned;
        const leveledUp = Math.floor(xp / XP_PER_LEVEL) + 1 > levelBefore;

        // Weekly league XP — reset when a new league week starts.
        const weeklyXp = s.leagueWeekStart === wk ? s.weeklyXp + xpEarned : xpEarned;

        // Daily quests — reset progress on a new day, then add this session.
        const sameDay = s.questDate === today;
        const questXp = (sameDay ? s.questXp : 0) + xpEarned;
        const questLessons = (sameDay ? s.questLessons : 0) + 1;
        const questPerfect = Math.min(1, (sameDay ? s.questPerfect : 0) + (perfect ? 1 : 0));
        const questClaimed = sameDay ? s.questClaimed : false;

        // Variable reward: award a badge on the first session and on milestones.
        let newBadge: string | null = null;
        const badges = [...s.badges];
        if (!badges.includes('first_steps')) {
          newBadge = 'first_steps';
        } else if (streakIncreased && [3, 7, 14, 30].includes(streak)) {
          newBadge = `streak_${streak}`;
        } else if (leveledUp) {
          newBadge = `level_${Math.floor(xp / XP_PER_LEVEL) + 1}`;
        }
        if (newBadge && !badges.includes(newBadge)) badges.push(newBadge);

        // Gems: a small per-session reward (the mystery box) when no badge dropped.
        const gemsEarned = newBadge ? 0 : SESSION_GEMS;

        set({
          streak,
          longestStreak: Math.max(s.longestStreak, streak),
          lastActiveDate: today,
          xp,
          badges,
          streakFreezes,
          weeklyXp,
          leagueWeekStart: wk,
          questDate: today,
          questXp,
          questLessons,
          questPerfect,
          questClaimed,
          gems: s.gems + gemsEarned,
        });

        return { streak, streakIncreased, xpEarned, newBadge, leveledUp, freezeUsed, gemsEarned };
      },

      buyStreakFreeze: () => {
        const s = get();
        if (s.gems < FREEZE_COST) return false;
        set({ gems: s.gems - FREEZE_COST, streakFreezes: s.streakFreezes + 1 });
        return true;
      },

      buyHeartRefill: () => {
        const s = get();
        if (s.gems < HEART_REFILL_COST || s.hearts >= MAX_HEARTS) return false;
        set({ gems: s.gems - HEART_REFILL_COST, hearts: MAX_HEARTS });
        return true;
      },

      claimDailyQuests: () => {
        const s = get();
        const done = QUEST_DEFS.every((q) => (s[q.field] as number) >= q.goal);
        if (!done || s.questClaimed) return false;
        set({ gems: s.gems + QUEST_CHEST_GEMS, questClaimed: true });
        return true;
      },

      advanceDay: () => set((s) => ({ dayOffset: s.dayOffset + 1 })),

      resetProgress: () =>
        set({
          streak: 0,
          longestStreak: 0,
          lastActiveDate: null,
          xp: 0,
          hearts: MAX_HEARTS,
          badges: [],
          completedLessons: [],
          missedChallenges: [],
          onboarded: false,
          focusDomain: null,
          dailyGoal: 1,
          reminderTime: null,
          gems: 30,
          streakFreezes: 0,
          weeklyXp: 0,
          leagueWeekStart: null,
          leagueTier: 'Silver',
          questDate: null,
          questXp: 0,
          questLessons: 0,
          questPerfect: 0,
          questClaimed: false,
          dayOffset: 0,
        }),
    }),
    {
      name: 'reveal-risk-game-v1',
      storage: createJSONStorage(() => safeStorage),
      partialize: (s) => ({
        streak: s.streak,
        longestStreak: s.longestStreak,
        lastActiveDate: s.lastActiveDate,
        xp: s.xp,
        hearts: s.hearts,
        badges: s.badges,
        completedLessons: s.completedLessons,
        missedChallenges: s.missedChallenges,
        onboarded: s.onboarded,
        focusDomain: s.focusDomain,
        dailyGoal: s.dailyGoal,
        reminderTime: s.reminderTime,
        gems: s.gems,
        streakFreezes: s.streakFreezes,
        weeklyXp: s.weeklyXp,
        leagueWeekStart: s.leagueWeekStart,
        leagueTier: s.leagueTier,
        questDate: s.questDate,
        questXp: s.questXp,
        questLessons: s.questLessons,
        questPerfect: s.questPerfect,
        questClaimed: s.questClaimed,
        dayOffset: s.dayOffset,
      }),
    }
  )
);

export const BADGE_LABELS: Record<string, { icon: string; name: string }> = {
  first_steps: { icon: '🛡️', name: 'First Steps' },
  streak_3: { icon: '🔥', name: '3-Day Streak' },
  streak_7: { icon: '🔥', name: '7-Day Streak' },
  streak_14: { icon: '🔥', name: '14-Day Streak' },
  streak_30: { icon: '🏆', name: '30-Day Streak' },
};

export function badgeMeta(key: string): { icon: string; name: string } {
  if (BADGE_LABELS[key]) return BADGE_LABELS[key];
  if (key.startsWith('level_')) return { icon: '⭐', name: `Level ${key.split('_')[1]}` };
  if (key.startsWith('streak_')) return { icon: '🔥', name: `${key.split('_')[1]}-Day Streak` };
  return { icon: '🎖️', name: 'Badge' };
}
