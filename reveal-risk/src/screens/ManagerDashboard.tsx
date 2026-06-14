import React from 'react';
import { View, Text, StyleSheet, ScrollView, Pressable } from 'react-native';
import { colors, radius, font } from '../theme/tokens';
import { THREAT_DOMAINS } from '../data/domains';

/**
 * B2B manager dashboard (web-first). In production this is a role-gated route
 * fed by server-computed aggregates (BUILD_PLAN.md §3). Here it uses mock org
 * data to show the shape of the buyer-facing value.
 */

const ORG = {
  name: 'Acme Corp',
  riskScore: 78,
  riskTrend: [61, 64, 63, 69, 72, 75, 78], // 7-week trend
  activePct: 84,
  reportRate: 47, // % of phishing sims reported
  clickRate: 6, // % who clicked a sim (down is good)
};

const TEAMS = [
  { name: 'Finance', risk: 88, active: 96, xp: 2310 },
  { name: 'Engineering', risk: 81, active: 90, xp: 1980 },
  { name: 'Sales', risk: 64, active: 72, xp: 1750 },
  { name: 'Operations', risk: 59, active: 68, xp: 1240 },
];

const ROSTER = [
  { name: 'Priya N.', team: 'Finance', streak: 23, xp: 540, risk: 91, weak: 'Passwords', atRisk: false },
  { name: 'Marcus T.', team: 'Sales', streak: 9, xp: 410, risk: 74, weak: 'Phishing', atRisk: false },
  { name: 'Dana K.', team: 'Operations', streak: 2, xp: 120, risk: 48, weak: 'Social Eng.', atRisk: true },
  { name: 'Sam R.', team: 'Engineering', streak: 0, xp: 80, risk: 41, weak: 'Phishing', atRisk: true },
];

// Org-wide per-domain mastery (lower = weaker = more org risk).
const DOMAIN_MASTERY: Record<string, number> = {
  phishing: 82,
  passwords: 71,
  social_eng: 54,
  data_handling: 66,
  physical: 78,
  ai_deepfakes: 38,
};

