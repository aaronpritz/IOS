import { Lesson } from './types';

/**
 * Passwords domain lesson — leads with the interactive password-strength
 * challenge, then a quick MFA knowledge check.
 */
export const PASSWORDS_LESSON: Lesson = {
  id: 'lesson_pw_01',
  domainKey: 'passwords',
  title: 'Strong Passwords',
  estSeconds: 120,
  challenges: [
    {
      id: 'ch_pw_strength',
      domainKey: 'passwords',
      type: 'password_strength',
      xp: 15,
      explanation:
        'Length beats complexity: a long, unique passphrase is far harder to crack than a short password with a few symbols. Reusing passwords is the #1 way one breach becomes many.',
      payload: {
        type: 'password_strength',
        prompt: 'Turn this weak password into a strong one — apply fixes until the meter hits Strong.',
        base: 'Summer2024!',
        threshold: 80,
        fixes: [
          {
            id: 'length',
            label: 'Make it long (16+ characters)',
            points: 35,
            rationale: 'Length is the single biggest factor — each extra character multiplies the time to crack it.',
          },
          {
            id: 'passphrase',
            label: 'Use a random passphrase, not a season + year',
            points: 30,
            rationale: '“Summer2024!” follows a predictable pattern attackers try first. Random words defeat that.',
          },
          {
            id: 'unique',
            label: 'Make it unique to this account',
            points: 20,
            rationale: 'Reused passwords let one leaked site compromise all your accounts (credential stuffing).',
          },
          {
            id: 'manager',
            label: 'Store it in a password manager',
            points: 15,
            rationale: 'A manager lets every account have a long, unique password you never have to remember.',
          },
        ],
      },
    },
    {
      id: 'ch_pw_mcq1',
      domainKey: 'passwords',
      type: 'mcq',
      xp: 10,
      explanation:
        'MFA blocks the vast majority of account-takeover attacks even when your password is stolen — an authenticator app or passkey is stronger than SMS.',
      payload: {
        type: 'mcq',
        prompt: 'Your password may have leaked in a breach. What’s the most protective next step?',
        options: [
          { id: 'a', text: 'Add a “1” to the end of the old password' },
          { id: 'b', text: 'Set a new unique password AND turn on MFA' },
          { id: 'c', text: 'Use the same password but on a different site' },
          { id: 'd', text: 'Wait and see if anything happens' },
        ],
        correctOptionId: 'b',
      },
    },
  ],
};
