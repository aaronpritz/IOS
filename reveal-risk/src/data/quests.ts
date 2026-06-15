/** Daily quests — 3 goals that reset each day, with a gem chest when all complete. */
export interface QuestDef {
  id: string;
  label: string;
  icon: string;
  goal: number;
  /** Which store counter tracks progress for this quest. */
  field: 'questXp' | 'questLessons' | 'questPerfect';
}

export const QUEST_DEFS: QuestDef[] = [
  { id: 'xp', label: 'Earn 30 XP', icon: '⚡', goal: 30, field: 'questXp' },
  { id: 'lessons', label: 'Complete 2 lessons', icon: '📘', goal: 2, field: 'questLessons' },
  { id: 'perfect', label: 'Finish a perfect lesson', icon: '🎯', goal: 1, field: 'questPerfect' },
];

export const QUEST_CHEST_GEMS = 25;
