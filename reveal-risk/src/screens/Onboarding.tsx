import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { Button } from '../components/ui/Button';
import { SparkAvatar } from '../components/brand/SparkAvatar';
import { THREAT_DOMAINS } from '../data/domains';
import { useGameStore } from '../store/useGameStore';

interface Props {
  onDone: () => void;
}

const GOALS = [
  { n: 1, label: 'Casual', sub: '1 lesson / day' },
  { n: 2, label: 'Regular', sub: '2 lessons / day' },
  { n: 3, label: 'Serious', sub: '3 lessons / day' },
];
const REMINDERS = [
  { id: 'morning', icon: '☀️', label: 'Morning' },
  { id: 'midday', icon: '🌤️', label: 'Midday' },
  { id: 'evening', icon: '🌙', label: 'Evening' },
];
const STEPS = ['welcome', 'focus', 'goal', 'done'] as const;

/** First-run onboarding: welcome → pick focus → set goal/reminder → start. */
export function Onboarding({ onDone }: Props) {
  const [step, setStep] = useState(0);
  const [focus, setFocus] = useState('phishing');
  const [goal, setGoal] = useState(2);
  const [reminder, setReminder] = useState('evening');

  const focusName = THREAT_DOMAINS.find((d) => d.key === focus)?.name ?? 'Phishing';
  const reminderName = REMINDERS.find((r) => r.id === reminder)?.label ?? 'Evening';

  function next() {
    if (step < STEPS.length - 1) {
      setStep(step + 1);
    } else {
      useGameStore.getState().completeOnboarding({ focusDomain: focus, dailyGoal: goal, reminderTime: reminder });
      onDone();
    }
  }

  const ctaLabel = step === 0 ? 'Get started' : step === STEPS.length - 1 ? 'Start learning' : 'Continue';

  return (
    <View style={styles.root}>
      {/* Progress dots */}
      <View style={styles.dots}>
        {STEPS.map((_, i) => (
          <View key={i} style={[styles.dot, i <= step && styles.dotOn]} />
        ))}
      </View>

      <ScrollView contentContainerStyle={styles.content} showsVerticalScrollIndicator={false}>
        {step === 0 && (
          <View style={styles.centerStep}>
            <SparkAvatar size={150} mood="cheer" />
            <Text style={styles.title}>
              Welcome to Cyber<Text style={{ color: colors.primary }}>Spark</Text>
            </Text>
            <Text style={styles.body}>
              Build a daily habit that makes you hard to hack — just ~2 minutes a day. I’m Spark,
              and I’ll be your guide. 🛡️
            </Text>
          </View>
        )}

        {step === 1 && (
          <View>
            <Text style={styles.title}>What do you want to master first?</Text>
            <Text style={styles.body}>We’ll prioritize this threat domain in your path.</Text>
            <View style={styles.grid}>
              {THREAT_DOMAINS.map((d) => {
                const on = focus === d.key;
                return (
                  <Pressable key={d.key} onPress={() => setFocus(d.key)} style={[styles.domainCard, on && styles.cardOn]}>
                    <Text style={styles.domainIcon}>{d.icon}</Text>
                    <Text style={[styles.domainName, on && { color: colors.text }]}>{d.name}</Text>
                  </Pressable>
                );
              })}
            </View>
          </View>
        )}

        {step === 2 && (
          <View>
            <Text style={styles.title}>Set your daily goal</Text>
            <View style={{ gap: 10, marginTop: 8 }}>
              {GOALS.map((g) => {
                const on = goal === g.n;
                return (
                  <Pressable key={g.n} onPress={() => setGoal(g.n)} style={[styles.goal, on && styles.cardOn]}>
                    <View style={{ flex: 1 }}>
                      <Text style={[styles.goalLabel, on && { color: colors.text }]}>{g.label}</Text>
                      <Text style={styles.goalSub}>{g.sub}</Text>
                    </View>
                    <View style={[styles.radio, on && styles.radioOn]}>{on && <Text style={styles.radioDot}>●</Text>}</View>
                  </Pressable>
                );
              })}
            </View>

            <Text style={[styles.title, { fontSize: font.h3, marginTop: 24 }]}>When should Spark remind you?</Text>
            <View style={styles.reminderRow}>
              {REMINDERS.map((r) => {
                const on = reminder === r.id;
                return (
                  <Pressable key={r.id} onPress={() => setReminder(r.id)} style={[styles.reminder, on && styles.cardOn]}>
                    <Text style={{ fontSize: 24 }}>{r.icon}</Text>
                    <Text style={[styles.reminderLabel, on && { color: colors.text }]}>{r.label}</Text>
                  </Pressable>
                );
              })}
            </View>
          </View>
        )}

        {step === 3 && (
          <View style={styles.centerStep}>
            <SparkAvatar size={150} mood="cheer" />
            <Text style={styles.title}>You’re all set! 🎉</Text>
            <View style={styles.summary}>
              <SummaryRow label="Focus" value={focusName} />
              <SummaryRow label="Daily goal" value={`${goal} lesson${goal > 1 ? 's' : ''} / day`} />
              <SummaryRow label="Reminder" value={reminderName} />
            </View>
          </View>
        )}
      </ScrollView>

      <View style={styles.cta}>
        <Button label={ctaLabel} onPress={next} />
      </View>
    </View>
  );
}

