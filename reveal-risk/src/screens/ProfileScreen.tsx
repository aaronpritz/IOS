import React, { useState } from 'react';
import { View, Text, StyleSheet, ScrollView, Pressable } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { useGameStore, badgeMeta } from '../store/useGameStore';
import { THREAT_DOMAINS } from '../data/domains';
import { lessonsInDomain } from '../data/lessons';
import { enableDailyReminder, ReminderResult } from '../lib/notifications';
import { Squad } from '../components/social/Squad';

/** Stats, badges, and per-domain mastery — plus the per-user Human-Risk Score (B2B). */
export function ProfileScreen() {
  const streak = useGameStore((s) => s.streak);
  const longestStreak = useGameStore((s) => s.longestStreak);
  const xp = useGameStore((s) => s.xp);
  const badges = useGameStore((s) => s.badges);
  const level = useGameStore((s) => s.level());
  const completedLessons = useGameStore((s) => s.completedLessons);
  const focusDomain = useGameStore((s) => s.focusDomain);
  const dailyGoal = useGameStore((s) => s.dailyGoal);
  const reminderTime = useGameStore((s) => s.reminderTime);

  const focusName = THREAT_DOMAINS.find((d) => d.key === focusDomain)?.name ?? '—';
  const reminderLabel = reminderTime ? reminderTime.charAt(0).toUpperCase() + reminderTime.slice(1) : '—';

  // Illustrative human-risk score: rises with engagement (lower = riskier).
  const riskScore = Math.min(95, 40 + Math.floor(xp / 10) + streak * 2 + completedLessons.length * 3);

  return (
    <ScrollView style={styles.container} contentContainerStyle={{ padding: 16, gap: 16 }}>
      <View style={styles.profileHead}>
        <View style={styles.avatar}><Text style={{ fontSize: 30 }}>🧑‍💻</Text></View>
        <View>
          <Text style={styles.name}>You</Text>
          <Text style={styles.org}>Acme Corp · Engineering</Text>
        </View>
      </View>

      <View style={styles.grid}>
        <Card label="Level" value={String(level)} icon="⭐" />
        <Card label="Total XP" value={String(xp)} icon="⚡" />
        <Card label="Current streak" value={`${streak} 🔥`} icon="" />
        <Card label="Longest streak" value={String(longestStreak)} icon="🏅" />
      </View>

      {/* Your plan — from onboarding */}
      <View style={styles.planCard}>
        <Text style={styles.planTitle}>YOUR PLAN</Text>
        <View style={styles.planRow}>
          <PlanItem icon="🎯" label="Focus" value={focusName} />
          <PlanItem icon="📅" label="Daily goal" value={`${dailyGoal}/day`} />
          <PlanItem icon="⏰" label="Reminder" value={reminderLabel} />
        </View>
        <ReminderButton reminderTime={reminderTime} />
      </View>

      {/* Social — teammate streaks */}
      <Squad />

      {/* Human-Risk Score — the B2B outcome metric */}
      <View style={styles.riskCard}>
        <Text style={styles.riskLabel}>HUMAN-RISK SCORE</Text>
        <Text style={styles.riskValue}>{riskScore}<Text style={styles.riskMax}>/100</Text></Text>
        <View style={styles.riskTrack}>
          <View style={[styles.riskFill, { width: `${riskScore}%` }]} />
        </View>
        <Text style={styles.riskNote}>Higher = more resilient. Server-computed from behavior in production.</Text>
      </View>

      {/* Badges */}
      <Text style={styles.sectionTitle}>Badges</Text>
      {badges.length === 0 ? (
        <Text style={styles.empty}>Complete a lesson to earn your first badge 🛡️</Text>
      ) : (
        <View style={styles.badgeRow}>
          {badges.map((b) => {
            const m = badgeMeta(b);
            return (
              <View key={b} style={styles.badge}>
                <Text style={{ fontSize: 26 }}>{m.icon}</Text>
                <Text style={styles.badgeName}>{m.name}</Text>
              </View>
            );
          })}
        </View>
      )}

      {/* Domain mastery */}
      <Text style={styles.sectionTitle}>Threat domains</Text>
      <View style={{ gap: 8 }}>
        {THREAT_DOMAINS.map((d) => {
          const ids = lessonsInDomain(d.key);
          const doneInDomain = ids.filter((id) => completedLessons.includes(id)).length;
          const pct = ids.length ? Math.round((doneInDomain / ids.length) * 100) : 0;
          return (
            <View key={d.key} style={styles.domainRow}>
              <Text style={{ fontSize: 20 }}>{d.icon}</Text>
              <Text style={styles.domainName}>{d.name}</Text>
              <View style={styles.domainTrack}>
                <View style={[styles.domainFill, { width: `${pct}%`, backgroundColor: d.color }]} />
              </View>
            </View>
          );
        })}
      </View>
    </ScrollView>
  );
}

function Card({ label, value, icon }: { label: string; value: string; icon: string }) {
  return (
    <View style={styles.card}>
      <Text style={styles.cardValue}>{icon ? `${icon} ` : ''}{value}</Text>
      <Text style={styles.cardLabel}>{label}</Text>
    </View>
  );
}

