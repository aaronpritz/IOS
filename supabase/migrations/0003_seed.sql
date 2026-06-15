-- Seed: threat domains, badges, and the starter Phishing lesson.
-- Challenge payloads mirror reveal-risk/src/data/types.ts exactly.

insert into threat_domains (key, name, icon, color, sort_order) values
  ('phishing',     'Phishing',           '🎣', '#12B886', 1),
  ('passwords',    'Passwords',          '🔑', '#4C6EF5', 2),
  ('social_eng',   'Social Engineering', '🎭', '#F59F00', 3),
  ('data_handling','Data Handling',      '🗂️', '#22B8CF', 4),
  ('physical',     'Physical',           '🚪', '#163058', 5),
  ('ai_deepfakes', 'AI & Deepfakes',     '🤖', '#FF4D6D', 6);

insert into badges (key, name, description, icon, criteria) values
  ('first_steps', 'First Steps', 'Completed your first lesson', '🛡️', '{"lessons":1}'),
  ('streak_3',    '3-Day Streak', 'Practiced 3 days in a row', '🔥', '{"streak":3}'),
  ('streak_7',    '7-Day Streak', 'Practiced 7 days in a row', '🔥', '{"streak":7}'),
  ('streak_14',   '14-Day Streak','Practiced 14 days in a row','🔥', '{"streak":14}'),
  ('streak_30',   '30-Day Streak','Practiced 30 days in a row','🏆', '{"streak":30}');

-- Phishing unit + lesson
with u as (
  insert into units (domain_key, title, sort_order) values ('phishing', 'Phishing Basics', 1)
  returning id
), l as (
  insert into lessons (unit_id, title, sort_order, xp_reward, est_seconds)
  select id, 'Spot the Phish', 1, 25, 120 from u
  returning id
)
insert into challenges (lesson_id, domain_key, type, ordinal, xp, explanation, payload)
select l.id, 'phishing', 'spot_the_phish', 1, 15,
  'Red flags: a look-alike sender domain, manufactured urgency, a generic greeting, and a link whose real destination differs from its text.',
  '{
    "type": "spot_the_phish",
    "prompt": "Tap every red flag you can find in this email, then press Check.",
    "email": {
      "senderName": "Microsoft 365 Security",
      "date": "Today, 8:14 AM",
      "hotspots": [
        {"id":"sender","zone":"sender","text":"IT-Support@micros0ft-secure.com","isRedFlag":true,"rationale":"Look-alike domain with a zero in micros0ft."},
        {"id":"subject","zone":"subject","text":"URGENT: Your account will be DEACTIVATED in 24 hours","isRedFlag":true,"rationale":"Manufactured urgency pressures you to act before thinking."},
        {"id":"greeting","zone":"greeting","text":"Dear Valued User,","isRedFlag":true,"rationale":"Generic greeting suggests a mass-sent phish."},
        {"id":"link","zone":"link","text":"Verify My Account  →  http://account-verify.micros0ft-secure.ru/login","isRedFlag":true,"rationale":"Link text and real URL differ; suspicious .ru domain."}
      ]
    }
  }'::jsonb
from l
union all
select l.id, 'social_eng', 'branching_scenario', 2, 20,
  'Vishing relies on urgency and authority. Never share codes; verify via a channel you initiate.',
  '{
    "type":"branching_scenario",
    "prompt":"Play it out — make the secure choice at each step.",
    "startNodeId":"s1",
    "nodes":[
      {"id":"s1","speaker":"Incoming call — IT Help Desk","text":"Confirm the 6-digit code we just texted you.","choices":[
        {"id":"a","text":"Read them the code","next":"bad1","isSafe":false,"feedback":"Never share an MFA code."},
        {"id":"b","text":"Decline; call IT on the official number","next":"good1","isSafe":true,"feedback":"Verify through a channel you initiate."}
      ]},
      {"id":"bad1","speaker":"Narrator","text":"The attacker uses your code to take over the account.","choices":[],"outcome":"compromised"},
      {"id":"good1","speaker":"Narrator","text":"You report it; your account stays safe.","choices":[],"outcome":"safe"}
    ]
  }'::jsonb
from l
union all
select l.id, 'phishing', 'mcq', 3, 10,
  'Go to the site yourself via a known-good bookmark — never the email link.',
  '{"type":"mcq","prompt":"An email says verify within 1 hour or be locked out. Safest first move?","options":[{"id":"a","text":"Click the link quickly"},{"id":"b","text":"Open the site via a saved bookmark"},{"id":"c","text":"Reply asking if it is real"},{"id":"d","text":"Forward to coworkers"}],"correctOptionId":"b"}'::jsonb
from l
union all
select l.id, 'phishing', 'mcq', 4, 10,
  'Use Report Phishing so security can protect everyone.',
  '{"type":"mcq","prompt":"You are sure an email is phishing. Best action?","options":[{"id":"a","text":"Delete and move on"},{"id":"b","text":"Unsubscribe"},{"id":"c","text":"Use the Report Phishing button"},{"id":"d","text":"Open the attachment to confirm"}],"correctOptionId":"c"}'::jsonb
from l;
