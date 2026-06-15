import { create } from 'zustand';
import { persist, createJSONStorage, StateStorage } from 'zustand/middleware';

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

export interface SessionResult {
  streak: number;
  streakIncreased: boolean;
  xpEarned: number;
  newBadge: string | null;
  leveledUp: boolean;
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
  /** First-run onboarding completed + the chosen preferences. */
  onboarded: boolean;
  focusDomain: string | null;
  dailyGoal: number;
  reminderTime: string | null;
  /** Dev toggle: simulate the passage of days to test streak logic. */
  dayOffset: number;

  // selectors
  level: () => number;
  xpIntoLevel: () => number;
  xpForLevel: () => number;

  // actions
  loseHeart: () => void;
  refillHearts: () => void;
  completeSession: (xpEarned: number) => SessionResult;
  markLessonComplete: (lessonId: string) => void;
  completeOnboarding: (prefs: { focusDomain: string; dailyGoal: number; reminderTime: string }) => void;
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
      onboarded: false,
      focusDomain: null,
      dailyGoal: 1,
      reminderTime: null,
      dayOffset: 0,

      level: () => Math.floor(get().xp / XP_PER_LEVEL) + 1,
      xpIntoLevel: () => get().xp % XP_PER_LEVEL,
      xpForLevel: () => XP_PER_LEVEL,

      loseHeart: () => set((s) => ({ hearts: Math.max(0, s.hearts - 1) })),
      refillHearts: () => set({ hearts: MAX_HEARTS }),

      markLessonComplete: (lessonId) =>
        set((s) =>
          s.completedLessons.includes(lessonId)
            ? s
            : { completedLessons: [...s.completedLessons, lessonId] }
        ),

      completeOnboarding: (prefs) =>
        set({
          onboarded: true,
          focusDomain: prefs.focusDomain,
          dailyGoal: prefs.dailyGoal,
          reminderTime: prefs.reminderTime,
        }),

      completeSession: (xpEarned) => {
        const s = get();
        const today = dateKey(s.dayOffset);
        const levelBefore = Math.floor(s.xp / XP_PER_LEVEL) + 1;

        // Streak logic: same day = no change; consecutive day = +1; gap = reset to 1.
        let streak = s.streak;
        let streakIncreased = false;
        if (s.lastActiveDate === today) {
          // already practiced today — streak unchanged
        } else if (s.lastActiveDate && daysBetween(s.lastActiveDate, today) === 1) {
          streak = s.streak + 1;
          streakIncreased = true;
        } else {
          streak = 1;
          streakIncreased = true;
        }

        const xp = s.xp + xpEarned;
        const leveledUp = Math.floor(xp / XP_PER_LEVEL) + 1 > levelBefore;

        // Variable reward: award a badge on the first session and on milestone streaks.
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

        set({
          streak,
          longestStreak: Math.max(s.longestStreak, streak),
          lastActiveDate: today,
          xp,
          badges,
        });

        return { streak, streakIncreased, xpEarned, newBadge, leveledUp };
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
          onboarded: false,
          focusDomain: null,
          dailyGoal: 1,
          reminderTime: null,
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
        onboarded: s.onboarded,
        focusDomain: s.focusDomain,
        dailyGoal: s.dailyGoal,
        reminderTime: s.reminderTime,
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
