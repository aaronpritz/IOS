import { Lesson, PathNode } from './types';

/**
 * Hardcoded Phishing lesson for the prototype — authored in the real
 * Challenge.payload shape so it is forward-compatible with the backend.
 * One richly interactive spot-the-phish + two quick MCQs = a believable
 * 3-challenge, ~2-minute daily micro-session.
 */
export const PHISHING_LESSON: Lesson = {
  id: 'lesson_phish_01',
  domainKey: 'phishing',
  title: 'Spot the Phish',
  estSeconds: 120,
  challenges: [
    {
      id: 'ch_phish_email',
      domainKey: 'phishing',
      type: 'spot_the_phish',
      xp: 15,
      explanation:
        'Real red flags here: a look-alike sender domain (micros0ft), manufactured urgency, a generic greeting, and a link whose real destination differs from its text. Any one of these warrants caution — report, don’t click.',
      payload: {
        type: 'spot_the_phish',
        prompt: 'Tap every red flag you can find in this email, then press Check.',
        email: {
          senderName: 'Microsoft 365 Security',
          date: 'Today, 8:14 AM',
          hotspots: [
            {
              id: 'sender',
              zone: 'sender',
              text: 'IT-Support@micros0ft-secure.com',
              isRedFlag: true,
              rationale:
                'Look-alike domain: a zero in “micros0ft” and a tacked-on “-secure”. Legitimate Microsoft mail comes from microsoft.com.',
            },
            {
              id: 'subject',
              zone: 'subject',
              text: 'URGENT: Your account will be DEACTIVATED in 24 hours',
              isRedFlag: true,
              rationale:
                'Manufactured urgency and pressure are classic phishing tactics to make you act before you think.',
            },
            {
              id: 'greeting',
              zone: 'greeting',
              text: 'Dear Valued User,',
              isRedFlag: true,
              rationale:
                'A generic greeting instead of your name suggests a mass-sent phish, not a real account notice.',
            },
            {
              id: 'body1',
              zone: 'body',
              text:
                'We detected unusual sign-in activity on your account from a new device.',
              isRedFlag: false,
              rationale:
                'This sentence alone is plausible — real security emails say similar things. Context (the rest of the email) is what gives it away.',
            },
            {
              id: 'link',
              zone: 'link',
              text: 'Verify My Account  →  http://account-verify.micros0ft-secure.ru/login',
              isRedFlag: true,
              rationale:
                'The link text says “Verify My Account” but the real URL points to a suspicious .ru look-alike domain. Always hover to reveal the true destination.',
            },
            {
              id: 'signoff',
              zone: 'body',
              text: 'The Microsoft Account Team',
              isRedFlag: false,
              rationale:
                'A sign-off like this is normal on its own — it’s not by itself a red flag.',
            },
          ],
        },
      },
    },
    {
      id: 'ch_phish_scenario',
      domainKey: 'social_eng',
      type: 'branching_scenario',
      xp: 20,
      explanation:
        'Vishing (voice phishing) relies on urgency and authority. The secure move is always: never share codes or passwords, and verify the caller through an official channel you initiate.',
      payload: {
        type: 'branching_scenario',
        prompt: 'Play it out — make the secure choice at each step.',
        startNodeId: 's1',
        nodes: [
          {
            id: 's1',
            speaker: '📞 Incoming call — "IT Help Desk"',
            text: 'Hi, this is Alex from IT Support. We’re seeing suspicious logins on your account and need to secure it right now. Can you confirm the 6-digit code we just texted you?',
            choices: [
              {
                id: 'a',
                text: 'Read them the code so they can fix it fast',
                next: 'bad1',
                isSafe: false,
                feedback: 'Never share an MFA code — that code is the second factor an attacker needs to take over your account.',
              },
              {
                id: 'b',
                text: 'Decline and say you’ll call IT back on the official number',
                next: 's2',
                isSafe: true,
                feedback: 'Right — verify through a channel you initiate, not one the caller gave you.',
              },
            ],
          },
          {
            id: 'bad1',
            speaker: 'Narrator',
            text: 'Within seconds, the attacker uses your code to log in and resets your password. They now control your account.',
            choices: [],
            outcome: 'compromised',
          },
          {
            id: 's2',
            speaker: '📞 Caller (more insistent)',
            text: 'There’s no time for that — your account will be locked in 2 minutes and you’ll lose access to payroll. Just confirm the code and we’re done.',
            choices: [
              {
                id: 'a',
                text: 'The urgency worries you — give in and share the code',
                next: 'bad1',
                isSafe: false,
                feedback: 'Manufactured urgency is the pressure tactic. Real IT won’t rush you into revealing a code.',
              },
              {
                id: 'b',
                text: 'Hang up and report the call to security',
                next: 'good1',
                isSafe: true,
                feedback: 'Exactly. Hang up, then report — that alert helps protect everyone.',
              },
            ],
          },
          {
            id: 'good1',
            speaker: 'Narrator',
            text: 'You hang up and report the call. Security confirms it was an attacker and warns the company. Your account stays safe.',
            choices: [],
            outcome: 'safe',
          },
        ],
      },
    },
    {
      id: 'ch_phish_mcq1',
      domainKey: 'phishing',
      type: 'mcq',
      xp: 10,
      explanation:
        'When an email pressures you to act fast and click a link, the safest move is to go to the site yourself through a known-good bookmark — never the email’s link.',
      payload: {
        type: 'mcq',
        prompt:
          'An email says your account will be locked unless you “verify” within 1 hour. What’s the safest first move?',
        options: [
          { id: 'a', text: 'Click the link quickly so you don’t get locked out' },
          { id: 'b', text: 'Open the site yourself via a saved bookmark and check there' },
          { id: 'c', text: 'Reply to the email asking if it’s real' },
          { id: 'd', text: 'Forward it to all your coworkers as a warning' },
        ],
        correctOptionId: 'b',
      },
    },
    {
      id: 'ch_phish_mcq2',
      domainKey: 'phishing',
      type: 'mcq',
      xp: 10,
      explanation:
        'Reporting via your “Report Phishing” button alerts security so they can protect everyone — and it’s how a real program measures the rising report-rate that lowers org risk.',
      payload: {
        type: 'mcq',
        prompt: 'You’re confident an email is phishing. What’s the best action?',
        options: [
          { id: 'a', text: 'Just delete it and move on' },
          { id: 'b', text: 'Unsubscribe using the link at the bottom' },
          { id: 'c', text: 'Use the “Report Phishing” button to alert security' },
          { id: 'd', text: 'Open the attachment to confirm it’s malicious' },
        ],
        correctOptionId: 'c',
      },
    },
  ],
};

/** The Phishing path shown on the home screen — first node is today's lesson. */
export const PHISHING_PATH: PathNode[] = [
  { id: 'n1', lessonId: PHISHING_LESSON.id, title: 'Spot the Phish', icon: '🎣', state: 'current' },
  { id: 'n2', lessonId: null, title: 'Suspicious Links', icon: '🔗', state: 'locked' },
  { id: 'n3', lessonId: null, title: 'Fake Login Pages', icon: '🪪', state: 'locked' },
  { id: 'n4', lessonId: null, title: 'Smishing & Vishing', icon: '📱', state: 'locked' },
];
