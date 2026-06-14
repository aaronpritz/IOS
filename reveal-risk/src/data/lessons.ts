import { Lesson } from './types';
import { PHISHING_LESSON } from './phishingLesson';
import { PASSWORDS_LESSON } from './passwordsLesson';

/** All lessons keyed by id. The backend serves these from the `lessons` table. */
export const LESSONS: Record<string, Lesson> = {
  [PHISHING_LESSON.id]: PHISHING_LESSON,
  [PASSWORDS_LESSON.id]: PASSWORDS_LESSON,
};

export function getLesson(id: string): Lesson {
  return LESSONS[id] ?? PHISHING_LESSON;
}
