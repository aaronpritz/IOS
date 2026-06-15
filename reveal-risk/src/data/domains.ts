import { ThreatDomain } from './types';
import { colors } from '../theme/tokens';

/** The six threat domains that form the skill tree (BLUEPRINT.md §3). */
export const THREAT_DOMAINS: ThreatDomain[] = [
  { key: 'phishing', name: 'Phishing', icon: '🎣', color: colors.primary },
  { key: 'passwords', name: 'Passwords', icon: '🔑', color: colors.xp },
  { key: 'social_eng', name: 'Social Engineering', icon: '🎭', color: colors.warn },
  { key: 'data_handling', name: 'Data Handling', icon: '🗂️', color: colors.gem },
  { key: 'physical', name: 'Physical', icon: '🚪', color: colors.navy },
  { key: 'ai_deepfakes', name: 'AI & Deepfakes', icon: '🤖', color: colors.heart },
];
