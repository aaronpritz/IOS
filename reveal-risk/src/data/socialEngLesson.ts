import { Lesson } from './types';

/** Social Engineering — tailgating/pretexting scenario + BEC checks. */
export const SOCIAL_ENG_LESSON: Lesson = {
  id: 'lesson_socialeng_01',
  domainKey: 'social_eng',
  title: 'Social Engineering',
  estSeconds: 120,
  challenges: [
    {
      id: 'ch_se_scenario',
      domainKey: 'social_eng',
      type: 'branching_scenario',
      xp: 20,
      explanation:
        'Tailgating exploits your courtesy, not a technical flaw. It’s not rude to verify — politely direct unbadged visitors to reception. Holding firm protects everyone.',
      payload: {
        type: 'branching_scenario',
        prompt: 'You’re at a secure door. Make the right call.',
        startNodeId: 's1',
        nodes: [
          {
            id: 's1',
            speaker: '🚪 At the secure entrance',
            text: 'You badge in. Someone in a delivery uniform hurries over, arms full of boxes: “Hold the door? I forgot my badge and I’m late for a drop-off.”',
            choices: [
              { id: 'a', text: 'Be nice — hold the door open', next: 'bad1', isSafe: false, feedback: 'That’s tailgating — an unverified person just bypassed access control on your badge.' },
              { id: 'b', text: 'Politely point them to reception to sign in', next: 's2', isSafe: true, feedback: 'Right — verification isn’t rude, it’s the policy.' },
            ],
          },
          {
            id: 's2',
            speaker: '😤 They push back',
            text: '“Come on, these are heavy and it’s freezing. Your coworker always lets me in.”',
            choices: [
              { id: 'a', text: 'Give in — hold it open', next: 'bad1', isSafe: false, feedback: 'Pressure + “others do it” is the manipulation. Don’t cave.' },
              { id: 'b', text: 'Hold firm and offer to call reception', next: 'good1', isSafe: true, feedback: 'Exactly — stay polite but firm, and let reception verify.' },
            ],
          },
          { id: 'bad1', speaker: 'Narrator', text: 'An unauthorized person is now inside the secure area. That’s a physical breach.', choices: [], outcome: 'compromised' },
          { id: 'good1', speaker: 'Narrator', text: 'Reception verifies the visitor properly. You kept the building secure.', choices: [], outcome: 'safe' },
        ],
      },
    },
    {
      id: 'ch_se_mcq1',
      domainKey: 'social_eng',
      type: 'mcq',
      xp: 10,
      explanation: 'Social engineers target human instincts — here, your courtesy and urge to help — rather than any technical control.',
      payload: {
        type: 'mcq',
        prompt: 'When someone rushes you with full arms at a secure door, what are they exploiting?',
        options: [
          { id: 'a', text: 'A flaw in the door lock' },
          { id: 'b', text: 'Your courtesy and desire to be helpful' },
          { id: 'c', text: 'Your technical skills' },
          { id: 'd', text: 'The building’s Wi-Fi' },
        ],
        correctOptionId: 'b',
      },
    },
    {
      id: 'ch_se_mcq2',
      domainKey: 'social_eng',
      type: 'mcq',
      xp: 10,
      explanation: 'Urgent “buy gift cards and send the codes” requests are a classic Business Email Compromise scam — verify through a known channel and report it.',
      payload: {
        type: 'mcq',
        prompt: 'An email from “the CEO” urgently asks you to buy gift cards and send the codes. This is…',
        options: [
          { id: 'a', text: 'A normal executive request — just do it' },
          { id: 'b', text: 'A gift-card / business-email-compromise scam — verify and report' },
          { id: 'c', text: 'Fine as long as the email looks legit' },
          { id: 'd', text: 'Urgent, so act fast to help' },
        ],
        correctOptionId: 'b',
      },
    },
  ],
};
