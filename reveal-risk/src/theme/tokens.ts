/**
 * Reveal Risk design tokens.
 * Light, friendly, consumer-grade feel (Duolingo-inspired) with a security-pro accent.
 */
export const colors = {
  bg: '#F4F7FB',
  surface: '#FFFFFF',
  surfaceAlt: '#EEF3F9',
  border: '#E2E8F0',
  borderStrong: '#CBD5E1',

  text: '#10243E',
  textMuted: '#5B6B80',
  textInverse: '#FFFFFF',

  primary: '#12B886', // emerald — CTA / correct
  primaryDark: '#0C9A72',
  navy: '#163058', // Reveal Risk deep navy

  streak: '#FF9F1C', // amber flame
  heart: '#FF4D6D', // shields/hearts
  xp: '#4C6EF5', // indigo XP
  gem: '#22B8CF', // cyan gems

  danger: '#FA5252',
  warn: '#F59F00',

  locked: '#C2CCD6',
  shadow: 'rgba(16, 36, 62, 0.12)',
} as const;

export const radius = {
  sm: 8,
  md: 12,
  lg: 18,
  xl: 26,
  pill: 999,
} as const;

export const spacing = (n: number) => n * 4;

export const font = {
  h1: 30,
  h2: 22,
  h3: 18,
  body: 15,
  small: 13,
  tiny: 11,
} as const;
