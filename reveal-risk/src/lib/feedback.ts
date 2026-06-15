import { Platform } from 'react-native';

/**
 * Lightweight audio + haptic feedback. On web we synthesize short tones with the
 * Web Audio API (no asset files) and use the Vibration API. On native this is a
 * no-op for now; expo-haptics can be wired in for a native build.
 */

let ctx: any = null;
function audioCtx(): any {
  if (Platform.OS !== 'web' || typeof window === 'undefined') return null;
  try {
    const AC = (window as any).AudioContext || (window as any).webkitAudioContext;
    if (!AC) return null;
    if (!ctx) ctx = new AC();
    // Resume if the browser suspended it before a user gesture.
    if (ctx.state === 'suspended') ctx.resume?.();
    return ctx;
  } catch {
    return null;
  }
}

/** Play a short sequence of tones. */
function tone(freqs: number[], duration = 0.12, type: string = 'sine') {
  const ac = audioCtx();
  if (!ac) return;
  let t = ac.currentTime;
  for (const f of freqs) {
    const osc = ac.createOscillator();
    const gain = ac.createGain();
    osc.type = type;
    osc.frequency.value = f;
    gain.gain.setValueAtTime(0.0001, t);
    gain.gain.exponentialRampToValueAtTime(0.16, t + 0.012);
    gain.gain.exponentialRampToValueAtTime(0.0001, t + duration);
    osc.connect(gain).connect(ac.destination);
    osc.start(t);
    osc.stop(t + duration);
    t += duration * 0.85;
  }
}

function vibrate(pattern: number | number[]) {
  if (Platform.OS === 'web' && typeof navigator !== 'undefined' && (navigator as any).vibrate) {
    try {
      (navigator as any).vibrate(pattern);
    } catch {}
  }
}

export function feedbackCorrect() {
  tone([660, 880], 0.11);
  vibrate(25);
}

export function feedbackWrong() {
  tone([196, 156], 0.16, 'square');
  vibrate([35, 30, 35]);
}

export function feedbackCelebrate() {
  tone([523, 659, 784, 1047], 0.13);
  vibrate([20, 30, 20, 30, 60]);
}
