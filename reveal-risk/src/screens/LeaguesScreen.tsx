import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { useGameStore } from '../store/useGameStore';

/** Bot opponents for the weekly individual league (the user slots in by real XP). */
const BOTS = [
  { name: 'Priya N.', xp: 420 },
  { name: 'Marcus T.', xp: 310 },
  { name: 'Dana K.', xp: 250 },
  { name: 'Sam R.', xp: 190 },
  { name: 'Lena O.', xp: 140 },
  { name: 'Owen B.', xp: 95 },
  { name: 'Tariq F.', xp: 55 },
  { name: 'Mia C.', xp: 25 },
];

const TEAMS = [
  { name: 'Finance', xp: 2310 },
  { name: 'Engineering', xp: 1980 },
  { name: 'Sales', xp: 1750 },
  { name: 'Operations', xp: 1240 },
];

const PROMOTE = 3; // top 3 advance
const RELEGATE = 3; // bottom 3 drop

/** Weekly competitive league driven by the user's real weekly XP. */
export function LeaguesScreen() {
  const [mode, setMode] = useState<'individual' | 'team'>('individual');
  const weeklyXp = useGameStore((s) => s.weeklyXp);
  const tier = useGameStore((s) => s.leagueTier);
  const dayOffset = useGameStore((s) => s.dayOffset);

  // Days left in the Mon–Sun league week.
  const d = new Date();
  d.setDate(d.getDate() + dayOffset);
  const dow = (d.getDay() + 6) % 7; // Mon=0 … Sun=6
  const daysLeft = 6 - dow;
  const endsLabel = daysLeft <= 0 ? 'Ends today' : `Ends in ${daysLeft} day${daysLeft > 1 ? 's' : ''}`;

  const individuals = [...BOTS.map((b) => ({ ...b, me: false })), { name: 'You', xp: weeklyXp, me: true }].sort(
    (a, b) => b.xp - a.xp
  );
  const teams = [...TEAMS].sort((a, b) => b.xp - a.xp);
  const rows = mode === 'individual' ? individuals : teams;

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>🏆 {tier} League</Text>
        <Text style={styles.sub}>
          {endsLabel} · top {PROMOTE} advance, bottom {RELEGATE} drop
        </Text>
      </View>

      <View style={styles.toggle}>
        {(['individual', 'team'] as const).map((m) => (
          <Pressable key={m} onPress={() => setMode(m)} style={[styles.toggleBtn, mode === m && styles.toggleActive]}>
            <Text style={[styles.toggleText, mode === m && styles.toggleTextActive]}>
              {m === 'individual' ? 'Individual' : 'Teams'}
            </Text>
          </Pressable>
        ))}
      </View>

      <ScrollView contentContainerStyle={{ padding: 16, gap: 6 }}>
        {rows.map((row, i) => {
          const rank = i + 1;
          const promote = rank <= PROMOTE;
          const relegate = rank > rows.length - RELEGATE;
          const me = (row as any).me;
          return (
            <View key={row.name}>
              {rank === PROMOTE + 1 && <ZoneDivider label="PROMOTION ZONE" color={colors.primary} />}
              {rank === rows.length - RELEGATE + 1 && <ZoneDivider label="RELEGATION ZONE" color={colors.danger} />}
              <View style={[styles.row, me && styles.rowMe]}>
                <Text
                  style={[
                    styles.rank,
                    promote && { color: colors.primary },
                    relegate && { color: colors.danger },
                  ]}
                >
                  {rank}
                </Text>
                <Text style={[styles.name, me && { fontWeight: '900' }]}>{row.name}</Text>
                <Text style={styles.xp}>{row.xp} XP</Text>
                {rank <= 3 && <Text style={styles.medal}>{['🥇', '🥈', '🥉'][rank - 1]}</Text>}
              </View>
            </View>
          );
        })}
        <Text style={styles.note}>
          {mode === 'individual'
            ? 'Earn XP in lessons to climb. Standings update live from your weekly XP.'
            : 'Team leagues turn security into a culture sport — the B2B manager dashboard rewards it.'}
        </Text>
      </ScrollView>
    </View>
  );
}

function ZoneDivider({ label, color }: { label: string; color: string }) {
  return (
    <View style={styles.zoneRow}>
      <View style={[styles.zoneLine, { backgroundColor: color }]} />
      <Text style={[styles.zoneLabel, { color }]}>{label}</Text>
      <View style={[styles.zoneLine, { backgroundColor: color }]} />
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
  rank: { width: 22, fontSize: font.body, fontWeight: '800', color: colors.textMuted },
  name: { flex: 1, fontSize: font.body, fontWeight: '700', color: colors.text },
  xp: { fontSize: font.small, fontWeight: '800', color: colors.xp },
  medal: { fontSize: 18 },
  zoneRow: { flexDirection: 'row', alignItems: 'center', gap: 8, marginVertical: 6 },
  zoneLine: { flex: 1, height: 1.5, borderRadius: 1 },
  zoneLabel: { fontSize: font.tiny, fontWeight: '900', letterSpacing: 1 },
  note: { marginTop: 12, fontSize: font.small, color: colors.textMuted, lineHeight: 19, fontStyle: 'italic' },
});
