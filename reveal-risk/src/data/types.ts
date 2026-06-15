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

export type ChallengeType =
  | 'spot_the_phish'
  | 'mcq'
  | 'branching_scenario'
  | 'password_strength';

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

/** One choice the user can make at a scenario node. */
export interface ScenarioChoice {
  id: string;
  text: string;
  /** Id of the next node, or 'END' to finish. */
  next: string;
  /** True if this is the security-correct choice. */
  isSafe: boolean;
  /** Inline coaching shown after the choice. */
  feedback: string;
}

/** A single step in a branching social-engineering scenario. */
export interface ScenarioNode {
  id: string;
  /** Who is "speaking" (e.g. "Caller", "Text message", "Narrator"). */
  speaker: string;
  /** The situation / message presented to the user. */
  text: string;
  /** Empty choices = terminal node. */
  choices: ScenarioChoice[];
  /** For terminal nodes: did the user end up safe or compromised? */
  outcome?: 'safe' | 'compromised';
}

export interface BranchingScenarioPayload {
  type: 'branching_scenario';
  prompt: string;
  startNodeId: string;
  nodes: ScenarioNode[];
}

/** One improvement the user can apply to a weak password. */
export interface PasswordFix {
  id: string;
  label: string;
  /** Strength points this fix contributes (0–100 scale across all fixes). */
  points: number;
  /** Shown after Check to teach why it matters. */
  rationale: string;
}

export interface PasswordStrengthPayload {
  type: 'password_strength';
  prompt: string;
  /** The weak starting password shown to the user. */
  base: string;
  fixes: PasswordFix[];
  /** Strength (0–100) required to pass. */
  threshold: number;
}

export type ChallengePayload =
  | SpotThePhishPayload
  | McqPayload
  | BranchingScenarioPayload
  | PasswordStrengthPayload;

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
