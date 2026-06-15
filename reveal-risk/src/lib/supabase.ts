/**
 * Supabase client + API seam for Phase 3 (BUILD_PLAN.md §1, §5).
 *
 * The local prototype runs fully offline against the Zustand store; this module
 * is the forward-compatible boundary for when the backend comes online. Screens
 * keep talking to a thin API (below) so swapping local → remote is a one-file change.
 *
 * Config via Expo public env vars (set in .env, see .env.example):
 *   EXPO_PUBLIC_SUPABASE_URL, EXPO_PUBLIC_SUPABASE_ANON_KEY
 */
import { createClient, SupabaseClient } from '@supabase/supabase-js';

const URL = process.env.EXPO_PUBLIC_SUPABASE_URL;
const ANON = process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY;

let _client: SupabaseClient | null = null;

/** Returns the client, or null if env isn't configured (prototype/offline mode). */
export function supabase(): SupabaseClient | null {
  if (_client) return _client;
  if (!URL || !ANON) return null;
  _client = createClient(URL, ANON, { auth: { persistSession: true, autoRefreshToken: true } });
  return _client;
}

export const isBackendConfigured = () => Boolean(URL && ANON);

export interface RemoteAttempt {
  challengeId: string;
  isCorrect: boolean;
  heartsLost: number;
  timeMs?: number;
}

export interface SessionResult {
  streak: number;
  streakIncreased: boolean;
  xpEarned: number;
  leveledUp: boolean;
  newBadge: string | null;
}

/**
 * Server-authoritative session commit via the edge function. Falls back to the
 * caller handling the offline path when the backend isn't configured.
 */
export async function completeSessionRemote(
  lessonId: string,
  attempts: RemoteAttempt[],
): Promise<SessionResult | null> {
  const sb = supabase();
  if (!sb) return null;
  const { data, error } = await sb.functions.invoke('complete-session', {
    body: { lessonId, attempts },
  });
  if (error) throw error;
  return data as SessionResult;
}

/** Manager dashboard: latest Human-Risk Score snapshots for the caller's org. */
export async function fetchRiskScores(): Promise<unknown[]> {
  const sb = supabase();
  if (!sb) return [];
  const { data, error } = await sb
    .from('human_risk_scores')
    .select('*')
    .order('computed_at', { ascending: false });
  if (error) throw error;
  return data ?? [];
}
