import { Lesson } from './types';

/** Deepfake Voices — AI/deepfakes domain: a voice-clone CEO-fraud scenario + checks. */
export const DEEPFAKE_LESSON: Lesson = {
  id: 'lesson_deepfake_01',
  domainKey: 'ai_deepfakes',
  title: 'Deepfake Voices',
  estSeconds: 120,
  challenges: [
    {
      id: 'ch_df_scenario',
      domainKey: 'ai_deepfakes',
      type: 'branching_scenario',
      xp: 20,
      explanation:
        'AI can clone a voice from seconds of audio. Urgency + secrecy + an unusual payment or credential request is the red-flag combo. Always verify out-of-band through a known, trusted channel.',
      payload: {
        type: 'branching_scenario',
        prompt: 'It sounds exactly like your CEO. Make the secure choice.',
        startNodeId: 's1',
        nodes: [
          {
            id: 's1',
            speaker: '📞 “Your CEO” calling',
            text: '“I need you to wire $48,000 to a new vendor right now. It’s confidential — don’t tell anyone. I’m about to go into a board meeting, just handle it.”',
            choices: [
              { id: 'a', text: 'It’s the CEO’s voice — start the wire', next: 'bad1', isSafe: false, feedback: 'A cloned voice is exactly the trick. Urgency + secrecy + money = stop and verify.' },
              { id: 'b', text: 'Pause and verify before doing anything', next: 's2', isSafe: true, feedback: 'Right — never act on voice alone for money or credentials.' },
            ],
          },
          {
            id: 's2',
            speaker: '🤔 How do you verify?',
            text: 'You want to confirm the request is really from your CEO.',
            choices: [
              { id: 'a', text: 'Call back the number that just called you', next: 'bad1', isSafe: false, feedback: 'The attacker controls that number — they’ll just confirm their own scam.' },
              { id: 'b', text: 'Reach the CEO on a known internal channel and loop in finance/security', next: 'good1', isSafe: true, feedback: 'Exactly — verify out-of-band through a trusted, independent channel.' },
            ],
          },
          { id: 'bad1', speaker: 'Narrator', text: 'The money is gone within minutes to an attacker’s account.', choices: [], outcome: 'compromised' },
          { id: 'good1', speaker: 'Narrator', text: 'You confirm it was a deepfake scam and stop the wire. Crisis averted.', choices: [], outcome: 'safe' },
        ],
      },
    },
    {
      id: 'ch_df_mcq1',
      domainKey: 'ai_deepfakes',
      type: 'mcq',
      xp: 10,
      explanation: 'It’s the combination — pressure to act fast, keep it secret, and move money or credentials — that signals fraud, not the realism of the voice.',
      payload: {
        type: 'mcq',
        prompt: 'Which combination is the biggest red flag of a deepfake voice/video scam?',
        options: [
          { id: 'a', text: 'A friendly, familiar tone' },
          { id: 'b', text: 'Urgency + secrecy + an unusual money or credentials request' },
          { id: 'c', text: 'A scheduled, expected meeting' },
          { id: 'd', text: 'A clear phone connection' },
        ],
        correctOptionId: 'b',
      },
    },
    {
      id: 'ch_df_mcq2',
      domainKey: 'ai_deepfakes',
      type: 'mcq',
      xp: 10,
      explanation: 'Verify through a separate, known-good channel you control — not the channel the request came through.',
      payload: {
        type: 'mcq',
        prompt: 'Best way to verify a suspicious “urgent” request that sounds like your boss?',
        options: [
          { id: 'a', text: 'Trust the voice — it sounds right' },
          { id: 'b', text: 'Call back on the number they just used' },
          { id: 'c', text: 'Verify via a separate known channel (official number, internal chat, in person)' },
          { id: 'd', text: 'Just do it quickly to be safe' },
        ],
        correctOptionId: 'c',
      },
    },
  ],
};
