import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { useGameStore } from '../store/useGameStore';

/**
 * Static mock of the weekly league (B2B differentiator: Individual ↔ Team toggle).
 * Wired to real leaderboards in Phase 3.
 */
export function LeaguesScreen() {
  const [mode, setMode] = useState<'individual' | 'team'>('individual');
  const myXp = useGameStore((s) => s.xp);

  const individuals = [
    { name: 'Priya (Finance)', xp: 540 },
    { name: 'Marcus (Sales)', xp: 410 },
    { name: 'You', xp: myXp, me: true },
    { name: 'Dana (Ops)', xp: 120 },
    { name: 'Sam (IT)', xp: 80 },
  ].sort((a, b) => b.xp - a.xp);

  const teams = [
    { name: 'Finance', xp: 2310 },
    { name: 'Engineering', xp: 1980 },
    { name: 'Sales', xp: 1750 },
    { name: 'Operations', xp: 1240 },
  ].sort((a, b) => b.xp - a.xp);

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>🏆 Diamond League</Text>
        <Text style={styles.sub}>Ends in 3 days · top 3 advance</Text>
      </View>

      <View style={styles.toggle}>
        {(['individual', 'team'] as const).map((m) => (
          <Pressable
            key={m}
            onPress={() => setMode(m)}
            style={[styles.toggleBtn, mode === m && styles.toggleActive]}
          >
            <Text style={[styles.toggleText, mode === m && styles.toggleTextActive]}>
              {m === 'individual' ? 'Individual' : 'Teams'}
            </Text>
          </Pressable>
        ))}
      </View>

      <ScrollView contentContainerStyle={{ padding: 16, gap: 8 }}>
        {(mode === 'individual' ? individuals : teams).map((row, i) => (
          <View
            key={row.name}
            style={[styles.row, (row as any).me && styles.rowMe, i < 3 && styles.rowTop]}
          >
            <Text style={styles.rank}>{i + 1}</Text>
            <Text style={[styles.name, (row as any).me && { fontWeight: '900' }]}>{row.name}</Text>
            <Text style={styles.xp}>{row.xp} XP</Text>
            {i < 3 && <Text style={styles.medal}>{['🥇', '🥈', '🥉'][i]}</Text>}
          </View>
        ))}
        <Text style={styles.note}>
          Team leagues turn security into a culture sport — exactly what a manager dashboard
          rewards in the B2B tier.
        </Text>
      </ScrollView>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg },
  header: { padding: 16, paddingBottom: 4 },
  title: { fontSize: font.h1, fontWeight: '900', color: colors.text },
  sub: { fontSize: font.small, color: colors.textMuted, marginTop: 2, fontWeight: '600' },
  toggle: { flexDirection: 'row', gap: 8, paddingHorizontal: 16, marginTop: 8 },
  toggleBtn: { flex: 1, paddingVertical: 10, borderRadius: radius.pill, backgroundColor: colors.surfaceAlt, alignItems: 'center' },
  toggleActive: { backgroundColor: colors.navy },
  toggleText: { fontWeight: '800', color: colors.textMuted },
  toggleTextActive: { color: '#fff' },
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    backgroundColor: colors.surface,
    borderRadius: radius.md,
    borderWidth: 1,
    borderColor: colors.border,
    paddingVertical: 12,
    paddingHorizontal: 14,
  },
  rowMe: { borderColor: colors.primary, borderWidth: 2, backgroundColor: '#E6F7F0' },
  rowTop: { backgroundColor: '#FFFDF5' },
  rank: { width: 22, fontSize: font.body, fontWeight: '800', color: colors.textMuted },
  name: { flex: 1, fontSize: font.body, fontWeight: '700', color: colors.text },
  xp: { fontSize: font.small, fontWeight: '800', color: colors.xp },
  medal: { fontSize: 18 },
  note: { marginTop: 12, fontSize: font.small, color: colors.textMuted, lineHeight: 19, fontStyle: 'italic' },
});
