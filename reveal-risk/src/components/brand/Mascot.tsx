import React from 'react';
import { View } from 'react-native';
import Svg, { Path, G, Ellipse, Circle, Rect } from 'react-native-svg';
import { colors } from '../../theme/tokens';

/**
 * "Spark" — Reveal Risk's mascot: a friendly blue spiky starburst character.
 * Drawn as vector paths so it ships with the app (no external image host).
 */

const SPARK = '#2AA9E6'; // Spark's signature azure blue
const SPARK_DARK = '#1E8FCB';
const SPARK_SHADE = '#1C86C2';

/** Builds an N-point starburst polygon path string. */
function starburst(cx: number, cy: number, outer: number, inner: number, points: number): string {
  const step = Math.PI / points;
  let d = '';
  for (let i = 0; i < points * 2; i++) {
    const r = i % 2 === 0 ? outer : inner;
    const a = i * step - Math.PI / 2;
    const x = cx + r * Math.cos(a);
    const y = cy + r * Math.sin(a);
    d += `${i === 0 ? 'M' : 'L'}${x.toFixed(1)},${y.toFixed(1)} `;
  }
  return d + 'Z';
}

export function Mascot({ size = 96, mood = 'happy' }: { size?: number; mood?: 'happy' | 'cheer' }) {
  const W = size;
  const H = size * 1.12;
  const cheer = mood === 'cheer';
  // Arm endpoints raise when cheering.
  const armEndY = cheer ? 40 : 60;

  return (
    <View style={{ width: W, height: H }}>
      <Svg width={W} height={H} viewBox="0 0 120 134">
        {/* Legs (behind body) */}
        <G stroke={SPARK} strokeWidth={13} strokeLinecap="round">
          <Path d="M50,90 L46,116" />
          <Path d="M70,90 L74,116" />
        </G>
        {/* Feet */}
        <Ellipse cx="44" cy="120" rx="9" ry="6" fill={SPARK_DARK} />
        <Ellipse cx="76" cy="120" rx="9" ry="6" fill={SPARK_DARK} />

        {/* Arms (behind body) */}
        <G stroke={SPARK} strokeWidth={9} strokeLinecap="round">
          <Path d={`M28,68 L8,${armEndY}`} />
          <Path d={`M92,68 L112,${armEndY}`} />
        </G>
        <Circle cx="8" cy={armEndY} r="6" fill={SPARK} />
        <Circle cx="112" cy={armEndY} r="6" fill={SPARK} />

        {/* Spiky body */}
        <Path
          d={starburst(60, 54, 47, 29, 12)}
          fill={SPARK}
          stroke={SPARK_DARK}
          strokeWidth={2}
          strokeLinejoin="round"
        />
        {/* subtle inner shading */}
        <Circle cx="60" cy="58" r="30" fill={SPARK_SHADE} opacity={0.18} />

        {/* Eyebrows */}
        <G stroke={SPARK_DARK} strokeWidth={3.5} strokeLinecap="round" fill="none">
          <Path d="M37,36 Q47,31 56,36" />
          <Path d="M64,36 Q73,31 83,36" />
        </G>

        {/* Eyes */}
        <G>
          <Ellipse cx="48" cy="50" rx="11" ry="13" fill="#FFFFFF" />
          <Ellipse cx="72" cy="50" rx="11" ry="13" fill="#FFFFFF" />
          <Circle cx="49" cy="51" r="6.5" fill="#2E6FB0" />
          <Circle cx="71" cy="51" r="6.5" fill="#2E6FB0" />
          <Circle cx="49" cy="51" r="3.4" fill={colors.navy} />
          <Circle cx="71" cy="51" r="3.4" fill={colors.navy} />
          <Circle cx="51" cy="48.5" r="1.6" fill="#FFFFFF" />
          <Circle cx="73" cy="48.5" r="1.6" fill="#FFFFFF" />
        </G>

        {/* Big open grin */}
        <G>
          <Path d="M45,64 L75,64 Q75,82 60,82 Q45,82 45,64 Z" fill="#9E2B3E" stroke={SPARK_DARK} strokeWidth={1.5} />
          <Rect x="47" y="64" width="26" height="5.5" rx="2.5" fill="#FFFFFF" />
          <Ellipse cx="60" cy="78" rx="8.5" ry="4.5" fill="#E36B82" />
        </G>
      </Svg>
    </View>
  );
}
