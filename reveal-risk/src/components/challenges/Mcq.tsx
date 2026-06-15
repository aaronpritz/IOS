import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { McqPayload } from '../../data/types';

interface Props {
  payload: McqPayload;
  onResult: (result: { isCorrect: boolean; mistakes: number }) => void;
}

/** Single-answer multiple choice with immediate right/wrong reveal. */
export function Mcq({ payload, onResult }: Props) {
  const [picked, setPicked] = useState<string | null>(null);
  const [checked, setChecked] = useState(false);

  function check() {
    if (!picked) return;
    const isCorrect = picked === payload.correctOptionId;
    setChecked(true);
    onResult({ isCorrect, mistakes: isCorrect ? 0 : 1 });
  }

  return (
    <View style={{ flex: 1 }}>
      <Text style={styles.prompt}>{payload.prompt}</Text>
      <View style={{ gap: 10, marginTop: 8 }}>
        {payload.options.map((o) => {
          const isPicked = picked === o.id;
          const isAnswer = o.id === payload.correctOptionId;
          let border: string = colors.border;
          let bg: string = colors.surface;
          if (checked) {
            if (isAnswer) {
              border = colors.primary;
              bg = '#E6F7F0';
            } else if (isPicked) {
              border = colors.danger;
              bg = '#FDECEE';
            }
          } else if (isPicked) {
            border = colors.xp;
            bg = '#EEF1FE';
          }
          return (
            <Pressable
              key={o.id}
              disabled={checked}
              onPress={() => setPicked(o.id)}
              style={[styles.option, { borderColor: border, backgroundColor: bg }]}
            >
              <Text style={styles.optionText}>{o.text}</Text>
              {checked && isAnswer && <Text>✅</Text>}
              {checked && isPicked && !isAnswer && <Text>❌</Text>}
            </Pressable>
          );
        })}
      </View>

      {!checked && (
        <Pressable
          onPress={check}
          disabled={!picked}
          style={[styles.checkBtn, { opacity: picked ? 1 : 0.4 }]}
        >
          <Text style={styles.checkLabel}>Check</Text>
        </Pressable>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  prompt: { fontSize: font.h3, fontWeight: '700', color: colors.text, lineHeight: 25 },
  option: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    gap: 10,
    borderWidth: 2,
    borderRadius: radius.md,
    paddingVertical: 14,
    paddingHorizontal: 16,
  },
  optionText: { flex: 1, fontSize: font.body, color: colors.text, fontWeight: '600' },
  checkBtn: {
    marginTop: 16,
    backgroundColor: colors.navy,
    borderRadius: radius.lg,
    paddingVertical: 13,
    alignItems: 'center',
  },
  checkLabel: { color: '#fff', fontWeight: '800', fontSize: font.body },
});
