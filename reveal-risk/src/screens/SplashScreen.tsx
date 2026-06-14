import React, { useEffect, useState } from 'react';
import { View, Text, StyleSheet, Image, Pressable, ActivityIndicator } from 'react-native';
import { colors, font, radius } from '../theme/tokens';
import { Mascot } from '../components/brand/Mascot';
import { TITLE_SCREEN_URL } from '../data/assets';

interface Props {
  onDone: () => void;
}

/**
 * Opening splash using the Higgsfield-generated CyberSpark title graphic (loaded
 * by URL). Auto-dismisses after a beat or on tap. If the image can't load, a
 * branded fallback (SVG Spark + wordmark) shows instead.
 */
export function SplashScreen({ onDone }: Props) {
  const [failed, setFailed] = useState(false);
  const [loaded, setLoaded] = useState(false);

  useEffect(() => {
    const t = setTimeout(onDone, 2800);
    return () => clearTimeout(t);
  }, [onDone]);

  return (
    <Pressable style={styles.root} onPress={onDone} accessibilityLabel="Skip intro">
      {!failed ? (
        <>
          <Image
            source={{ uri: TITLE_SCREEN_URL }}
            style={styles.image}
            resizeMode="cover"
            onLoad={() => setLoaded(true)}
            onError={() => setFailed(true)}
          />
          {!loaded && (
            <View style={styles.loadingOverlay}>
              <Mascot size={96} mood="cheer" />
              <ActivityIndicator color="#fff" style={{ marginTop: 16 }} />
            </View>
          )}
        </>
      ) : (
        <Fallback />
      )}

      <View style={styles.tapHint} pointerEvents="none">
        <Text style={styles.tapHintText}>tap to start</Text>
      </View>
    </Pressable>
  );
}

/** Branded fallback if the title graphic can't be fetched. */
function Fallback() {
  return (
    <View style={styles.fallback}>
      <Mascot size={132} mood="cheer" />
      <Text style={styles.wordmark}>
        Cyber<Text style={{ color: colors.primary }}>Spark</Text>
      </Text>
      <Text style={styles.tagline}>Cyber skills, one streak at a time</Text>
      <View style={styles.byTag}>
        <Text style={styles.byText}>by Reveal Risk</Text>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: colors.navy,
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 100,
  },
  image: { width: '100%', height: '100%' },
  loadingOverlay: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.navy,
  },
  fallback: { flex: 1, alignSelf: 'stretch', alignItems: 'center', justifyContent: 'center', gap: 14, padding: 24 },
  wordmark: { fontSize: 40, fontWeight: '900', color: '#fff', marginTop: 8 },
  tagline: { fontSize: font.h3, color: 'rgba(255,255,255,0.85)', fontWeight: '600', textAlign: 'center' },
  byTag: {
    marginTop: 8,
    borderWidth: 1,
    borderColor: 'rgba(255,255,255,0.3)',
    borderRadius: radius.pill,
    paddingHorizontal: 14,
    paddingVertical: 6,
  },
  byText: { color: 'rgba(255,255,255,0.85)', fontWeight: '700', fontSize: font.small },
  tapHint: { position: 'absolute', bottom: 28 },
  tapHintText: { color: 'rgba(255,255,255,0.8)', fontWeight: '700', fontSize: font.small, letterSpacing: 1 },
});
