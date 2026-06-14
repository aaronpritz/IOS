import React, { useState } from 'react';
import { Image } from 'react-native';
import { Mascot } from './Mascot';
import { MASCOT_IMAGE_URL } from '../../data/assets';

/**
 * Renders the illustrated (Higgsfield) Spark mascot from a runtime URL, falling
 * back to the self-contained SVG Mascot if the image can't load. Drop-in for
 * <Mascot> with the same size/mood props.
 */
export function SparkAvatar({
  size = 96,
  mood = 'happy',
}: {
  size?: number;
  mood?: 'happy' | 'cheer';
}) {
  const [failed, setFailed] = useState(false);
  if (failed) return <Mascot size={size} mood={mood} />;
  return (
    <Image
      source={{ uri: MASCOT_IMAGE_URL }}
      style={{ width: size * 1.25, height: size * 1.25 }}
      resizeMode="contain"
      onError={() => setFailed(true)}
      accessibilityLabel="Spark, the CyberSpark mascot"
    />
  );
}
