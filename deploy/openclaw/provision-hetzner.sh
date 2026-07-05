#!/usr/bin/env bash
#
# provision-hetzner.sh — create an OpenClaw server on Hetzner Cloud via the API.
#
# Talks straight to https://api.hetzner.cloud/v1 with curl + jq (no hcloud CLI
# needed), so it can run from anywhere with HTTPS access — including a Claude
# Code cloud session.
#
# Required environment:
#   HCLOUD_TOKEN      Hetzner Cloud API token (project → Security → API Tokens,
#                     Read & Write). Never commit or paste this into chat.
#
# Optional environment (defaults shown):
#   SERVER_NAME=openclaw
#   SERVER_TYPE=cpx21          # 3 vCPU / 4 GB — comfortable for OpenClaw
#   LOCATION=ash               # Ashburn, VA (US East). EU: fsn1 / nbg1 / hel1
#   IMAGE=ubuntu-24.04
#   SSH_KEY_NAME=              # name of an SSH key already in the project;
#                              # if empty and SSH_PUBKEY is set, it is uploaded
#   SSH_PUBKEY=                # contents of your id_ed25519.pub (used if
#                              # SSH_KEY_NAME doesn't exist yet)
#   ALLOW_SSH_FROM=0.0.0.0/0,::/0   # comma-separated CIDRs for the firewall
#   USER_DATA_FILE=deploy/openclaw/cloud-init-full.yaml
#
# Usage:
#   HCLOUD_TOKEN=... SSH_KEY_NAME=my-key bash deploy/openclaw/provision-hetzner.sh

set -euo pipefail

API="https://api.hetzner.cloud/v1"
SERVER_NAME="${SERVER_NAME:-openclaw}"
SERVER_TYPE="${SERVER_TYPE:-cpx21}"
LOCATION="${LOCATION:-ash}"
IMAGE="${IMAGE:-ubuntu-24.04}"
SSH_KEY_NAME="${SSH_KEY_NAME:-}"
SSH_PUBKEY="${SSH_PUBKEY:-}"
ALLOW_SSH_FROM="${ALLOW_SSH_FROM:-0.0.0.0/0,::/0}"
USER_DATA_FILE="${USER_DATA_FILE:-$(dirname "$0")/cloud-init-full.yaml}"
FIREWALL_NAME="${FIREWALL_NAME:-openclaw-ssh-only}"

log()  { printf '\n\033[1;36m==> %s\033[0m\n' "$*"; }
fail() { printf '\n\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

[ -n "${HCLOUD_TOKEN:-}" ] || fail "HCLOUD_TOKEN is not set."
command -v jq >/dev/null || fail "jq is required."
[ -f "$USER_DATA_FILE" ] || fail "user-data file not found: $USER_DATA_FILE"

hz() { # hz METHOD PATH [JSON_BODY]
  local method="$1" path="$2" body="${3:-}"
  local args=(-sS --fail-with-body -X "$method" \
    -H "Authorization: Bearer $HCLOUD_TOKEN" \
    -H "Content-Type: application/json" \
    "$API$path")
  [ -n "$body" ] && args+=(-d "$body")
  curl "${args[@]}"
}

log "Checking API access"
hz GET "/locations" | jq -r --arg loc "$LOCATION" \
  '.locations[] | select(.name==$loc) | "Location OK: \(.name) (\(.city))"' \
  | grep . || fail "Location '$LOCATION' not found or token invalid."

log "Resolving SSH key"
SSH_KEY_ID=""
if [ -n "$SSH_KEY_NAME" ]; then
  SSH_KEY_ID=$(hz GET "/ssh_keys?name=$SSH_KEY_NAME" | jq -r '.ssh_keys[0].id // empty')
fi
if [ -z "$SSH_KEY_ID" ] && [ -n "$SSH_PUBKEY" ]; then
  log "Uploading SSH public key as '${SSH_KEY_NAME:-openclaw-key}'"
  SSH_KEY_ID=$(hz POST "/ssh_keys" "$(jq -n \
    --arg name "${SSH_KEY_NAME:-openclaw-key}" --arg pk "$SSH_PUBKEY" \
    '{name:$name, public_key:$pk}')" | jq -r '.ssh_key.id')
fi
[ -n "$SSH_KEY_ID" ] || fail "No SSH key. Set SSH_KEY_NAME (existing key) or SSH_PUBKEY (to upload)."
echo "SSH key id: $SSH_KEY_ID"

log "Ensuring firewall '$FIREWALL_NAME' (inbound SSH only)"
FIREWALL_ID=$(hz GET "/firewalls?name=$FIREWALL_NAME" | jq -r '.firewalls[0].id // empty')
if [ -z "$FIREWALL_ID" ]; then
  SRC_IPS=$(printf '%s' "$ALLOW_SSH_FROM" | jq -R 'split(",")')
  FIREWALL_ID=$(hz POST "/firewalls" "$(jq -n \
    --arg name "$FIREWALL_NAME" --argjson ips "$SRC_IPS" \
    '{name:$name, rules:[{direction:"in", protocol:"tcp", port:"22", source_ips:$ips}]}')" \
    | jq -r '.firewall.id')
fi
echo "Firewall id: $FIREWALL_ID"

log "Creating server '$SERVER_NAME' ($SERVER_TYPE, $IMAGE, $LOCATION)"
EXISTING=$(hz GET "/servers?name=$SERVER_NAME" | jq -r '.servers[0].id // empty')
[ -z "$EXISTING" ] || fail "A server named '$SERVER_NAME' already exists (id $EXISTING). Pick another SERVER_NAME or delete it first."

CREATE_RESP=$(hz POST "/servers" "$(jq -n \
  --arg name "$SERVER_NAME" --arg type "$SERVER_TYPE" --arg image "$IMAGE" \
  --arg loc "$LOCATION" --arg ud "$(cat "$USER_DATA_FILE")" \
  --argjson key "$SSH_KEY_ID" --argjson fw "$FIREWALL_ID" \
  '{name:$name, server_type:$type, image:$image, location:$loc,
    ssh_keys:[$key], firewalls:[{firewall:$fw}], user_data:$ud,
    labels:{app:"openclaw"}}')")
SERVER_ID=$(echo "$CREATE_RESP" | jq -r '.server.id')
SERVER_IP=$(echo "$CREATE_RESP" | jq -r '.server.public_net.ipv4.ip')
echo "Server id: $SERVER_ID  IP: $SERVER_IP"

log "Waiting for server to be running"
for _ in $(seq 1 30); do
  STATUS=$(hz GET "/servers/$SERVER_ID" | jq -r '.server.status')
  echo "  status: $STATUS"
  [ "$STATUS" = "running" ] && break
  sleep 5
done
[ "$STATUS" = "running" ] || fail "Server did not reach 'running' state."

log "Done!"
cat <<EOF

Server '$SERVER_NAME' is up at $SERVER_IP. cloud-init is now installing
OpenClaw in the background (takes ~3-5 minutes).

Next steps from your laptop:

  # 1. Watch bootstrap finish (optional)
  ssh root@$SERVER_IP tail -f /var/log/cloud-init-output.log

  # 2. Get the tokenized dashboard URL
  ssh root@$SERVER_IP cat /root/openclaw-dashboard.txt

  # 3. Tunnel and open the dashboard to finish setup (LLM key, channels)
  ssh -N -L 18789:127.0.0.1:18789 root@$SERVER_IP

Monthly cost: check https://console.hetzner.cloud — delete the server there
(or via the API) if you want to tear it down.
EOF
