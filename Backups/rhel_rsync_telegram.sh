#!/usr/bin/env bash
# RHEL rsync transfer with MD5 checksum verification and Telegram Bot API alerts.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

SRC_FILE="${1:?Usage: $0 <source_file> <remote_host> <remote_dir>}"
REMOTE_HOST="${2:?Missing remote host}"
REMOTE_DIR="${3:?Missing remote directory}"

send_telegram() {
  curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    -d chat_id="${TELEGRAM_CHAT_ID}" \
    -d text="$1" > /dev/null
}

LOCAL_MD5=$(md5sum "$SRC_FILE" | awk '{print $1}')
sshpass -p "$SSH_PASS_MKT" rsync -avzh "$SRC_FILE" "${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_DIR}/"
REMOTE_MD5=$(sshpass -p "$SSH_PASS_MKT" ssh -o StrictHostKeyChecking=no "${REMOTE_USER}@${REMOTE_HOST}" "md5sum ${REMOTE_DIR}/$(basename "$SRC_FILE") | awk '{print \$1}'")

if [ "$LOCAL_MD5" = "$REMOTE_MD5" ]; then
  send_telegram "Sync verified for $(basename "$SRC_FILE") on $REMOTE_HOST"
else
  send_telegram "MD5 mismatch for $(basename "$SRC_FILE") on $REMOTE_HOST"
  exit 1
fi
