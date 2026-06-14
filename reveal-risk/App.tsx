import React, { useState } from 'react';
import { View, Text, StyleSheet, Pressable, Platform } from 'react-native';
import { StatusBar } from 'expo-status-bar';
import { colors, radius, font } from './src/theme/tokens';
import { PathScreen } from './src/screens/PathScreen';
import { LessonScreen, LessonSummary } from './src/screens/LessonScreen';
import { ResultsScreen } from './src/screens/ResultsScreen';
import { LeaguesScreen } from './src/screens/LeaguesScreen';
import { ProfileScreen } from './src/screens/ProfileScreen';
import { useGameStore } from './src/store/useGameStore';

type Tab = 'learn' | 'leagues' | 'profile';
type Flow = 'home' | 'lesson' | 'results';

export default function App() {
  const [tab, setTab] = useState<Tab>('learn');
  const [flow, setFlow] = useState<Flow>('home');
  const [summary, setSummary] = useState<LessonSummary | null>(null);

  const advanceDay = useGameStore((s) => s.advanceDay);
  const resetProgress = useGameStore((s) => s.resetProgress);
  const dayOffset = useGameStore((s) => s.dayOffset);

  const fullScreen = flow === 'lesson' || flow === 'results';

  return (
    <View style={styles.app}>
      <StatusBar style="dark" />
      <View style={styles.phone}>
        {!fullScreen && (
          <View style={styles.appbar}>
            <Text style={styles.brand}>
              <Text style={{ color: colors.primary }}>◆</Text> Reveal Risk
            </Text>
            <View style={styles.devRow}>
              <DevBtn label={`+1 day (${dayOffset})`} onPress={advanceDay} />
              <DevBtn label="reset" onPress={resetProgress} />
            </View>
          </View>
        )}

        <View style={{ flex: 1 }}>
          {flow === 'home' && tab === 'learn' && (
            <PathScreen onStartLesson={() => setFlow('lesson')} />
          )}
          {flow === 'home' && tab === 'leagues' && <LeaguesScreen />}
          {flow === 'home' && tab === 'profile' && <ProfileScreen />}

          {flow === 'lesson' && (
            <LessonScreen
              lessonId="lesson_phish_01"
              onExit={() => setFlow('home')}
              onComplete={(s) => {
                setSummary(s);
                setFlow('results');
              }}
            />
          )}
          {flow === 'results' && summary && (
            <ResultsScreen summary={summary} onDone={() => setFlow('home')} />
          )}
        </View>

        {!fullScreen && (
          <View style={styles.tabbar}>
            <TabBtn icon="📚" label="Learn" active={tab === 'learn'} onPress={() => setTab('learn')} />
            <TabBtn icon="🏆" label="Leagues" active={tab === 'leagues'} onPress={() => setTab('leagues')} />
            <TabBtn icon="🧑‍💻" label="Profile" active={tab === 'profile'} onPress={() => setTab('profile')} />
          </View>
        )}
      </View>
    </View>
  );
}

function TabBtn({ icon, label, active, onPress }: { icon: string; label: string; active: boolean; onPress: () => void }) {
  return (
    <Pressable style={styles.tab} onPress={onPress}>
      <Text style={[styles.tabIcon, { opacity: active ? 1 : 0.5 }]}>{icon}</Text>
      <Text style={[styles.tabLabel, { color: active ? colors.primary : colors.textMuted }]}>{label}</Text>
    </Pressable>
  );
}

function DevBtn({ label, onPress }: { label: string; onPress: () => void }) {
  return (
    <Pressable onPress={onPress} style={styles.devBtn}>
      <Text style={styles.devBtnText}>{label}</Text>
    </Pressable>
  );
}

const styles = StyleSheet.create({
  app: {
    flex: 1,
    backgroundColor: '#0B1220',
    alignItems: 'center',
    justifyContent: 'center',
  },
  // On web, frame the app like a phone; on native it fills the screen.
  phone: Platform.select({
    web: {
      width: '100%',
      maxWidth: 430,
      height: '100%',
      maxHeight: 900,
      backgroundColor: colors.bg,
      overflow: 'hidden',
    },
    default: { flex: 1, width: '100%', backgroundColor: colors.bg, paddingTop: 44 },
  }) as any,
  appbar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingTop: Platform.OS === 'web' ? 14 : 0,
    paddingBottom: 10,
    borderBottomWidth: 1,
    borderBottomColor: colors.border,
    backgroundColor: colors.surface,
  },
  brand: { fontSize: font.h3, fontWeight: '900', color: colors.navy },
  devRow: { flexDirection: 'row', gap: 6 },
  devBtn: { backgroundColor: colors.surfaceAlt, borderRadius: radius.pill, paddingHorizontal: 10, paddingVertical: 5 },
  devBtnText: { fontSize: font.tiny, fontWeight: '700', color: colors.textMuted },
  tabbar: {
    flexDirection: 'row',
    borderTopWidth: 1,
    borderTopColor: colors.border,
    backgroundColor: colors.surface,
    paddingBottom: Platform.OS === 'web' ? 8 : 22,
    paddingTop: 8,
  },
  tab: { flex: 1, alignItems: 'center', gap: 2 },
  tabIcon: { fontSize: 22 },
  tabLabel: { fontSize: font.tiny, fontWeight: '800' },
});
