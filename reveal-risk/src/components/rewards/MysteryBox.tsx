import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable, Animated } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';

interface Props {
  /** The variable reward revealed when opened. */
  reward: { icon: string; label: string };
}

/** Tap-to-open variable reward — the "Hooked" surprise that lands the dopamine. */
export function MysteryBox({ reward }: Props) {
  const [open, setOpen] = useState(false);
  const scale = useState(new Animated.Value(1))[0];

  function openBox() {
    if (open) return;
    Animated.sequence([
      Animated.timing(scale, { toValue: 1.15, duration: 120, useNativeDriver: true }),
      Animated.spring(scale, { toValue: 1, friction: 4, useNativeDriver: true }),
    ]).start();
    setOpen(true);
  }

  return (
    <View style={styles.wrap}>
      <Pressable onPress={openBox} disabled={open}>
        <Animated.View style={[styles.box, open && styles.boxOpen, { transform: [{ scale }] }]}>
          <Text style={styles.boxIcon}>{open ? reward.icon : '🎁'}</Text>
        </Animated.View>
      </Pressable>
      <Text style={styles.caption}>
        {open ? reward.label : 'Tap to open your reward!'}
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  wrap: { alignItems: 'center', gap: 8 },
  box: {
    width: 96,
    height: 96,
    borderRadius: radius.lg,
    backgroundColor: colors.surfaceAlt,
    borderWidth: 2,
    borderColor: colors.borderStrong,
    borderStyle: 'dashed',
    alignItems: 'center',
    justifyContent: 'center',
  },
  boxOpen: {
    backgroundColor: '#FFF6E6',
    borderColor: colors.streak,
    borderStyle: 'solid',
  },
  boxIcon: { fontSize: 48 },
  caption: { fontSize: font.body, fontWeight: '700', color: colors.text },
});
