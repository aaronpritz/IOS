import React, { useMemo, useState } from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { SpotThePhishPayload, PhishHotspot } from '../../data/types';

interface Props {
  payload: SpotThePhishPayload;
  /** Called once the user checks: correct = all red flags found and no false taps. */
  onResult: (result: { isCorrect: boolean; mistakes: number }) => void;
}

/**
 * The flagship interactive challenge: a realistic fake email where the user taps
 * the red flags. Wrong taps and missed flags each count as a mistake (→ lose a shield).
 */
export function SpotThePhish({ payload, onResult }: Props) {
  const { email, prompt } = payload;
  const [selected, setSelected] = useState<Set<string>>(new Set());
  const [checked, setChecked] = useState(false);

  const redFlagIds = useMemo(
    () => new Set(email.hotspots.filter((h) => h.isRedFlag).map((h) => h.id)),
    [email.hotspots]
  );

  function toggle(id: string) {
    if (checked) return;
    setSelected((prev) => {
      const next = new Set(prev);
      next.has(id) ? next.delete(id) : next.add(id);
      return next;
    });
  }

  function check() {
    let mistakes = 0;
    email.hotspots.forEach((h) => {
      const picked = selected.has(h.id);
      if (h.isRedFlag && !picked) mistakes++; // missed a red flag
      if (!h.isRedFlag && picked) mistakes++; // false positive
    });
    setChecked(true);
    onResult({ isCorrect: mistakes === 0, mistakes });
  }

  const find = (zone: PhishHotspot['zone']) => email.hotspots.find((h) => h.zone === zone);
  const bodyHotspots = email.hotspots.filter((h) => h.zone === 'body');

  return (
    <View style={{ flex: 1 }}>
      <Text style={styles.prompt}>{prompt}</Text>

      <ScrollView style={styles.emailCard} contentContainerStyle={{ padding: 14 }}>
        {/* From */}
        <View style={styles.metaRow}>
          <Text style={styles.metaLabel}>From</Text>
          <View style={{ flex: 1 }}>
            <Text style={styles.senderName}>{email.senderName}</Text>
            <Hotspot h={find('sender')!} selected={selected} checked={checked} redFlagIds={redFlagIds} onToggle={toggle} small />
          </View>
        </View>
        <View style={styles.metaRow}>
          <Text style={styles.metaLabel}>Date</Text>
          <Text style={styles.metaValue}>{email.date}</Text>
        </View>

        {/* Subject */}
        <View style={styles.subjectWrap}>
          <Hotspot h={find('subject')!} selected={selected} checked={checked} redFlagIds={redFlagIds} onToggle={toggle} bold />
        </View>

        <View style={styles.divider} />

        {/* Greeting + body */}
        <View style={{ marginTop: 4 }}>
          <Hotspot h={find('greeting')!} selected={selected} checked={checked} redFlagIds={redFlagIds} onToggle={toggle} />
        </View>
        {bodyHotspots.map((h) => (
          <View key={h.id} style={{ marginTop: 10 }}>
            <Hotspot h={h} selected={selected} checked={checked} redFlagIds={redFlagIds} onToggle={toggle} />
          </View>
        ))}

        {/* Link button */}
        <View style={{ marginTop: 14, alignItems: 'flex-start' }}>
          <Hotspot h={find('link')!} selected={selected} checked={checked} redFlagIds={redFlagIds} onToggle={toggle} asLink />
        </View>
      </ScrollView>

      {checked && (
        <ScrollView style={styles.rationaleBox} contentContainerStyle={{ padding: 12 }}>
          {email.hotspots
            .filter((h) => h.isRedFlag || selected.has(h.id))
            .map((h) => {
              const correct = h.isRedFlag && selected.has(h.id);
              const missed = h.isRedFlag && !selected.has(h.id);
              return (
                <View key={h.id} style={styles.rationaleRow}>
                  <Text style={styles.rationaleIcon}>{correct ? '✅' : missed ? '⚠️' : '❌'}</Text>
                  <Text style={styles.rationaleText}>
                    <Text style={{ fontWeight: '800' }}>
                      {correct ? 'Caught it: ' : missed ? 'Missed: ' : 'Not a flag: '}
                    </Text>
                    {h.rationale}
                  </Text>
                </View>
              );
            })}
        </ScrollView>
      )}

      {!checked && (
        <Pressable
          onPress={check}
          style={({ pressed }) => [styles.checkBtn, { opacity: pressed ? 0.85 : 1 }]}
        >
          <Text style={styles.checkLabel}>Check ({selected.size} flagged)</Text>
        </Pressable>
      )}
    </View>
  );
}

