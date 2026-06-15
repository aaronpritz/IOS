import React, { useEffect, useMemo, useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { Button } from '../components/ui/Button';
import { MysteryBox } from '../components/rewards/MysteryBox';
import { SparkAvatar } from '../components/brand/SparkAvatar';
import { CelebrationOverlay } from '../components/rewards/CelebrationOverlay';
import { useGameStore, SessionResult, badgeMeta } from '../store/useGameStore';
import { LessonSummary } from './LessonScreen';

interface Props {
  summary: LessonSummary;
  onDone: () => void;
}

const STREAK_MILESTONES = [3, 7, 14, 30, 50, 100];

/** Session complete: streak increment, XP, accuracy, and the variable-reward mystery box. */
export function ResultsScreen({ summary, onDone }: Props) {
  // Commit the session exactly once (updates streak / XP / badges).
  const [outcome, setOutcome] = useState<SessionResult | null>(null);
  const [celebrated, setCelebrated] = useState(false);
  const level = useGameStore((s) => s.level());
  useEffect(() => {
    const store = useGameStore.getState();
    // Review sessions don't count as path-lesson completions.
    if (summary.lessonId !== 'review') store.markLessonComplete(summary.lessonId);
    setOutcome(store.completeSession(summary.xpEarned, summary.correct === summary.total));
  }, []);

  // Pick the celebration "cutscene" for a milestone, if any.
  const celebration = useMemo(() => {
    if (!outcome) return null;
    if (outcome.leveledUp) return { title: 'Level Up!', subtitle: `You reached Level ${level}` };
    if (outcome.streakIncreased && STREAK_MILESTONES.includes(outcome.streak))
      return { title: `${outcome.streak}-Day Streak!`, subtitle: 'You’re on fire — keep it going' };
    if (outcome.newBadge) {
      const m = badgeMeta(outcome.newBadge);
      return { title: 'Badge Unlocked!', subtitle: `${m.icon}  ${m.name}` };
    }
    return null;
  }, [outcome, level]);

  if (!outcome) return null;

  const accuracy = Math.round((summary.correct / summary.total) * 100);
  const reward = outcome.newBadge
    ? badgeMeta(outcome.newBadge)
    : { icon: '💎', name: `+${outcome.gemsEarned} Gems` };

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
        {outcome.freezeUsed && <Text style={styles.freeze}>🧊 Streak freeze used — streak saved!</Text>}
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

      {celebration && !celebrated && (
        <CelebrationOverlay
          title={celebration.title}
          subtitle={celebration.subtitle}
          onDone={() => setCelebrated(true)}
        />
      )}
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
  freeze: { marginTop: 6, fontSize: font.small, fontWeight: '700', color: colors.gem },
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
