import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable, ScrollView } from 'react-native';
import { colors, radius, font } from '../../theme/tokens';
import { BranchingScenarioPayload, ScenarioNode } from '../../data/types';

interface Props {
  payload: BranchingScenarioPayload;
  /** Correct if the user reaches a 'safe' outcome with no unsafe choices. */
  onResult: (result: { isCorrect: boolean; mistakes: number }) => void;
}

interface Turn {
  node: ScenarioNode;
  chosenText?: string;
  feedback?: string;
  wasSafe?: boolean;
}

/**
 * A branching social-engineering roleplay: the user makes choices through a
 * live scenario (e.g. a vishing call). Each unsafe choice is a mistake.
 */
export function BranchingScenario({ payload, onResult }: Props) {
  const nodeById = (id: string) => payload.nodes.find((n) => n.id === id)!;
  const [history, setHistory] = useState<Turn[]>([{ node: nodeById(payload.startNodeId) }]);
  const [unsafeChoices, setUnsafeChoices] = useState(0);
  const [done, setDone] = useState(false);

  const current = history[history.length - 1];
  const atTerminal = current.node.choices.length === 0;

  function choose(choiceId: string) {
    const choice = current.node.choices.find((c) => c.id === choiceId)!;
    const newUnsafe = unsafeChoices + (choice.isSafe ? 0 : 1);
    setUnsafeChoices(newUnsafe);

    // Record the feedback on the current turn.
    const updated = [...history];
    updated[updated.length - 1] = {
      ...current,
      chosenText: choice.text,
      feedback: choice.feedback,
      wasSafe: choice.isSafe,
    };

    if (choice.next === 'END') {
      setHistory(updated);
      finish(newUnsafe, current.node.outcome);
      return;
    }

    const nextNode = nodeById(choice.next);
    updated.push({ node: nextNode });
    setHistory(updated);

    if (nextNode.choices.length === 0) {
      finish(newUnsafe, nextNode.outcome);
    }
  }

  function finish(unsafe: number, outcome?: 'safe' | 'compromised') {
    if (done) return;
    setDone(true);
    const isCorrect = unsafe === 0 && outcome !== 'compromised';
    onResult({ isCorrect, mistakes: unsafe });
  }

  return (
    <View style={{ flex: 1 }}>
      <Text style={styles.prompt}>{payload.prompt}</Text>

      <ScrollView style={{ flex: 1 }} contentContainerStyle={{ paddingBottom: 8 }}>
        {history.map((turn, i) => (
          <View key={i} style={{ marginBottom: 12 }}>
            {/* The scenario message (chat bubble on the left) */}
            <View style={styles.bubble}>
              <Text style={styles.speaker}>{turn.node.speaker}</Text>
              <Text style={styles.bubbleText}>{turn.node.text}</Text>
              {turn.node.outcome && (
                <Text style={[styles.outcome, { color: turn.node.outcome === 'safe' ? colors.primaryDark : colors.danger }]}>
                  {turn.node.outcome === 'safe' ? '🛡️ You stayed secure.' : '⚠️ You were compromised.'}
                </Text>
              )}
            </View>

            {/* The user's choice + its feedback */}
            {turn.chosenText && (
              <>
                <View style={styles.choiceBubble}>
                  <Text style={styles.choiceBubbleText}>{turn.chosenText}</Text>
                </View>
                {turn.feedback && (
                  <Text style={[styles.feedback, { color: turn.wasSafe ? colors.primaryDark : colors.danger }]}>
                    {turn.wasSafe ? '✅ ' : '✗ '}{turn.feedback}
                  </Text>
                )}
              </>
            )}
          </View>
        ))}
      </ScrollView>

      {/* Active choices */}
      {!atTerminal && !current.chosenText && (
        <View style={{ gap: 10, marginTop: 4 }}>
          {current.node.choices.map((c) => (
            <Pressable key={c.id} onPress={() => choose(c.id)} style={styles.choiceBtn}>
              <Text style={styles.choiceBtnText}>{c.text}</Text>
            </Pressable>
          ))}
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  prompt: { fontSize: font.body, color: colors.textMuted, marginBottom: 10, fontWeight: '600' },
  bubble: {
    alignSelf: 'flex-start',
    maxWidth: '88%',
    backgroundColor: colors.surface,
    borderRadius: radius.lg,
    borderTopLeftRadius: 4,
    borderWidth: 1,
    borderColor: colors.border,
    padding: 12,
  },
  speaker: { fontSize: font.tiny, fontWeight: '800', color: colors.textMuted, letterSpacing: 0.5, marginBottom: 3 },
  bubbleText: { fontSize: font.body, color: colors.text, lineHeight: 21 },
  outcome: { marginTop: 8, fontSize: font.small, fontWeight: '800' },
  choiceBubble: {
    alignSelf: 'flex-end',
    maxWidth: '88%',
    backgroundColor: colors.navy,
    borderRadius: radius.lg,
    borderTopRightRadius: 4,
    padding: 12,
    marginTop: 8,
  },
  choiceBubbleText: { fontSize: font.body, color: '#fff', fontWeight: '600' },
  feedback: { alignSelf: 'flex-end', maxWidth: '88%', marginTop: 5, fontSize: font.small, fontWeight: '600', textAlign: 'right' },
  choiceBtn: {
    borderWidth: 2,
    borderColor: colors.borderStrong,
    borderRadius: radius.md,
    paddingVertical: 14,
    paddingHorizontal: 16,
    backgroundColor: colors.surface,
  },
  choiceBtnText: { fontSize: font.body, color: colors.text, fontWeight: '700' },
});
