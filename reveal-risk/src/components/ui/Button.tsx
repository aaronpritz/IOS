import React from 'react';
import { Pressable, Text, StyleSheet, ViewStyle, View } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';

type Variant = 'primary' | 'secondary' | 'danger' | 'ghost';

interface Props {
  label: string;
  onPress: () => void;
  variant?: Variant;
  disabled?: boolean;
  style?: ViewStyle;
}

/** Chunky, tactile button with a playful 3D bottom edge. */
export function Button({ label, onPress, variant = 'primary', disabled, style }: Props) {
  const tint = TINTS[variant];
  return (
    <Pressable
      onPress={onPress}
      disabled={disabled}
      style={({ pressed }) => [
        styles.wrap,
        { opacity: disabled ? 0.45 : 1, transform: [{ translateY: pressed && !disabled ? 3 : 0 }] },
        style,
      ]}
    >
      <View style={[styles.edge, { backgroundColor: tint.edge }]}>
        <View style={[styles.face, { backgroundColor: tint.face, borderColor: tint.edge }]}>
          <Text style={[styles.label, { color: tint.text }]}>{label}</Text>
        </View>
      </View>
    </Pressable>
  );
}

const TINTS: Record<Variant, { face: string; edge: string; text: string }> = {
  primary: { face: colors.primary, edge: colors.primaryDark, text: '#fff' },
  secondary: { face: colors.surface, edge: colors.borderStrong, text: colors.text },
  danger: { face: colors.danger, edge: '#D9434E', text: '#fff' },
  ghost: { face: 'transparent', edge: 'transparent', text: colors.textMuted },
};

const styles = StyleSheet.create({
  wrap: { width: '100%' },
  edge: { borderRadius: radius.lg, paddingBottom: 4 },
  face: {
    borderRadius: radius.lg,
    paddingVertical: 15,
    paddingHorizontal: 18,
    alignItems: 'center',
    borderBottomWidth: 0,
  },
  label: { fontSize: font.h3, fontWeight: '800', letterSpacing: 0.3 },
});
