import React, { useMemo, useState } from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { PasswordStrengthPayload } from '../../data/types';

interface Props {
  payload: PasswordStrengthPayload;
  onResult: (result: { isCorrect: boolean; mistakes: number }) => void;
}

/**
 * Interactive password-hygiene challenge: the user applies fixes to a weak
 * password and watches a live strength meter respond. Passes when the meter
 * reaches the threshold.
 */
export function PasswordStrength({ payload, onResult }: Props) {
  const [applied, setApplied] = useState<Set<string>>(new Set());
  const [checked, setChecked] = useState(false);

  const strength = useMemo(() => {
    let s = 0;
    payload.fixes.forEach((f) => applied.has(f.id) && (s += f.points));
    return Math.min(100, s);
  }, [applied, payload.fixes]);

  const passed = strength >= payload.threshold;
  const meterColor = strength >= payload.threshold ? colors.primary : strength >= 50 ? colors.warn : colors.danger;
  const label = strength >= 90 ? 'Very strong' : strength >= payload.threshold ? 'Strong' : strength >= 50 ? 'Fair' : 'Weak';

  function toggle(id: string) {
    if (checked) return;
    setApplied((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  }

  function check() {
    setChecked(true);
    onResult({ isCorrect: passed, mistakes: passed ? 0 : 1 });
  }

  return (
    <View style={{ flex: 1 }}>
      <Text style={styles.prompt}>{payload.prompt}</Text>

      {/* Password + live meter */}
      <View style={styles.pwCard}>
        <Text style={styles.pwLabel}>STARTING PASSWORD</Text>
        <Text style={styles.pw}>{payload.base}</Text>
        <View style={styles.meterTrack}>
          <View style={[styles.meterFill, { width: `${strength}%`, backgroundColor: meterColor }]} />
        </View>
        <View style={styles.meterRow}>
          <Text style={[styles.meterLabel, { color: meterColor }]}>{label}</Text>
          <Text style={styles.meterPct}>{strength}/100</Text>
        </View>
      </View>

      {/* Fix toggles */}
      <Text style={styles.sectionLabel}>Apply fixes to strengthen it:</Text>
      <View style={{ gap: 8 }}>
        {payload.fixes.map((f) => {
          const on = applied.has(f.id);
          return (
            <Pressable key={f.id} onPress={() => toggle(f.id)} style={[styles.fix, on && styles.fixOn]}>
              <View style={[styles.check, on && styles.checkOn]}>
                {on && <Text style={styles.checkMark}>✓</Text>}
              </View>
              <Text style={[styles.fixText, on && { color: colors.text, fontWeight: '700' }]}>{f.label}</Text>
              <Text style={styles.fixPts}>+{f.points}</Text>
            </Pressable>
          );
        })}
      </View>

      {checked && (
        <View style={styles.rationale}>
          {payload.fixes
            .filter((f) => applied.has(f.id))
            .map((f) => (
              <Text key={f.id} style={styles.rationaleText}>
                <Text style={{ fontWeight: '800' }}>✓ {f.label}: </Text>
                {f.rationale}
              </Text>
            ))}
          {!passed && <Text style={styles.miss}>Not quite — apply more fixes to reach {payload.threshold}+.</Text>}
        </View>
      )}

      {!checked && (
        <Pressable onPress={check} style={styles.checkBtn}>
          <Text style={styles.checkBtnText}>Check</Text>
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  prompt: { fontSize: font.body, color: colors.textMuted, marginBottom: 12, fontWeight: '600' },
  pwCard: {
    backgroundColor: colors.surface,
    borderRadius: radius.lg,
    borderWidth: 1,
    borderColor: colors.border,
    padding: 14,
    marginBottom: 16,
  },
  pwLabel: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 0.8 },
  pw: { fontSize: font.h3, fontWeight: '800', color: colors.text, fontFamily: 'monospace', marginTop: 4, marginBottom: 12 },
  meterTrack: { height: 12, backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, overflow: 'hidden' },
  meterFill: { height: '100%', borderRadius: radius.pill },
  meterRow: { flexDirection: 'row', justifyContent: 'space-between', marginTop: 6 },
  meterLabel: { fontSize: font.small, fontWeight: '800' },
  meterPct: { fontSize: font.small, color: colors.textMuted, fontWeight: '600' },
  sectionLabel: { fontSize: font.small, fontWeight: '700', color: colors.text, marginBottom: 8 },
  fix: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
    borderWidth: 2,
    borderColor: colors.border,
    borderRadius: radius.md,
    paddingVertical: 13,
    paddingHorizontal: 14,
    backgroundColor: colors.surface,
  },
  fixOn: { borderColor: colors.primary, backgroundColor: '#E6F7F0' },
  check: { width: 22, height: 22, borderRadius: 6, borderWidth: 2, borderColor: colors.borderStrong, alignItems: 'center', justifyContent: 'center' },
  checkOn: { backgroundColor: colors.primary, borderColor: colors.primary },
  checkMark: { color: '#fff', fontWeight: '900', fontSize: 13 },
  fixText: { flex: 1, fontSize: font.body, color: colors.textMuted, fontWeight: '600' },
  fixPts: { fontSize: font.small, fontWeight: '800', color: colors.xp },
  rationale: { marginTop: 14, backgroundColor: colors.surfaceAlt, borderRadius: radius.lg, padding: 12, gap: 8 },
  rationaleText: { fontSize: font.small, color: colors.text, lineHeight: 19 },
  miss: { fontSize: font.small, color: colors.danger, fontWeight: '700' },
  checkBtn: { marginTop: 16, backgroundColor: colors.navy, borderRadius: radius.lg, paddingVertical: 14, alignItems: 'center' },
  checkBtnText: { color: '#fff', fontWeight: '800', fontSize: font.body },
});