export function ManagerDashboard() {
  return (
    <ScrollView style={styles.container} contentContainerStyle={{ padding: 16, gap: 16 }}>
      <View>
        <Text style={styles.kicker}>MANAGER DASHBOARD · {ORG.name}</Text>
        <Text style={styles.title}>Human Risk Overview</Text>
      </View>

      {/* Top KPI row */}
      <View style={styles.kpiRow}>
        <RiskGauge score={ORG.riskScore} trend={ORG.riskTrend} />
        <View style={{ flex: 1, gap: 10 }}>
          <Kpi label="Active this week" value={`${ORG.activePct}%`} tint={colors.primary} sub="streak health" />
          <Kpi label="Phish report rate" value={`${ORG.reportRate}%`} tint={colors.xp} sub="▲ up 12pts" />
          <Kpi label="Phish click rate" value={`${ORG.clickRate}%`} tint={colors.heart} sub="▼ down 9pts" />
        </View>
      </View>

      {/* Team leaderboard */}
      <Section title="Teams">
        {TEAMS.map((t, i) => (
          <View key={t.name} style={styles.teamRow}>
            <Text style={styles.teamRank}>{i + 1}</Text>
            <Text style={styles.teamName}>{t.name}</Text>
            <View style={styles.teamBarTrack}>
              <View style={[styles.teamBarFill, { width: `${t.risk}%`, backgroundColor: riskColor(t.risk) }]} />
            </View>
            <Text style={[styles.teamRisk, { color: riskColor(t.risk) }]}>{t.risk}</Text>
          </View>
        ))}
      </Section>

      {/* Domain heatmap */}
      <Section title="Where the org is weak (domain mastery)">
        <View style={styles.heatGrid}>
          {THREAT_DOMAINS.map((d) => {
            const v = DOMAIN_MASTERY[d.key] ?? 0;
            return (
              <View key={d.key} style={[styles.heatCell, { backgroundColor: heatBg(v) }]}>
                <Text style={styles.heatIcon}>{d.icon}</Text>
                <Text style={styles.heatName}>{d.name}</Text>
                <Text style={[styles.heatVal, { color: riskColor(v) }]}>{v}</Text>
              </View>
            );
          })}
        </View>
        <Text style={styles.hint}>AI &amp; Deepfakes (38) and Social Engineering (54) are the biggest gaps — assign a campaign.</Text>
      </Section>

      {/* Roster with at-risk flags */}
      <Section title="People">
        <View style={styles.tHead}>
          <Text style={[styles.th, { flex: 2 }]}>Employee</Text>
          <Text style={[styles.th, { flex: 1 }]}>Streak</Text>
          <Text style={[styles.th, { flex: 1 }]}>Risk</Text>
          <Text style={[styles.th, { flex: 1.4 }]}>Weakest</Text>
        </View>
        {ROSTER.map((p) => (
          <View key={p.name} style={[styles.tRow, p.atRisk && styles.tRowRisk]}>
            <View style={{ flex: 2 }}>
              <Text style={styles.pName}>{p.name}</Text>
              <Text style={styles.pTeam}>{p.team}</Text>
            </View>
            <Text style={[styles.td, { flex: 1 }]}>{p.streak > 0 ? `${p.streak} 🔥` : '—'}</Text>
            <Text style={[styles.td, { flex: 1, color: riskColor(p.risk), fontWeight: '800' }]}>{p.risk}</Text>
            <View style={{ flex: 1.4, flexDirection: 'row', alignItems: 'center', gap: 4 }}>
              <Text style={styles.td}>{p.weak}</Text>
              {p.atRisk && <Text style={styles.flag}>⚠️</Text>}
            </View>
          </View>
        ))}
      </Section>

      {/* Campaign controls */}
      <Section title="Campaigns">
        <View style={{ flexDirection: 'row', gap: 10, flexWrap: 'wrap' }}>
          <Pressable style={styles.cta}><Text style={styles.ctaText}>＋ Assign “Deepfakes 101”</Text></Pressable>
          <Pressable style={styles.ctaAlt}><Text style={styles.ctaAltText}>Launch phishing sim</Text></Pressable>
          <Pressable style={styles.ctaAlt}><Text style={styles.ctaAltText}>Export compliance report</Text></Pressable>
        </View>
      </Section>

      <Text style={styles.footer}>Mock data — wired to server-computed aggregates in Phase 3.</Text>
    </ScrollView>
  );
}

function RiskGauge({ score, trend }: { score: number; trend: number[] }) {
  const max = Math.max(...trend);
  const min = Math.min(...trend);
  return (
    <View style={styles.gauge}>
      <Text style={styles.gaugeLabel}>ORG HUMAN-RISK SCORE</Text>
      <Text style={styles.gaugeScore}>{score}<Text style={styles.gaugeMax}>/100</Text></Text>
      {/* simple sparkline */}
      <View style={styles.spark}>
        {trend.map((v, i) => {
          const h = 8 + ((v - min) / Math.max(1, max - min)) * 28;
          return <View key={i} style={[styles.sparkBar, { height: h }]} />;
        })}
      </View>
      <Text style={styles.gaugeTrend}>▲ +17 over 7 weeks</Text>
    </View>
  );
}

function Kpi({ label, value, tint, sub }: { label: string; value: string; tint: string; sub: string }) {
  return (
    <View style={styles.kpi}>
      <Text style={styles.kpiLabel}>{label}</Text>
      <View style={{ flexDirection: 'row', alignItems: 'baseline', gap: 8 }}>
        <Text style={[styles.kpiValue, { color: tint }]}>{value}</Text>
        <Text style={styles.kpiSub}>{sub}</Text>
      </View>
    </View>
  );
}

function Section({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <View style={styles.section}>
      <Text style={styles.sectionTitle}>{title}</Text>
      <View style={{ gap: 8 }}>{children}</View>
    </View>
  );
}

