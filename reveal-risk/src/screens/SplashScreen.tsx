import React from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { colors, font, radius } from '../theme/tokens';
import { SparkAvatar } from '../components/brand/SparkAvatar';

interface Props {
  onDone: () => void;
}

/**
 * Opening splash — designed natively (no device-mockup image) so it always looks
 * right. Transparent illustrated Spark on a branded navy backdrop with the
 * CyberSpark wordmark. Waits for a tap (matches the "tap to start" prompt).
 */
export function SplashScreen({ onDone }: Props) {
  return (
    <Pressable style={styles.root} onPress={onDone} accessibilityLabel="Skip intro">
      {/* Ambient brand glow */}
      <View style={[styles.glow, styles.glowTop]} />
      <View style={[styles.glow, styles.glowBottom]} />

      <View style={styles.center}>
        <SparkAvatar size={150} mood="cheer" />
        <Text style={styles.wordmark}>
          Cyber<Text style={{ color: colors.primary }}>Spark</Text>
        </Text>
        <Text style={styles.tagline}>Cyber skills, one streak at a time</Text>
      </View>

      <View style={styles.bottom} pointerEvents="none">
        <View style={styles.startBtn}>
          <Text style={styles.startText}>Tap to start  →</Text>
        </View>
        <View style={styles.byTag}>
          <Text style={styles.byText}>by Reveal Risk</Text>
        </View>
      </View>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  root: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    zIndex: 100,
  },
  glow: { position: 'absolute', width: 320, height: 320, borderRadius: 160, opacity: 0.18 },
  glowTop: { backgroundColor: colors.primary, top: -120, right: -90 },
  glowBottom: { backgroundColor: colors.gem, bottom: -110, left: -80 },
  center: { alignItems: 'center', gap: 10, paddingHorizontal: 24 },
  wordmark: { fontSize: 44, fontWeight: '900', color: '#fff', marginTop: 10, letterSpacing: 0.5 },
  tagline: { fontSize: font.h3, color: 'rgba(255,255,255,0.85)', fontWeight: '600', textAlign: 'center' },
  bottom: { position: 'absolute', bottom: 34, alignItems: 'center', gap: 14 },
  startBtn: {
    backgroundColor: colors.primary,
    borderRadius: radius.pill,
    paddingHorizontal: 28,
    paddingVertical: 14,
  },
  startText: { color: '#fff', fontWeight: '900', fontSize: font.h3, letterSpacing: 0.5 },
  byTag: {
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.3)',
    borderRadius: radius.pill,
    paddingHorizontal: 14,
    paddingVertical: 6,
  },
  byText: { color: 'rgba(255,255,255,0.85)', fontWeight: '700', fontSize: font.small },
});
