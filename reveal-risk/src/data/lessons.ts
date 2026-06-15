import { Lesson } from './types';
import { PHISHING_LESSON } from './phishingLesson';
import { PASSWORDS_LESSON } from './passwordsLesson';
import { FAKE_LOGIN_LESSON } from './fakeLoginLesson';
import { DEEPFAKE_LESSON } from './deepfakeLesson';

/** All lessons keyed by id. The backend serves these from the `lessons` table. */
export const LESSONS: Record<string, Lesson> = {
  [PHISHING_LESSON.id]: PHISHING_LESSON,
  [PASSWORDS_LESSON.id]: PASSWORDS_LESSON,
  [FAKE_LOGIN_LESSON.id]: FAKE_LOGIN_LESSON,
  [DEEPFAKE_LESSON.id]: DEEPFAKE_LESSON,
};

export function getLesson(id: string): Lesson {
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
];

/** Lessons that belong to each domain (for mastery %). */
export function lessonsInDomain(domainKey: string): string[] {
  return Object.values(LESSONS)
    .filter((l) => l.domainKey === domainKey)
    .map((l) => l.id);
}

