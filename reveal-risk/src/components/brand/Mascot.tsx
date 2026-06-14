import React from 'react';
import { View, StyleSheet } from 'react-native';
import { colors } from '../../theme/tokens';

/**
 * "Vault" — Reveal Risk's mascot, built entirely from primitives so it ships
 * with the app (no external image host required). A friendly emerald shield-buddy.
 *
 * An AI-generated illustrated version also exists; drop it in as assets/mascot.png
 * and swap this component for an <Image> once the asset host is allow-listed.
 */
export function Mascot({ size = 96, mood = 'happy' }: { size?: number; mood?: 'happy' | 'cheer' }) {
  const s = size;
  const eye = s * 0.2;
  const pupil = eye * 0.5;

  return (
    <View style={{ width: s * 1.3, height: s * 1.18, alignItems: 'center', justifyContent: 'center' }}>
      {/* Arms */}
      <View style={[styles.arm, { left: s * 0.02, width: s * 0.16, height: s * 0.34, transform: [{ rotate: mood === 'cheer' ? '-35deg' : '12deg' }] }]} />
      <View style={[styles.arm, { right: s * 0.02, width: s * 0.16, height: s * 0.34, transform: [{ rotate: mood === 'cheer' ? '35deg' : '-12deg' }] }]} />

      {/* Body / shield */}
      <View style={[styles.body, { width: s, height: s, borderRadius: s * 0.34 }]}>
        {/* gloss highlight */}
        <View style={[styles.gloss, { width: s * 0.62, height: s * 0.26, borderRadius: s * 0.2, top: s * 0.1 }]} />

        {/* emblem stripe */}
        <View style={[styles.stripe, { width: s * 0.5, height: s * 0.07, borderRadius: 4, top: s * 0.2 }]} />

        {/* eyes */}
        <View style={[styles.eyesRow, { top: s * 0.38, gap: s * 0.16 }]}>
          <View style={[styles.eye, { width: eye, height: eye, borderRadius: eye / 2 }]}>
            <View style={[styles.pupil, { width: pupil, height: pupil, borderRadius: pupil / 2 }]} />
          </View>
          <View style={[styles.eye, { width: eye, height: eye, borderRadius: eye / 2 }]}>
            <View style={[styles.pupil, { width: pupil, height: pupil, borderRadius: pupil / 2 }]} />
          </View>
        </View>

        {/* smile */}
        <View
          style={[
            styles.smile,
            {
              width: s * 0.34,
              height: s * 0.17,
              borderBottomLeftRadius: s * 0.2,
              borderBottomRightRadius: s * 0.2,
              borderWidth: Math.max(2, s * 0.035),
              bottom: s * 0.16,
            },
          ]}
        />
      </View>

      {/* Feet */}
      <View style={[styles.feetRow, { gap: s * 0.12, bottom: 0 }]}>
        <View style={[styles.foot, { width: s * 0.22, height: s * 0.12, borderRadius: s * 0.06 }]} />
        <View style={[styles.foot, { width: s * 0.22, height: s * 0.12, borderRadius: s * 0.06 }]} />
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  body: {
    backgroundColor: colors.primary,
    borderWidth: 3,
    borderColor: colors.navy,
    alignItems: 'center',
  },
  gloss: { position: 'absolute', backgroundColor: 'rgba(255,255,255,0.25)' },
  stripe: { position: 'absolute', backgroundColor: colors.navy, opacity: 0.18 },
  arm: { position: 'absolute', backgroundColor: colors.primaryDark, borderRadius: 999, top: '34%' },
  eyesRow: { position: 'absolute', flexDirection: 'row' },
  eye: { backgroundColor: '#fff', alignItems: 'center', justifyContent: 'center' },
  pupil: { backgroundColor: colors.navy },
  smile: { position: 'absolute', borderColor: colors.navy, backgroundColor: 'transparent', borderTopWidth: 0 },
  feetRow: { position: 'absolute', flexDirection: 'row' },
  foot: { backgroundColor: colors.navy },
});
