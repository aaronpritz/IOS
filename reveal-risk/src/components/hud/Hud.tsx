import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { useGameStore } from '../../store/useGameStore';

/** Top heads-up display: streak flame, XP/level bar, and hearts — the always-visible loop status. */
export function Hud() {
  const streak = useGameStore((s) => s.streak);
  const hearts = useGameStore((s) => s.hearts);
  const level = useGameStore((s) => s.level());
  const xpInto = useGameStore((s) => s.xpIntoLevel());
  const xpFor = useGameStore((s) => s.xpForLevel());
  const pct = Math.max(0, Math.min(1, xpInto / xpFor));

  return (
    <View style={styles.row}>
      <Stat icon="🔥" value={String(streak)} tint={colors.streak} label="streak" />

      <View style={styles.xpWrap}>
        <View style={styles.xpHeader}>
          <Text style={styles.lvl}>LVL {level}</Text>
          <Text style={styles.xpText}>
            {xpInto}/{xpFor} XP
          </Text>
        </View>
        <View style={styles.track}>
          <View style={[styles.fill, { width: `${pct * 100}%` }]} />
        </View>
      </View>

      <Stat icon="❤️" value={String(hearts)} tint={colors.heart} label="shields" />
    </View>
  );
}

function Stat({ icon, value, tint, label }: { icon: string; value: string; tint: string; label: string }) {
  return (
    <View style={styles.stat} accessibilityLabel={`${value} ${label}`}>
      <Text style={styles.statIcon}>{icon}</Text>
      <Text style={[styles.statValue, { color: tint }]}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    paddingHorizontal: 16,
    paddingVertical: 10,
  },
  stat: { flexDirection: 'row', alignItems: 'center', gap: 4 },
  statIcon: { fontSize: 18 },
  statValue: { fontSize: font.h3, fontWeight: '800' },
  xpWrap: { flex: 1 },
  xpHeader: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
  lvl: { fontSize: font.tiny, fontWeight: '800', color: colors.xp, letterSpacing: 0.5 },
  xpText: { fontSize: font.tiny, color: colors.textMuted, fontWeight: '600' },
  track: {
    height: 10,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radius.pill,
    overflow: 'hidden',
  },
  fill: { height: '100%', backgroundColor: colors.xp, borderRadius: radius.pill },
});