function Hotspot({
  h,
  selected,
  checked,
  redFlagIds,
  onToggle,
  bold,
  small,
  asLink,
}: {
  h: PhishHotspot;
  selected: Set<string>;
  checked: boolean;
  redFlagIds: Set<string>;
  onToggle: (id: string) => void;
  bold?: boolean;
  small?: boolean;
  asLink?: boolean;
}) {
  const isSelected = selected.has(h.id);
  let border = 'transparent';
  let bg = 'transparent';

  if (checked) {
    if (redFlagIds.has(h.id) && isSelected) {
      border = colors.primary;
      bg = '#E6F7F0';
    } else if (redFlagIds.has(h.id) && !isSelected) {
      border = colors.warn;
      bg = '#FFF6E6';
    } else if (!redFlagIds.has(h.id) && isSelected) {
      border = colors.danger;
      bg = '#FDECEE';
    }
  } else if (isSelected) {
    border = colors.streak;
    bg = '#FFF1DD';
  }

  return (
    <Pressable
      onPress={() => onToggle(h.id)}
      style={[
        styles.hotspot,
        asLink && styles.linkHotspot,
        { borderColor: border, backgroundColor: bg },
      ]}
    >
      <Text
        style={[
          asLink ? styles.linkText : styles.bodyText,
          bold && { fontWeight: '800', fontSize: font.h3, color: colors.text },
          small && { fontSize: font.small, color: colors.textMuted },
        ]}
      >
        {h.text}
      </Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  prompt: { fontSize: font.body, color: colors.textMuted, marginBottom: 10, fontWeight: '600' },
  emailCard: {
    backgroundColor: colors.surface,
    borderRadius: radius.lg,
    borderWidth: 1,
    borderColor: colors.border,
    maxHeight: 340,
  },
  metaRow: { flexDirection: 'row', alignItems: 'flex-start', gap: 8, marginBottom: 6 },
  metaLabel: { width: 42, fontSize: font.tiny, color: colors.textMuted, fontWeight: '700', paddingTop: 3 },
  metaValue: { fontSize: font.small, color: colors.textMuted },
  senderName: { fontSize: font.body, fontWeight: '700', color: colors.text },
  subjectWrap: { marginTop: 6 },
  divider: { height: 1, backgroundColor: colors.border, marginVertical: 12 },
  hotspot: { borderWidth: 2, borderRadius: radius.sm, paddingHorizontal: 6, paddingVertical: 3, alignSelf: 'flex-start' },
  linkHotspot: { borderRadius: radius.md },
  bodyText: { fontSize: font.body, color: colors.text, lineHeight: 21 },
  linkText: { fontSize: font.small, color: colors.xp, fontWeight: '700', textDecorationLine: 'underline' },
  checkBtn: {
    marginTop: 12,
    backgroundColor: colors.navy,
    borderRadius: radius.lg,
    paddingVertical: 13,
    alignItems: 'center',
  },
  checkLabel: { color: '#fff', fontWeight: '800', fontSize: font.body },
  rationaleBox: {
    marginTop: 12,
    backgroundColor: colors.surfaceAlt,
    borderRadius: radius.lg,
    maxHeight: 180,
  },
  rationaleRow: { flexDirection: 'row', gap: 8, marginBottom: 8 },
  rationaleIcon: { fontSize: 16 },
  rationaleText: { flex: 1, fontSize: font.small, color: colors.text, lineHeight: 19 },
});