function SummaryRow({ label, value }: { label: string; value: string }) {
  return (
    <View style={styles.summaryRow}>
      <Text style={styles.summaryLabel}>{label}</Text>
      <Text style={styles.summaryValue}>{value}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  root: { flex: 1, backgroundColor: colors.bg },
  dots: { flexDirection: 'row', gap: 8, justifyContent: 'center', paddingTop: 18, paddingBottom: 8 },
  dot: { width: 8, height: 8, borderRadius: 4, backgroundColor: colors.border },
  dotOn: { backgroundColor: colors.primary, width: 22 },
  content: { paddingHorizontal: 24, paddingTop: 10, paddingBottom: 20, flexGrow: 1 },
  centerStep: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 14 },
  title: { fontSize: font.h1, fontWeight: '900', color: colors.text, textAlign: 'center', marginTop: 8 },
  body: { fontSize: font.body, color: colors.textMuted, textAlign: 'center', lineHeight: 22, fontWeight: '600' },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10, marginTop: 16 },
  domainCard: {
    width: '47%',
    flexGrow: 1,
    alignItems: 'center',
    gap: 6,
    paddingVertical: 18,
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
    borderRadius: radius.lg,
  },
  cardOn: { borderColor: colors.primary, backgroundColor: '#E6F7F0' },
  domainIcon: { fontSize: 30 },
  domainName: { fontSize: font.small, fontWeight: '700', color: colors.textMuted, textAlign: 'center' },
  goal: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
    borderRadius: radius.lg,
    paddingVertical: 14,
    paddingHorizontal: 16,
  },
  goalLabel: { fontSize: font.h3, fontWeight: '800', color: colors.textMuted },
  goalSub: { fontSize: font.small, color: colors.textMuted, marginTop: 1 },
  radio: { width: 24, height: 24, borderRadius: 12, borderWidth: 2, borderColor: colors.borderStrong, alignItems: 'center', justifyContent: 'center' },
  radioOn: { borderColor: colors.primary },
  radioDot: { color: colors.primary, fontSize: 12 },
  reminderRow: { flexDirection: 'row', gap: 10, marginTop: 10 },
  reminder: {
    flex: 1,
    alignItems: 'center',
    gap: 6,
    paddingVertical: 14,
    backgroundColor: colors.surface,
    borderWidth: 2,
    borderColor: colors.border,
    borderRadius: radius.lg,
  },
  reminderLabel: { fontSize: font.small, fontWeight: '700', color: colors.textMuted },
  summary: { alignSelf: 'stretch', backgroundColor: colors.surface, borderRadius: radius.lg, borderWidth: 1, borderColor: colors.border, padding: 16, gap: 12, marginTop: 8 },
  summaryRow: { flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center' },
  summaryLabel: { fontSize: font.body, color: colors.textMuted, fontWeight: '600' },
  summaryValue: { fontSize: font.body, color: colors.text, fontWeight: '800' },
  cta: { padding: 16, borderTopWidth: 1, borderTopColor: colors.border, backgroundColor: colors.surface },
});
