import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { useGameStore } from '../../store/useGameStore';

/** Mock teammates — wired to real org membership via the backend in Phase 3. */
const TEAMMATES = [
  { id: 'priya', name: 'Priya', emoji: '👩🏽‍💼', streak: 23, xp: 540 },
  { id: 'marcus', name: 'Marcus', emoji: '🧑🏻‍💻', streak: 9, xp: 410 },
  { id: 'dana', name: 'Dana', emoji: '👩🏼‍🔧', streak: 2, xp: 120 },
  { id: 'sam', name: 'Sam', emoji: '🧑🏿‍🎓', streak: 0, xp: 80 },
];

/**
 * "Your Squad" — teammate streaks + a friend-streak highlight. The social hook:
 * shared streaks and gentle nudges drive team-wide daily habit (B2B culture).
 */
export function Squad() {
  const myStreak = useGameStore((s) => s.streak);
  const myXp = useGameStore((s) => s.xp);
  const [nudged, setNudged] = useState<Record<string, boolean>>({});

  const people = [
    ...TEAMMATES,
    { id: 'me', name: 'You', emoji: '🧑‍💻', streak: myStreak, xp: myXp, me: true },
  ].sort((a, b) => b.streak - a.streak);

  // Friend streak = consecutive days you and your top teammate both kept a streak.
  const topMate = TEAMMATES[0];
  const friendStreak = Math.min(myStreak, topMate.streak);

  return (
    <View style={styles.card}>
      <Text style={styles.title}>YOUR SQUAD</Text>

      {friendStreak > 0 && (
        <View style={styles.friendStreak}>
          <Text style={styles.friendStreakIcon}>🔥</Text>
          <Text style={styles.friendStreakText}>
            <Text style={{ fontWeight: '900' }}>{friendStreak}-day</Text> friend streak with {topMate.name}!
          </Text>
        </View>
      )}

      {people.map((p) => {
        const me = (p as any).me;
        const done = nudged[p.id];
        return (
          <View key={p.id} style={[styles.row, me && styles.rowMe]}>
            <Text style={styles.avatar}>{p.emoji}</Text>
            <View style={{ flex: 1 }}>
              <Text style={[styles.name, me && { fontWeight: '900' }]}>{p.name}</Text>
              <Text style={styles.sub}>{p.xp} XP</Text>
            </View>
            <Text style={styles.streak}>{p.streak} 🔥</Text>
            {!me &&
              (p.streak === 0 ? (
                <Pressable
                  onPress={() => setNudged((n) => ({ ...n, [p.id]: true }))}
                  style={[styles.nudge, done && styles.nudged]}
                >
                  <Text style={[styles.nudgeText, done && { color: colors.primary }]}>
                    {done ? 'Nudged ✓' : '👋 Nudge'}
                  </Text>
                </Pressable>
              ) : (
                <View style={{ width: 70 }} />
              ))}
          </View>
        );
      })}
      <Text style={styles.note}>Nudge a teammate whose streak is at risk — keep the team’s habit alive.</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  card: { backgroundColor: colors.surface, borderRadius: radius.lg, borderWidth: 1, borderColor: colors.border, padding: 16, gap: 10 },
  title: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 1 },
  friendStreak: { flexDirection: 'row', alignItems: 'center', gap: 8, backgroundColor: '#FFF6E6', borderRadius: radius.md, padding: 10 },
  friendStreakIcon: { fontSize: 20 },
  friendStreakText: { flex: 1, fontSize: font.small, color: colors.text, fontWeight: '600' },
  row: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  rowMe: { backgroundColor: '#E6F7F0', borderRadius: radius.md, paddingHorizontal: 8, paddingVertical: 4, marginHorizontal: -8 },
  avatar: { fontSize: 26 },
  name: { fontSize: font.body, fontWeight: '700', color: colors.text },
  sub: { fontSize: font.tiny, color: colors.textMuted, fontWeight: '600' },
  streak: { fontSize: font.body, fontWeight: '800', color: colors.streak, minWidth: 48, textAlign: 'right' },
  nudge: { backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, paddingHorizontal: 12, paddingVertical: 6, width: 70, alignItems: 'center' },
  nudged: { backgroundColor: '#E6F7F0' },
  nudgeText: { fontSize: font.tiny, fontWeight: '800', color: colors.navy },
  note: { fontSize: font.tiny, color: colors.textMuted, fontStyle: 'italic', lineHeight: 17 },
});
