import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { Button } from '../components/ui/Button';
import { SpotThePhish } from '../components/challenges/SpotThePhish';
import { Mcq } from '../components/challenges/Mcq';
import { BranchingScenario } from '../components/challenges/BranchingScenario';
import { PasswordStrength } from '../components/challenges/PasswordStrength';
import { getLesson } from '../data/lessons';
import { useGameStore } from '../store/useGameStore';

export interface LessonSummary {
  xpEarned: number;
  correct: number;
  total: number;
  heartsRemaining: number;
}

interface Props {
  lessonId: string;
  onComplete: (summary: LessonSummary) => void;
  onExit: () => void;
}

/** The full-screen lesson player that drives the challenge sequence. */
export function LessonScreen({ lessonId, onComplete, onExit }: Props) {
  const lesson = getLesson(lessonId);
  const hearts = useGameStore((s) => s.hearts);
  const loseHeart = useGameStore((s) => s.loseHeart);
  const refillHearts = useGameStore((s) => s.refillHearts);

  const [index, setIndex] = useState(0);
  const [xpEarned, setXpEarned] = useState(0);
  const [correct, setCorrect] = useState(0);
  const [result, setResult] = useState<{ isCorrect: boolean; mistakes: number } | null>(null);

  const challenge = lesson.challenges[index];
  const progress = (index + (result ? 1 : 0)) / lesson.challenges.length;
  const outOfHearts = hearts <= 0;

  function handleResult(r: { isCorrect: boolean; mistakes: number }) {
    setResult(r);
    if (r.isCorrect) {
      setCorrect((c) => c + 1);
      setXpEarned((x) => x + challenge.xp);
    } else {
      setXpEarned((x) => x + Math.round(challenge.xp / 2));
    }
    for (let i = 0; i < r.mistakes; i++) loseHeart();
  }

  function next() {
    if (index + 1 >= lesson.challenges.length) {
      onComplete({
        xpEarned,
        correct: correct,
        total: lesson.challenges.length,
        heartsRemaining: useGameStore.getState().hearts,
      });
    } else {
      setIndex((i) => i + 1);
      setResult(null);
    }
  }

  if (outOfHearts && !result) {
    return (
      <View style={styles.center}>
        <Text style={styles.bigEmoji}>💔</Text>
        <Text style={styles.title}>Out of shields!</Text>
        <Text style={styles.sub}>
          You ran out of shields. In the real app you’d wait for a refill, spend gems, or
          practice to earn them back.
        </Text>
        <View style={{ width: '100%', gap: 10, marginTop: 20 }}>
          <Button label="Refill shields (demo)" onPress={refillHearts} />
          <Button label="Exit lesson" variant="secondary" onPress={onExit} />
        </View>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {/* Top bar: exit, progress, hearts */}
      <View style={styles.topbar}>
        <Pressable onPress={onExit} hitSlop={10}>
          <Text style={styles.exit}>✕</Text>
        </Pressable>
        <View style={styles.progressTrack}>
          <View style={[styles.progressFill, { width: `${progress * 100}%` }]} />
        </View>
        <Text style={styles.heartsText}>❤️ {hearts}</Text>
      </View>

      <View style={styles.body}>
        {challenge.type === 'spot_the_phish' && challenge.payload.type === 'spot_the_phish' && (
          <SpotThePhish payload={challenge.payload} onResult={handleResult} />
        )}
        {challenge.type === 'mcq' && challenge.payload.type === 'mcq' && (
          <Mcq payload={challenge.payload} onResult={handleResult} />
        )}
        {challenge.type === 'branching_scenario' &&
          challenge.payload.type === 'branching_scenario' && (
            <BranchingScenario payload={challenge.payload} onResult={handleResult} />
          )}
        {challenge.type === 'password_strength' &&
          challenge.payload.type === 'password_strength' && (
            <PasswordStrength payload={challenge.payload} onResult={handleResult} />
          )}
      </View>

      {/* Feedback footer */}
      {result && (
        <View style={[styles.footer, { backgroundColor: result.isCorrect ? '#E6F7F0' : '#FDECEE' }]}>
          <Text style={[styles.footerTitle, { color: result.isCorrect ? colors.primaryDark : colors.danger }]}>
            {result.isCorrect ? '✅ Nice — clean catch!' : `⚠️ ${result.mistakes} miss${result.mistakes === 1 ? '' : 'es'} · ${result.mistakes} shield${result.mistakes === 1 ? '' : 's'} lost`}
          </Text>
          <Text style={styles.footerExplain}>{challenge.explanation}</Text>
          <Button
            label={index + 1 >= lesson.challenges.length ? 'Finish' : 'Continue'}
            variant={result.isCorrect ? 'primary' : 'danger'}
            onPress={next}
          />
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg },
  topbar: { flexDirection: 'row', alignItems: 'center', gap: 12, padding: 14 },
  exit: { fontSize: 22, color: colors.textMuted, fontWeight: '700' },
  progressTrack: { flex: 1, height: 12, backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, overflow: 'hidden' },
  progressFill: { height: '100%', backgroundColor: colors.primary, borderRadius: radius.pill },
  heartsText: { fontSize: font.body, fontWeight: '800', color: colors.heart },
  body: { flex: 1, paddingHorizontal: 16, paddingTop: 6 },
  footer: { padding: 16, borderTopLeftRadius: radius.xl, borderTopRightRadius: radius.xl, gap: 10 },
  footerTitle: { fontSize: font.h3, fontWeight: '800' },
  footerExplain: { fontSize: font.small, color: colors.text, lineHeight: 19 },
  center: { flex: 1, alignItems: 'center', justifyContent: 'center', padding: 28, backgroundColor: colors.bg },
  bigEmoji: { fontSize: 64, marginBottom: 8 },
  title: { fontSize: font.h1, fontWeight: '900', color: colors.text, marginBottom: 8 },
  sub: { fontSize: font.body, color: colors.textMuted, textAlign: 'center', lineHeight: 22 },
});
