#!/usr/bin/env bash
#
# setup-openclaw.sh — install OpenClaw on a fresh Hetzner Cloud VPS
#
# Tested against: Ubuntu 24.04 / Debian 12, run as root on a brand-new server.
# Follows the official guide: https://docs.openclaw.ai/install/hetzner
#
# What it does:
#   1. Updates the OS and installs base packages
#   2. Installs Docker (official get.docker.com script)
#   3. Clones the OpenClaw repo and creates persistent state dirs
#   4. Runs OpenClaw's Docker setup (builds/pulls image, generates gateway
#      token, runs onboarding)
#   5. Locks the box down: UFW allows SSH only — the gateway port (18789)
#      stays loopback-only and is reached via SSH tunnel
#
# Usage (on the VPS, as root):
#   bash setup-openclaw.sh
#
# Optional environment variables:
#   OPENCLAW_USE_PREBUILT=1   # pull ghcr.io/openclaw/openclaw:latest instead of building
#   OPENCLAW_DIR=/opt/openclaw # where to clone the repo (default: /opt/openclaw)

set -euo pipefail

OPENCLAW_DIR="${OPENCLAW_DIR:-/opt/openclaw}"
STATE_DIR="/root/.openclaw"

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
fail() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

[ "$(id -u)" -eq 0 ] || fail "Run this script as root (ssh root@YOUR_VPS_IP)."
command -v apt-get >/dev/null 2>&1 || fail "This script expects Ubuntu or Debian (apt-get not found)."

log "Updating OS packages"
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
apt-get install -y git curl ca-certificates ufw

log "Installing Docker"
if command -v docker >/dev/null 2>&1; then
  echo "Docker already installed: $(docker --version)"
else
  curl -fsSL https://get.docker.com | sh
fi
systemctl enable --now docker

log "Cloning OpenClaw into ${OPENCLAW_DIR}"
if [ -d "${OPENCLAW_DIR}/.git" ]; then
  git -C "${OPENCLAW_DIR}" pull --ff-only
else
  git clone https://github.com/openclaw/openclaw.git "${OPENCLAW_DIR}"
fi

log "Creating persistent state directories"
mkdir -p "${STATE_DIR}/workspace"
# The container runs as the 'node' user (uid/gid 1000)
chown -R 1000:1000 "${STATE_DIR}"

log "Configuring firewall (SSH only — gateway stays loopback-only)"
ufw allow OpenSSH
ufw --force enable
ufw status verbose

log "Running OpenClaw Docker setup (image + gateway token + onboarding)"
cd "${OPENCLAW_DIR}"
if [ "${OPENCLAW_USE_PREBUILT:-0}" = "1" ]; then
  export OPENCLAW_IMAGE="ghcr.io/openclaw/openclaw:latest"
fi
./scripts/docker/setup.sh

log "Starting the gateway"
docker compose up -d openclaw-gateway
docker compose ps

log "Done!"
cat <<'EOF'

OpenClaw is running. The gateway listens on 127.0.0.1:18789 (NOT exposed
to the internet — this is intentional).

To open the dashboard from your laptop:

  1. Start an SSH tunnel (keep it running):
       ssh -N -L 18789:127.0.0.1:18789 root@YOUR_VPS_IP

  2. Get the dashboard URL (includes the gateway token) — run on the VPS:
       cd /opt/openclaw && docker compose run --rm openclaw-cli dashboard --no-open

  3. Open the printed URL in your browser, replacing the host with
     http://127.0.0.1:18789 if needed.

Useful commands (run on the VPS in /opt/openclaw):
  docker compose logs -f openclaw-gateway     # follow logs
  docker compose restart openclaw-gateway     # restart
  docker compose down                         # stop
  git pull && ./scripts/docker/setup.sh       # update OpenClaw

State lives in /root/.openclaw — back it up; it holds your config,
credentials, and conversation state.
EOF
