import React from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { Hud } from '../components/hud/Hud';
import { Mascot } from '../components/brand/Mascot';
import { Button } from '../components/ui/Button';
import { PHISHING_PATH, PHISHING_LESSON } from '../data/phishingLesson';
import { THREAT_DOMAINS } from '../data/domains';
import { useGameStore } from '../store/useGameStore';

interface Props {
  onStartLesson: (lessonId: string) => void;
}

/** Home: the skill-tree path for the Phishing domain + the "today's challenge" CTA. */
export function PathScreen({ onStartLesson }: Props) {
  const lastActive = useGameStore((s) => s.lastActiveDate);
  const dayOffset = useGameStore((s) => s.dayOffset);
  const domain = THREAT_DOMAINS.find((d) => d.key === 'phishing')!;

  // "Done today" if last active matches the simulated today.
  const today = new Date();
  today.setDate(today.getDate() + dayOffset);
  const todayKey = today.toISOString().slice(0, 10);
  const doneToday = lastActive === todayKey;

  return (
    <View style={styles.container}>
      <Hud />

      <ScrollView contentContainerStyle={{ paddingBottom: 28 }}>
        {/* Mascot greeting */}
        <View style={styles.greet}>
          <Mascot size={68} />
          <View style={styles.speech}>
            <Text style={styles.speechText}>
              {doneToday
                ? 'Nice work today — your streak is safe! 🔥'
                : 'Spot the red flags today to keep your streak alive!'}
            </Text>
          </View>
        </View>

        {/* Domain header */}
        <View style={[styles.domainHeader, { backgroundColor: domain.color }]}>
          <Text style={styles.domainIcon}>{domain.icon}</Text>
          <View style={{ flex: 1 }}>
            <Text style={styles.domainKicker}>THREAT DOMAIN</Text>
            <Text style={styles.domainTitle}>{domain.name}</Text>
          </View>
          <Text style={styles.domainProgress}>1 / 4</Text>
        </View>

        {/* The winding path of lesson nodes */}
        <View style={styles.path}>
          {PHISHING_PATH.map((node, i) => {
            const offset = (i % 2 === 0 ? -1 : 1) * 46;
            const isCurrent = node.state === 'current';
            const isLocked = node.state === 'locked';
            return (
              <View key={node.id} style={[styles.nodeRow, { transform: [{ translateX: offset }] }]}>
                <Pressable
                  disabled={isLocked}
                  onPress={() => node.lessonId && onStartLesson(node.lessonId)}
                  style={[
                    styles.node,
                    isCurrent && styles.nodeCurrent,
                    isLocked && styles.nodeLocked,
                  ]}
                >
                  <Text style={[styles.nodeIcon, isLocked && { opacity: 0.5 }]}>{node.icon}</Text>
                  {isCurrent && !doneToday && (
                    <View style={styles.startPill}>
                      <Text style={styles.startPillText}>START</Text>
                    </View>
                  )}
                  {isCurrent && doneToday && (
                    <View style={[styles.startPill, { backgroundColor: colors.primary }]}>
                      <Text style={styles.startPillText}>✓ DONE</Text>
                    </View>
                  )}
                </Pressable>
                <Text style={[styles.nodeLabel, isLocked && { color: colors.locked }]}>{node.title}</Text>
              </View>
            );
          })}
        </View>
      </ScrollView>

      {/* Primary CTA */}
      <View style={styles.cta}>
        <Button
          label={doneToday ? 'Practice again' : "Start today's challenge"}
          onPress={() => onStartLesson(PHISHING_LESSON.id)}
        />
        <Text style={styles.ctaHint}>
          ~2 min · keeps your streak alive 🔥
        </Text>
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
  domainHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    margin: 16,
    padding: 16,
    borderRadius: radius.lg,
  },
  domainIcon: { fontSize: 34 },
  domainKicker: { color: 'rgba(255,255,255,0.85)', fontSize: font.tiny, fontWeight: '800', letterSpacing: 1 },
  domainTitle: { color: '#fff', fontSize: font.h2, fontWeight: '800' },
  domainProgress: { color: '#fff', fontSize: font.h3, fontWeight: '800' },
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
  nodeLocked: { backgroundColor: colors.surfaceAlt, borderStyle: 'dashed' },
  nodeIcon: { fontSize: 32 },
  nodeLabel: { marginTop: 6, fontSize: font.small, fontWeight: '700', color: colors.text },
  startPill: {
    position: 'absolute',
    top: -14,
    backgroundColor: colors.streak,
    borderRadius: radius.pill,
    paddingHorizontal: 10,
    paddingVertical: 3,
  },
  startPillText: { color: '#fff', fontSize: font.tiny, fontWeight: '900', letterSpacing: 0.5 },
  cta: {
    padding: 16,
    borderTopWidth: 1,
    borderTopColor: colors.border,
    backgroundColor: colors.surface,
  },
  ctaHint: { textAlign: 'center', marginTop: 8, color: colors.textMuted, fontSize: font.small, fontWeight: '600' },
});
