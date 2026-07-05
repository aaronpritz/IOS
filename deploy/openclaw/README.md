# OpenClaw on Hetzner Cloud

A minimal, security-first deployment kit for running [OpenClaw](https://openclaw.ai)
(the open-source personal AI assistant, formerly Clawdbot/Moltbot) on a Hetzner
Cloud VPS.

**What's in this folder**

| File | Purpose |
|---|---|
| `setup-openclaw.sh` | One-shot install script — run on the fresh VPS as root |
| `cloud-init.yaml` | Optional Hetzner user-data that pre-installs Docker + clones the repo at first boot |

Based on the official guide: <https://docs.openclaw.ai/install/hetzner>

---

## 1. Create the server

In the [Hetzner Cloud Console](https://console.hetzner.cloud):

1. **Add your SSH key** first: *Security → SSH Keys → Add SSH Key* (paste your
   `~/.ssh/id_ed25519.pub`). Password login should never be used.
2. *Servers → Add Server*:
   - **Location**: whichever is closest to you (e.g. Ashburn/Hillsboro for US)
   - **Image**: Ubuntu 24.04
   - **Type**: a shared-vCPU instance with **4 GB RAM** (e.g. CX22/CPX21) is
     the comfortable choice; 2 GB works for light personal use
   - **SSH key**: select the key you added
   - **Cloud config** (optional): paste the contents of `cloud-init.yaml` to
     pre-install Docker and clone the repo automatically
3. (Recommended) Add a **Hetzner Cloud Firewall**: allow inbound TCP 22 (ideally
   from your IP only) and nothing else. Do **not** add a rule for 18789 — the
   OpenClaw gateway must not be reachable from the internet.

## 2. Install OpenClaw

Copy the script up and run it:

```bash
scp deploy/openclaw/setup-openclaw.sh root@YOUR_VPS_IP:/root/
ssh root@YOUR_VPS_IP bash /root/setup-openclaw.sh
```

(If you used `cloud-init.yaml`, the script detects the existing Docker install
and repo clone and skips those steps.)

The script:

- updates the OS and installs Docker
- clones `openclaw/openclaw` into `/opt/openclaw`
- creates persistent state in `/root/.openclaw` (owned by uid 1000, the
  container's `node` user)
- enables UFW with **SSH only** — the gateway binds to `127.0.0.1:18789`
- runs OpenClaw's `scripts/docker/setup.sh`, which builds/pulls the image,
  generates a gateway token into `.env`, and runs onboarding

During onboarding you'll be asked for an LLM API key (Anthropic recommended)
and which channels to connect (WhatsApp, Telegram, etc.).

To use the prebuilt image instead of building locally (faster on small VPSes):

```bash
ssh root@YOUR_VPS_IP OPENCLAW_USE_PREBUILT=1 bash /root/setup-openclaw.sh
```

## 3. Access the dashboard (SSH tunnel)

The gateway is deliberately loopback-only. From your laptop:

```bash
ssh -N -L 18789:127.0.0.1:18789 root@YOUR_VPS_IP
```

Then get the tokenized dashboard URL (run on the VPS):

```bash
cd /opt/openclaw && docker compose run --rm openclaw-cli dashboard --no-open
```

Open the printed URL in your browser while the tunnel is running. For a
tunnel-free experience, install [Tailscale](https://tailscale.com) on the VPS
and your devices and bind the gateway to the tailnet interface instead.

## 4. Day-2 operations

Run these in `/opt/openclaw` on the VPS:

```bash
docker compose logs -f openclaw-gateway   # follow logs
docker compose restart openclaw-gateway   # restart
docker compose down                       # stop
git pull && ./scripts/docker/setup.sh     # update to latest
```

**Back up `/root/.openclaw`** — it contains your config, tokens, channel
credentials, and memory. A simple nightly cron works:

```bash
tar czf /root/openclaw-backup-$(date +%F).tar.gz -C /root .openclaw
```

Hetzner's built-in server backups (20% of server price) are an easy belt-and-
suspenders addition.

## Security checklist

- [ ] SSH key auth only (`PasswordAuthentication no` in `/etc/ssh/sshd_config`)
- [ ] Hetzner Cloud Firewall + UFW: inbound TCP 22 only
- [ ] Gateway bound to `127.0.0.1` (default in this setup) — never `0.0.0.0`
- [ ] Gateway token kept secret (it's in `/opt/openclaw/.env`)
- [ ] LLM API keys only ever entered on the VPS, not committed to git
- [ ] Regular backups of `/root/.openclaw`
