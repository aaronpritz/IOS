import { Platform } from 'react-native';
import * as Notifications from 'expo-notifications';

/**
 * Daily reminder scheduling — the core retention lever from the blueprint.
 *
 * Native: schedules a repeating daily local notification at the chosen hour via
 * expo-notifications (works in an EAS build). Web: best-effort — requests the
 * browser Notification permission and shows a confirmation (true daily web push
 * needs a service worker + push backend, a Phase-4 item).
 */

const HOURS: Record<string, number> = { morning: 9, midday: 12, evening: 19 };
const LABELS: Record<string, string> = { morning: '9:00 AM', midday: '12:00 PM', evening: '7:00 PM' };

export type ReminderResult = 'scheduled' | 'web' | 'denied' | 'unsupported';

export function reminderLabel(time: string | null): string {
  return time ? LABELS[time] ?? '7:00 PM' : '7:00 PM';
}

export async function enableDailyReminder(reminderTime: string | null): Promise<ReminderResult> {
  const key = reminderTime ?? 'evening';
  const hour = HOURS[key] ?? 19;

  if (Platform.OS === 'web') {
    try {
      const N = (globalThis as any).Notification;
      if (!N) return 'unsupported';
      const perm = await N.requestPermission();
      if (perm !== 'granted') return 'denied';
      new N('CyberSpark reminders are on 🔥', {
        body: `We’ll nudge you around ${reminderLabel(key)} to keep your streak alive.`,
      });
      return 'web';
    } catch {
      return 'unsupported';
    }
  }

  // Native path.
  try {
    const { status } = await Notifications.requestPermissionsAsync();
    if (status !== 'granted') return 'denied';
    await Notifications.cancelAllScheduledNotificationsAsync();
    await Notifications.scheduleNotificationAsync({
      content: { title: 'Keep your streak alive 🔥', body: '2 minutes of CyberSpark today?' },
      trigger: { hour, minute: 0, repeats: true } as any,
    });
    return 'scheduled';
  } catch {
    return 'unsupported';
  }
}

export async function disableReminders(): Promise<void> {
  if (Platform.OS === 'web') return;
  try {
    await Notifications.cancelAllScheduledNotificationsAsync();
  } catch {}
}
