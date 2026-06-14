/**
 * TypeScript types mirroring the real (future) backend data model so the
 * prototype's hardcoded content is forward-compatible. See BUILD_PLAN.md §2.
 */

export type ThreatDomainKey =
  | 'phishing'
  | 'passwords'
  | 'social_eng'
  | 'data_handling'
  | 'physical'
  | 'ai_deepfakes';

export interface ThreatDomain {
  key: ThreatDomainKey;
  name: string;
  icon: string; // emoji stand-in for an icon asset
  color: string;
}

export type ChallengeType = 'spot_the_phish' | 'mcq' | 'branching_scenario';

/** A single tappable region inside a spot-the-phish email. */
export interface PhishHotspot {
  id: string;
  /** Where it renders in the email layout. */
  zone: 'sender' | 'subject' | 'greeting' | 'body' | 'link' | 'attachment';
  /** The literal text shown for this region. */
  text: string;
  /** True if this region is a genuine red flag the user should tap. */
  isRedFlag: boolean;
  /** Shown after "Check" to teach why. */
  rationale: string;
}

export interface SpotThePhishPayload {
  type: 'spot_the_phish';
  prompt: string;
  email: {
    senderName: string;
    date: string;
    hotspots: PhishHotspot[];
  };
}

export interface McqPayload {
  type: 'mcq';
  prompt: string;
  options: { id: string; text: string }[];
  correctOptionId: string;
}

export type ChallengePayload = SpotThePhishPayload | McqPayload;

export interface Challenge {
  id: string;
  domainKey: ThreatDomainKey;
  type: ChallengeType;
  /** Polymorphic, type-specific content (mirrors Challenge.payload JSONB). */
  payload: ChallengePayload;
  /** Teaching note shown after the challenge is checked. */
  explanation: string;
  xp: number;
}

export interface Lesson {
  id: string;
  domainKey: ThreatDomainKey;
  title: string;
  estSeconds: number;
  challenges: Challenge[];
}

/** A node on the skill-tree path. */
export interface PathNode {
  id: string;
  lessonId: string | null; // null = locked/preview placeholder
  title: string;
  icon: string;
  state: 'done' | 'current' | 'locked';
}
