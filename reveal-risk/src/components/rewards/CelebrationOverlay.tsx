import React, { useEffect, useRef, useState } from 'react';
import { View, Text, StyleSheet, Animated, Easing, Image } from 'react-native';
import { colors, font } from '../../theme/tokens';
import { Button } from '../ui/Button';
import { SparkAvatar } from '../brand/SparkAvatar';
import { CELEBRATION_SPARK_URL } from '../../data/assets';
import { feedbackCelebrate } from '../../lib/feedback';

const CONFETTI_COLORS = [colors.streak, colors.primary, colors.xp, colors.gem, colors.heart, colors.warn];

/** A single looping confetti piece falling across the overlay. */
function ConfettiPiece({ index }: { index: number }) {
  const fall = useRef(new Animated.Value(0)).current;
  const size = 8 + (index % 3) * 3;
  const duration = 1600 + (index % 5) * 320;
  const delay = (index % 6) * 220;

  useEffect(() => {
    const anim = Animated.loop(
      Animated.timing(fall, { toValue: 1, duration, delay, easing: Easing.linear, useNativeDriver: true })
    );
    anim.start();
    return () => anim.stop();
  }, [fall, duration, delay]);

  const translateY = fall.interpolate({ inputRange: [0, 1], outputRange: [-40, 760] });
  const rotate = fall.interpolate({ inputRange: [0, 1], outputRange: ['0deg', `${(index % 2 ? 1 : -1) * 540}deg`] });
  const opacity = fall.interpolate({ inputRange: [0, 0.08, 0.85, 1], outputRange: [0, 1, 1, 0] });

  return (
    <Animated.View
      style={[
        styles.confetti,
        {
          left: `${(index * 37) % 100}%`,
          width: size,
          height: size * 0.5,
          backgroundColor: CONFETTI_COLORS[index % CONFETTI_COLORS.length],
          transform: [{ translateY }, { rotate }],
          opacity,
        },
      ]}
    />
  );
}

interface Props {
  title: string;
  subtitle: string;
  onDone: () => void;
}

/** Full-screen celebration "cutscene" shown on milestones (streaks, level-ups, badges). */
export function CelebrationOverlay({ title, subtitle, onDone }: Props) {
  const scale = useRef(new Animated.Value(0)).current;
  const fade = useRef(new Animated.Value(0)).current;
  const [imgFailed, setImgFailed] = useState(false);

  useEffect(() => {
    feedbackCelebrate();
    // JS driver so opacity reliably reaches 1 on react-native-web (native-driven
    // opacity can stay stuck at 0 / invisible there).
    Animated.parallel([
      Animated.timing(fade, { toValue: 1, duration: 220, useNativeDriver: false }),
      Animated.spring(scale, { toValue: 1, friction: 5, tension: 80, useNativeDriver: false }),
    ]).start();
  }, [fade, scale]);

  return (
    <Animated.View style={[styles.root, { opacity: fade }]}>
      {Array.from({ length: 18 }).map((_, i) => (
        <ConfettiPiece key={i} index={i} />
      ))}

      <Animated.View style={[styles.card, { transform: [{ scale }] }]}>
        {!imgFailed ? (
          <Image
            source={{ uri: CELEBRATION_SPARK_URL }}
            style={styles.spark}
            resizeMode="contain"
            onError={() => setImgFailed(true)}
          />
        ) : (
          <SparkAvatar size={150} mood="cheer" />
        )}
        <Text style={styles.title}>{title}</Text>
        <Text style={styles.subtitle}>{subtitle}</Text>
      </Animated.View>

      <View style={styles.btnWrap}>
        <Button label="Awesome!" onPress={onDone} />
      </View>
    </Animated.View>
  );
}

const styles = StyleSheet.create({
  root: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: 'rgba(13, 27, 51, 0.92)',
    alignItems: 'center',
    justifyContent: 'center',
    overflow: 'hidden',
    zIndex: 200,
    paddingHorizontal: 24,
  },
  confetti: { position: 'absolute', top: 0, borderRadius: 2 },
  card: { alignItems: 'center', gap: 8 },
  spark: { width: 180, height: 180 },
  title: { fontSize: 34, fontWeight: '900', color: '#fff', textAlign: 'center', marginTop: 6 },
  subtitle: { fontSize: font.h3, color: 'rgba(255,255,255,0.85)', fontWeight: '600', textAlign: 'center' },
  btnWrap: { position: 'absolute', bottom: 40, left: 24, right: 24 },
});