function ReminderButton({ reminderTime }: { reminderTime: string | null }) {
  const [status, setStatus] = useState<ReminderResult | 'loading' | null>(null);

  const messages: Record<ReminderResult, string> = {
    scheduled: '✅ Daily reminder scheduled',
    web: '✅ Browser notifications on (native build adds daily scheduling)',
    denied: '🔕 Permission denied — enable notifications in settings',
    unsupported: 'ℹ️ Not supported in this browser — works in the mobile app',
  };

  async function onPress() {
    setStatus('loading');
    const r = await enableDailyReminder(reminderTime);
    setStatus(r);
  }

  return (
    <View style={{ marginTop: 14 }}>
      <Pressable onPress={onPress} style={styles.reminderBtn}>
        <Text style={styles.reminderBtnText}>🔔 Turn on daily reminder</Text>
      </Pressable>
      {status && status !== 'loading' && <Text style={styles.reminderStatus}>{messages[status]}</Text>}
      {status === 'loading' && <Text style={styles.reminderStatus}>Requesting…</Text>}
    </View>
  );
}

function PlanItem({ icon, label, value }: { icon: string; label: string; value: string }) {
  return (
    <View style={styles.planItem}>
      <Text style={styles.planIcon}>{icon}</Text>
      <Text style={styles.planValue}>{value}</Text>
      <Text style={styles.planItemLabel}>{label}</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg },
  profileHead: { flexDirection: 'row', alignItems: 'center', gap: 12 },
  avatar: { width: 60, height: 60, borderRadius: 30, backgroundColor: colors.surfaceAlt, alignItems: 'center', justifyContent: 'center' },
  name: { fontSize: font.h2, fontWeight: '900', color: colors.text },
  org: { fontSize: font.small, color: colors.textMuted, fontWeight: '600' },
  grid: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  card: {
    width: '47%', flexGrow: 1, backgroundColor: colors.surface, borderRadius: radius.lg,
    borderWidth: 1, borderColor: colors.border, padding: 16,
  },
  cardValue: { fontSize: font.h2, fontWeight: '900', color: colors.text },
  cardLabel: { fontSize: font.small, color: colors.textMuted, marginTop: 2, fontWeight: '600' },
  planCard: { backgroundColor: colors.surface, borderRadius: radius.lg, borderWidth: 1, borderColor: colors.border, padding: 16 },
  planTitle: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 1, marginBottom: 12 },
  planRow: { flexDirection: 'row', justifyContent: 'space-between' },
  planItem: { flex: 1, alignItems: 'center', gap: 2 },
  planIcon: { fontSize: 20 },
  planValue: { fontSize: font.body, fontWeight: '800', color: colors.text },
  planItemLabel: { fontSize: font.tiny, color: colors.textMuted, fontWeight: '600' },
  reminderBtn: { backgroundColor: colors.surfaceAlt, borderRadius: radius.md, paddingVertical: 11, alignItems: 'center' },
  reminderBtnText: { fontSize: font.small, fontWeight: '800', color: colors.navy },
  reminderStatus: { fontSize: font.tiny, color: colors.textMuted, textAlign: 'center', marginTop: 8, fontWeight: '600' },
  riskCard: { backgroundColor: colors.navy, borderRadius: radius.lg, padding: 18 },
  riskLabel: { color: 'rgba(255,255,255,0.7)', fontSize: font.tiny, fontWeight: '800', letterSpacing: 1 },
  riskValue: { color: '#fff', fontSize: 40, fontWeight: '900', marginTop: 2 },
  riskMax: { fontSize: font.h3, color: 'rgba(255,255,255,0.6)', fontWeight: '700' },
  riskTrack: { height: 10, backgroundColor: 'rgba(255,255,255,0.2)', borderRadius: radius.pill, overflow: 'hidden', marginTop: 8 },
  riskFill: { height: '100%', backgroundColor: colors.primary, borderRadius: radius.pill },
  riskNote: { color: 'rgba(255,255,255,0.7)', fontSize: font.tiny, marginTop: 8 },
  sectionTitle: { fontSize: font.h3, fontWeight: '800', color: colors.text },
  empty: { fontSize: font.small, color: colors.textMuted },
  badgeRow: { flexDirection: 'row', flexWrap: 'wrap', gap: 10 },
  badge: {
    backgroundColor: colors.surface, borderRadius: radius.md, borderWidth: 1, borderColor: colors.border,
    paddingVertical: 12, paddingHorizontal: 14, alignItems: 'center', gap: 4, minWidth: 92,
  },
  badgeName: { fontSize: font.tiny, fontWeight: '700', color: colors.text, textAlign: 'center' },
  domainRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  domainName: { width: 130, fontSize: font.small, fontWeight: '700', color: colors.text },
  domainTrack: { flex: 1, height: 8, backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, overflow: 'hidden' },
  domainFill: { height: '100%', borderRadius: radius.pill },
});