const riskColor = (v: number) => (v >= 75 ? colors.primary : v >= 55 ? colors.warn : colors.danger);
const heatBg = (v: number) => (v >= 75 ? '#E6F7F0' : v >= 55 ? '#FFF6E6' : '#FDECEE');

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: colors.bg },
  kicker: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 1 },
  title: { fontSize: font.h1, fontWeight: '900', color: colors.text },
  kpiRow: { flexDirection: 'row', gap: 12 },
  gauge: { width: 168, backgroundColor: colors.navy, borderRadius: radius.lg, padding: 16 },
  gaugeLabel: { color: 'rgba(255,255,255,0.7)', fontSize: 9, fontWeight: '800', letterSpacing: 0.8 },
  gaugeScore: { color: '#fff', fontSize: 44, fontWeight: '900', marginTop: 2 },
  gaugeMax: { fontSize: font.body, color: 'rgba(255,255,255,0.6)' },
  spark: { flexDirection: 'row', alignItems: 'flex-end', gap: 4, height: 40, marginTop: 8 },
  sparkBar: { flex: 1, backgroundColor: colors.primary, borderRadius: 2 },
  gaugeTrend: { color: colors.primary, fontSize: font.tiny, fontWeight: '800', marginTop: 6 },
  kpi: { backgroundColor: colors.surface, borderRadius: radius.md, borderWidth: 1, borderColor: colors.border, padding: 12 },
  kpiLabel: { fontSize: font.tiny, color: colors.textMuted, fontWeight: '700' },
  kpiValue: { fontSize: font.h2, fontWeight: '900' },
  kpiSub: { fontSize: font.tiny, color: colors.textMuted, fontWeight: '600' },
  section: { backgroundColor: colors.surface, borderRadius: radius.lg, borderWidth: 1, borderColor: colors.border, padding: 14, gap: 10 },
  sectionTitle: { fontSize: font.h3, fontWeight: '800', color: colors.text },
  teamRow: { flexDirection: 'row', alignItems: 'center', gap: 10 },
  teamRank: { width: 16, fontSize: font.small, fontWeight: '800', color: colors.textMuted },
  teamName: { width: 88, fontSize: font.small, fontWeight: '700', color: colors.text },
  teamBarTrack: { flex: 1, height: 10, backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, overflow: 'hidden' },
  teamBarFill: { height: '100%', borderRadius: radius.pill },
  teamRisk: { width: 26, textAlign: 'right', fontSize: font.small, fontWeight: '800' },
  heatGrid: { flexDirection: 'row', flexWrap: 'wrap', gap: 8 },
  heatCell: { width: '31%', flexGrow: 1, borderRadius: radius.md, padding: 10, alignItems: 'center', gap: 2 },
  heatIcon: { fontSize: 20 },
  heatName: { fontSize: font.tiny, fontWeight: '700', color: colors.text, textAlign: 'center' },
  heatVal: { fontSize: font.h3, fontWeight: '900' },
  hint: { fontSize: font.small, color: colors.textMuted, fontStyle: 'italic', lineHeight: 18 },
  tHead: { flexDirection: 'row', paddingBottom: 6, borderBottomWidth: 1, borderBottomColor: colors.border },
  th: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 0.5 },
  tRow: { flexDirection: 'row', alignItems: 'center', paddingVertical: 8, borderRadius: radius.sm },
  tRowRisk: { backgroundColor: '#FDECEE' },
  pName: { fontSize: font.small, fontWeight: '800', color: colors.text },
  pTeam: { fontSize: font.tiny, color: colors.textMuted },
  td: { fontSize: font.small, color: colors.text, fontWeight: '600' },
  flag: { fontSize: 13 },
  cta: { backgroundColor: colors.primary, borderRadius: radius.md, paddingVertical: 10, paddingHorizontal: 14 },
  ctaText: { color: '#fff', fontWeight: '800', fontSize: font.small },
  ctaAlt: { backgroundColor: colors.surfaceAlt, borderRadius: radius.md, paddingVertical: 10, paddingHorizontal: 14 },
  ctaAltText: { color: colors.text, fontWeight: '700', fontSize: font.small },
  footer: { textAlign: 'center', fontSize: font.tiny, color: colors.textMuted, fontStyle: 'italic', marginBottom: 8 },
});
