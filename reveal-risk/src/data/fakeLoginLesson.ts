import { Lesson } from './types';

/** Fake Login Pages — a phishing sub-lesson: scenario + URL/credential checks. */
export const FAKE_LOGIN_LESSON: Lesson = {
  id: 'lesson_fakelogin_01',
  domainKey: 'phishing',
  title: 'Fake Login Pages',
  estSeconds: 120,
  challenges: [
    {
      id: 'ch_fl_scenario',
      domainKey: 'phishing',
      type: 'branching_scenario',
      xp: 20,
      explanation:
        'A padlock (HTTPS) only means the connection is encrypted — not that the site is legitimate. Always check the domain, and let a password manager help: it won’t autofill on a look-alike domain.',
      payload: {
        type: 'branching_scenario',
        prompt: 'Make the secure choice at each step.',
        startNodeId: 's1',
        nodes: [
          {
            id: 's1',
            speaker: '🌐 A login page appears',
            text: 'You click a link and a page identical to your Microsoft 365 sign-in asks for your password. The address bar reads: id-microsoft-verify.com',
            choices: [
              { id: 'a', text: 'It looks exactly right — enter your password', next: 'bad1', isSafe: false, feedback: 'The domain isn’t microsoft.com — a perfect-looking page on the wrong domain is the trap.' },
              { id: 'b', text: 'Check the address bar and stop', next: 's2', isSafe: true, feedback: 'Right — the domain is what matters, not how the page looks.' },
            ],
          },
          {
            id: 's2',
            speaker: '🔒 The page shows a padlock',
            text: 'The fake page even has a valid 🔒 HTTPS padlock, which makes it feel safe.',
            choices: [
              { id: 'a', text: 'A padlock means it’s safe — log in', next: 'bad1', isSafe: false, feedback: 'HTTPS only encrypts the connection. Attackers get padlocks too.' },
              { id: 'b', text: 'Close the tab and report it', next: 'good1', isSafe: true, feedback: 'Exactly — encrypted ≠ trustworthy. Report and move on.' },
            ],
          },
          { id: 'bad1', speaker: 'Narrator', text: 'Your credentials are captured and your account is taken over.', choices: [], outcome: 'compromised' },
          { id: 'good1', speaker: 'Narrator', text: 'You avoid the fake page and alert security. Nicely done.', choices: [], outcome: 'safe' },
        ],
      },
    },
    {
      id: 'ch_fl_mcq1',
      domainKey: 'phishing',
      type: 'mcq',
      xp: 10,
      explanation: 'The domain in the address bar is the single most reliable tell — everything else can be faked.',
      payload: {
        type: 'mcq',
        prompt: 'What’s the most reliable sign a login page is fake?',
        options: [
          { id: 'a', text: 'It has a padlock / HTTPS' },
          { id: 'b', text: 'The domain in the address bar doesn’t match the real site' },
          { id: 'c', text: 'The page loads quickly' },
          { id: 'd', text: 'It asks for your password' },
        ],
        correctOptionId: 'b',
      },
    },
    {
      id: 'ch_fl_mcq2',
      domainKey: 'phishing',
      type: 'mcq',
      xp: 10,
      explanation: 'A password manager ties credentials to the exact domain, so it silently refuses to autofill on look-alikes — a great built-in phishing detector.',
      payload: {
        type: 'mcq',
        prompt: 'Your password manager won’t autofill your login on this page. What does that suggest?',
        options: [
          { id: 'a', text: 'The manager is broken' },
          { id: 'b', text: 'The site is likely not the real domain — a red flag' },
          { id: 'c', text: 'You should just type the password manually' },
          { id: 'd', text: 'Nothing — autofill is unreliable' },
        ],
        correctOptionId: 'b',
      },
    },
  ],
};
