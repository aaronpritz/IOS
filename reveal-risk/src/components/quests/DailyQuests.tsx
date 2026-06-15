import React from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { QUEST_DEFS, QUEST_CHEST_GEMS } from '../../data/quests';
import { useGameStore } from '../../store/useGameStore';

/** The 3 daily quests with progress bars and a claimable gem chest. */
export function DailyQuests() {
  const questXp = useGameStore((s) => s.questXp);
  const questLessons = useGameStore((s) => s.questLessons);
  const questPerfect = useGameStore((s) => s.questPerfect);
  const questClaimed = useGameStore((s) => s.questClaimed);
  const claim = useGameStore((s) => s.claimDailyQuests);

  const values: Record<string, number> = { questXp, questLessons, questPerfect };
  const allDone = QUEST_DEFS.every((q) => values[q.field] >= q.goal);

  return (
    <View style={styles.card}>
      <View style={styles.header}>
        <Text style={styles.title}>DAILY QUESTS</Text>
        <Text style={styles.chest}>{questClaimed ? '✅' : allDone ? '🎁' : '📦'}</Text>
      </View>

      {QUEST_DEFS.map((q) => {
        const v = Math.min(values[q.field], q.goal);
        const done = v >= q.goal;
        return (
          <View key={q.id} style={styles.quest}>
            <Text style={styles.qIcon}>{q.icon}</Text>
            <View style={{ flex: 1 }}>
              <View style={styles.qTop}>
                <Text style={styles.qLabel}>{q.label}</Text>
                <Text style={[styles.qProg, done && { color: colors.primary }]}>
                  {v}/{q.goal}{done ? ' ✓' : ''}
                </Text>
              </View>
              <View style={styles.track}>
                <View style={[styles.fill, { width: `${(v / q.goal) * 100}%` }]} />
              </View>
            </View>
          </View>
        );
      })}

      {allDone && !questClaimed && (
        <Pressable style={styles.claimBtn} onPress={() => claim()}>
          <Text style={styles.claimText}>Open chest  ·  +{QUEST_CHEST_GEMS} 💎</Text>
        </Pressable>
      )}
      {questClaimed && <Text style={styles.claimed}>Chest claimed — see you tomorrow! 🎉</Text>}
    </View>
  );
}

const styles = StyleSheet.create({
  card: {
    marginHorizontal: 16,
    marginTop: 14,
    padding: 14,
    borderRadius: radius.lg,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    gap: 10,
  },
  header: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  title: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 1 },
  chest: { fontSize: 20 },
  quest: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  qIcon: { fontSize: 20, width: 24, textAlign: 'center' },
  qTop: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 4 },
  qLabel: { fontSize: font.small, fontWeight: '700', color: colors.text },
  qProg: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted },
  track: { height: 8, backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, overflow: 'hidden' },
  fill: { height: '100%', backgroundColor: colors.streak, borderRadius: radius.pill },
  claimBtn: { backgroundColor: colors.streak, borderRadius: radius.md, paddingVertical: 11, alignItems: 'center', marginTop: 2 },
  claimText: { color: '#fff', fontWeight: '900', fontSize: font.body },
  claimed: { fontSize: font.small, color: colors.primary, fontWeight: '700', textAlign: 'center', marginTop: 2 },
});
