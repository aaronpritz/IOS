import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { Button } from '../components/ui/Button';
import { MysteryBox } from '../components/rewards/MysteryBox';
import { SparkAvatar } from '../components/brand/SparkAvatar';
import { useGameStore, SessionResult, badgeMeta } from '../store/useGameStore';
import { LessonSummary } from './LessonScreen';

interface Props {
  summary: LessonSummary;
  onDone: () => void;
}

/** Session complete: streak increment, XP, accuracy, and the variable-reward mystery box. */
export function ResultsScreen({ summary, onDone }: Props) {
  // Commit the session exactly once (updates streak / XP / badges).
  const [outcome, setOutcome] = useState<SessionResult | null>(null);
  useEffect(() => {
    const store = useGameStore.getState();
    store.markLessonComplete(summary.lessonId);
    setOutcome(store.completeSession(summary.xpEarned));
  }, []);

  if (!outcome) return null;

  const accuracy = Math.round((summary.correct / summary.total) * 100);
  const reward = outcome.newBadge
    ? badgeMeta(outcome.newBadge)
    : { icon: '💎', name: '+5 Bonus Gems' };

  return (
    <View style={styles.container}>
      <View style={styles.hero}>
        <SparkAvatar size={84} mood="cheer" />
        <Text style={styles.flame}>🔥</Text>
        <Text style={styles.streakNum}>{outcome.streak}</Text>
        <Text style={styles.streakLabel}>
          {outcome.streakIncreased ? `Day ${outcome.streak} streak!` : 'Streak kept!'}
        </Text>
        {outcome.leveledUp && <Text style={styles.levelUp}>⭐ Level up!</Text>}
      </View>

      <View style={styles.statsRow}>
        <Stat icon="⚡" value={`+${summary.xpEarned}`} label="XP earned" tint={colors.xp} />
        <Stat icon="🎯" value={`${accuracy}%`} label="accuracy" tint={colors.primary} />
        <Stat icon="❤️" value={`${summary.heartsRemaining}`} label="shields" tint={colors.heart} />
      </View>

      <View style={styles.rewardCard}>
        <Text style={styles.rewardTitle}>Surprise reward</Text>
        <MysteryBox reward={{ icon: reward.icon, label: reward.name }} />
      </View>

      <View style={{ flex: 1 }} />

      <Button label="Continue" onPress={onDone} />
    </View>
  );
}

function Stat({ icon, value, label, tint }: { icon: string; value: string; label: string; tint: string }) {
  return (
    <View style={styles.stat}>
      <Text style={styles.statIcon}>{icon}</Text>
      <Text style={[styles.statValue, { color: tint }]}>{value}</Text>
      <Text style={styles.statLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg, padding: 24, paddingTop: 40 },
  hero: { alignItems: 'center', marginBottom: 24 },
  flame: { fontSize: 72 },
  streakNum: { fontSize: 56, fontWeight: '900', color: colors.streak, marginTop: -6 },
  streakLabel: { fontSize: font.h2, fontWeight: '800', color: colors.text },
  levelUp: { marginTop: 8, fontSize: font.h3, fontWeight: '800', color: colors.xp },
  statsRow: { flexDirection: 'row', gap: 10, marginBottom: 22 },
  stat: {
    flex: 1,
    backgroundColor: colors.surface,
    borderRadius: radius.lg,
    borderWidth: 1,
    borderColor: colors.border,
    paddingVertical: 14,
    alignItems: 'center',
    gap: 2,
  },
  statIcon: { fontSize: 20 },
  statValue: { fontSize: font.h2, fontWeight: '900' },
  statLabel: { fontSize: font.tiny, color: colors.textMuted, fontWeight: '600' },
  rewardCard: {
    backgroundColor: colors.surface,
    borderRadius: radius.xl,
    borderWidth: 1,
    borderColor: colors.border,
    padding: 20,
    alignItems: 'center',
    gap: 12,
  },
  rewardTitle: { fontSize: font.body, fontWeight: '800', color: colors.textMuted, letterSpacing: 0.5 },
});
