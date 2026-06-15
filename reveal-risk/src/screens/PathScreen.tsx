import React, { useMemo } from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { Hud } from '../components/hud/Hud';
import { SparkAvatar } from '../components/brand/SparkAvatar';
import { DailyQuests } from '../components/quests/DailyQuests';
import { Button } from '../components/ui/Button';
import { PHISHING_LESSON } from '../data/phishingLesson';
import { PATH_NODES } from '../data/lessons';
import { THREAT_DOMAINS } from '../data/domains';
import { useGameStore } from '../store/useGameStore';

interface Props {
  onStartLesson: (lessonId: string) => void;
}

// Future domains shown as a locked roadmap rail (their lessons unlock later).
const LOCKED_DOMAINS = ['data_handling', 'physical'];

/** Home: an ordered learning path whose nodes unlock as you complete lessons. */
export function PathScreen({ onStartLesson }: Props) {
  const lastActive = useGameStore((s) => s.lastActiveDate);
  const dayOffset = useGameStore((s) => s.dayOffset);
  const completed = useGameStore((s) => s.completedLessons);
  const focusDomain = useGameStore((s) => s.focusDomain);

  const today = new Date();
  today.setDate(today.getDate() + dayOffset);
  const todayKey = today.toISOString().slice(0, 10);
  const doneToday = lastActive === todayKey;

  // Prioritize the user's chosen focus domain (stable sort keeps the rest in order).
  const nodes = useMemo(() => {
    if (!focusDomain) return PATH_NODES;
    return [...PATH_NODES].sort(
      (a, b) => (a.domainKey === focusDomain ? 0 : 1) - (b.domainKey === focusDomain ? 0 : 1)
    );
  }, [focusDomain]);
  const focusName = THREAT_DOMAINS.find((d) => d.key === focusDomain)?.name;

  // The next actionable node = first real lesson not yet completed.
  const currentIndex = nodes.findIndex((n) => n.lessonId && !completed.includes(n.lessonId));
  const currentLessonId = currentIndex >= 0 ? nodes[currentIndex].lessonId! : PHISHING_LESSON.id;

  const realNodes = nodes.filter((n) => n.lessonId);
  const doneCount = realNodes.filter((n) => completed.includes(n.lessonId!)).length;

  function nodeState(node: (typeof PATH_NODES)[number], i: number): 'done' | 'current' | 'locked' {
    if (node.lessonId && completed.includes(node.lessonId)) return 'done';
    if (i === currentIndex) return 'current';
    return 'locked';
  }

  return (
    <View style={styles.container}>
      <Hud />

      <ScrollView contentContainerStyle={{ paddingBottom: 28 }}>
        {/* Mascot greeting */}
        <View style={styles.greet}>
          <SparkAvatar size={68} />
          <View style={styles.speech}>
            <Text style={styles.speechText}>
              {doneToday
                ? 'Nice work today — your streak is safe! 🔥'
                : 'Keep your streak alive — finish today’s lesson!'}
            </Text>
          </View>
        </View>

        {/* Daily quests */}
        <DailyQuests />

        {/* Today's threat — featured lesson */}
        <Pressable style={styles.quest} onPress={() => onStartLesson(PHISHING_LESSON.id)}>
          <View style={styles.questIconWrap}>
            <Text style={styles.questIcon}>⚡</Text>
          </View>
          <View style={{ flex: 1 }}>
            <Text style={styles.questKicker}>TODAY’S THREAT</Text>
            <Text style={styles.questTitle}>AI voice-clone scam hitting finance teams</Text>
            <Text style={styles.questSub}>Spot the social-engineering red flags · +25 XP</Text>
          </View>
          <Text style={styles.questChevron}>▶</Text>
        </Pressable>

        {/* Path header with overall progress */}
        <View style={styles.pathHeader}>
          <View style={{ flex: 1 }}>
            <Text style={styles.pathKicker}>YOUR PATH{focusName ? ` · FOCUS: ${focusName.toUpperCase()}` : ''}</Text>
            <Text style={styles.pathTitle}>Security Basics</Text>
          </View>
          <Text style={styles.pathProgress}>
            {doneCount} / {realNodes.length}
          </Text>
        </View>

        {/* The winding path of lesson nodes */}
        <View style={styles.path}>
          {nodes.map((node, i) => {
            const offset = (i % 2 === 0 ? -1 : 1) * 46;
            const state = nodeState(node, i);
            const isCurrent = state === 'current';
            const isDone = state === 'done';
            const isLocked = state === 'locked';
            return (
              <View key={node.id} style={[styles.nodeRow, { transform: [{ translateX: offset }] }]}>
                <Pressable
                  disabled={isLocked || !node.lessonId}
                  onPress={() => node.lessonId && onStartLesson(node.lessonId)}
                  style={[
                    styles.node,
                    isCurrent && styles.nodeCurrent,
                    isDone && styles.nodeDone,
                    isLocked && styles.nodeLocked,
                  ]}
                >
                  <Text style={[styles.nodeIcon, isLocked && { opacity: 0.5 }]}>{node.icon}</Text>
                  {isCurrent && (
                    <View style={styles.pill}>
                      <Text style={styles.pillText}>{doneToday ? 'CONTINUE' : 'START'}</Text>
                    </View>
                  )}
                  {isDone && (
                    <View style={[styles.pill, { backgroundColor: colors.primary }]}>
                      <Text style={styles.pillText}>✓</Text>
                    </View>
                  )}
                </Pressable>
                <Text style={[styles.nodeLabel, isLocked && { color: colors.locked }]}>{node.title}</Text>
              </View>
            );
          })}
        </View>

        {/* Future threat domains (roadmap) */}
        <Text style={styles.railLabel}>MORE DOMAINS — COMING SOON</Text>
        <View style={styles.rail}>
          {LOCKED_DOMAINS.map((key) => {
            const meta = THREAT_DOMAINS.find((t) => t.key === key)!;
            return (
              <View key={key} style={[styles.railCard, styles.railCardLocked]}>
                <Text style={[styles.railIcon, { opacity: 0.45 }]}>{meta.icon}</Text>
                <Text style={[styles.railName, { color: colors.locked }]} numberOfLines={1}>
                  {meta.name}
                </Text>
                <Text style={styles.railLock}>🔒</Text>
              </View>
            );
          })}
        </View>
      </ScrollView>

      {/* Primary CTA */}
      <View style={styles.cta}>
        <Button
          label={
            currentIndex < 0
              ? 'Practice again'
              : doneToday
              ? 'Continue your path'
              : "Start today's lesson"
          }
          onPress={() => onStartLesson(currentLessonId)}
        />
        <Text style={styles.ctaHint}>~2 min · keeps your streak alive 🔥</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg },
  greet: { flexDirection: 'row', alignItems: 'center', gap: 6, paddingHorizontal: 16, paddingTop: 10 },
  speech: {
    flex: 1,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: radius.lg,
    padding: 12,
  },
  speechText: { fontSize: font.small, fontWeight: '700', color: colors.text, lineHeight: 19 },
  quest: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    marginHorizontal: 16,
    marginTop: 14,
    padding: 14,
    borderRadius: radius.lg,
    backgroundColor: colors.navy,
  },
  questIconWrap: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: 'rgba(255,255,255,0.12)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  questIcon: { fontSize: 22 },
  questKicker: { color: colors.streak, fontSize: font.tiny, fontWeight: '900', letterSpacing: 1 },
  questTitle: { color: '#fff', fontSize: font.body, fontWeight: '800', marginTop: 1 },
  questSub: { color: 'rgba(255,255,255,0.7)', fontSize: font.tiny, fontWeight: '600', marginTop: 2 },
  questChevron: { color: 'rgba(255,255,255,0.8)', fontSize: 14 },
  pathHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginHorizontal: 16,
    marginTop: 18,
    marginBottom: 4,
  },
  pathKicker: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 1 },
  pathTitle: { fontSize: font.h2, fontWeight: '900', color: colors.text },
  pathProgress: { fontSize: font.h3, fontWeight: '900', color: colors.primary },
  path: { alignItems: 'center', paddingTop: 8, gap: 6 },
  nodeRow: { alignItems: 'center', marginVertical: 10 },
  node: {
    width: 76,
    height: 76,
    borderRadius: 38,
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
    alignItems: 'center',
    justifyContent: 'center',
  },
  nodeCurrent: { borderColor: colors.primary, borderWidth: 4, backgroundColor: '#E6F7F0' },
  nodeDone: { borderColor: colors.primary, backgroundColor: '#D6F1E6' },
  nodeLocked: { backgroundColor: colors.surfaceAlt, borderStyle: 'dashed' },
  nodeIcon: { fontSize: 32 },
  nodeLabel: { marginTop: 6, fontSize: font.small, fontWeight: '700', color: colors.text },
  pill: {
    position: 'absolute',
    top: -14,
    backgroundColor: colors.streak,
    borderRadius: radius.pill,
    paddingHorizontal: 10,
    paddingVertical: 3,
  },
  pillText: { color: '#fff', fontSize: font.tiny, fontWeight: '900', letterSpacing: 0.5 },
  railLabel: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 1, marginTop: 22, marginHorizontal: 16, marginBottom: 8 },
  rail: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, paddingHorizontal: 16 },
  railCard: {
    width: '47%',
    flexGrow: 1,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: radius.md,
    padding: 12,
  },
  railCardLocked: { backgroundColor: colors.surfaceAlt, borderStyle: 'dashed' },
  railIcon: { fontSize: 22 },
  railName: { flex: 1, fontSize: font.small, fontWeight: '700', color: colors.text },
  railLock: { fontSize: 13 },
  cta: {
    padding: 16,
    borderTopWidth: 1,
    borderTopColor: colors.border,
    backgroundColor: colors.surface,
  },
  ctaHint: { textAlign: 'center', marginTop: 8, color: colors.textMuted, fontSize: font.small, fontWeight: '600' },
});
