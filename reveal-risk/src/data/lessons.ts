import { Lesson, Challenge } from './types';
import { PHISHING_LESSON } from './phishingLesson';
import { PASSWORDS_LESSON } from './passwordsLesson';
import { FAKE_LOGIN_LESSON } from './fakeLoginLesson';
import { DEEPFAKE_LESSON } from './deepfakeLesson';
import { SOCIAL_ENG_LESSON } from './socialEngLesson';
import { useGameStore } from '../store/useGameStore';

/** All lessons keyed by id. The backend serves these from the `lessons` table. */
export const LESSONS: Record<string, Lesson> = {
  [PHISHING_LESSON.id]: PHISHING_LESSON,
  [PASSWORDS_LESSON.id]: PASSWORDS_LESSON,
  [FAKE_LOGIN_LESSON.id]: FAKE_LOGIN_LESSON,
  [DEEPFAKE_LESSON.id]: DEEPFAKE_LESSON,
  [SOCIAL_ENG_LESSON.id]: SOCIAL_ENG_LESSON,
};

export const REVIEW_LESSON_ID = 'review';

/** Every challenge across all lessons, keyed by id (for review lookups). */
function allChallenges(): Map<string, Challenge> {
  const m = new Map<string, Challenge>();
  Object.values(LESSONS).forEach((l) => l.challenges.forEach((c) => m.set(c.id, c)));
  return m;
}

/** Builds a spaced-repetition session from the user's missed challenges (max 6). */
export function buildReviewLesson(): Lesson {
  const missed = useGameStore.getState().missedChallenges;
  const all = allChallenges();
  const challenges = missed
    .map((id) => all.get(id))
    .filter((c): c is Challenge => Boolean(c))
    .slice(0, 6);
  return { id: REVIEW_LESSON_ID, domainKey: challenges[0]?.domainKey ?? 'phishing', title: 'Review', estSeconds: 90, challenges };
}

export function getLesson(id: string): Lesson {
  if (id === REVIEW_LESSON_ID) {
    const r = buildReviewLesson();
    return r.challenges.length ? r : PHISHING_LESSON;
  }
  return LESSONS[id] ?? PHISHING_LESSON;
}

/** The ordered learning path on the home screen. `lessonId: null` = coming soon. */
export interface JourneyNode {
  id: string;
  lessonId: string | null;
  title: string;
  icon: string;
  domainKey: string;
}

export const PATH_NODES: JourneyNode[] = [
  { id: 'n1', lessonId: PHISHING_LESSON.id, title: 'Spot the Phish', icon: '🎣', domainKey: 'phishing' },
  { id: 'n2', lessonId: PASSWORDS_LESSON.id, title: 'Strong Passwords', icon: '🔑', domainKey: 'passwords' },
  { id: 'n3', lessonId: FAKE_LOGIN_LESSON.id, title: 'Fake Login Pages', icon: '🪪', domainKey: 'phishing' },
  { id: 'n4', lessonId: DEEPFAKE_LESSON.id, title: 'Deepfake Voices', icon: '🤖', domainKey: 'ai_deepfakes' },
  { id: 'n5', lessonId: SOCIAL_ENG_LESSON.id, title: 'Social Engineering', icon: '🎭', domainKey: 'social_eng' },
];

/** Lessons that belong to each domain (for mastery %). */
export function lessonsInDomain(domainKey: string): string[] {
  return Object.values(LESSONS)
    .filter((l) => l.domainKey === domainKey)
    .map((l) => l.id);
}

