#!/usr/bin/env bash
# Continuous SSH loop checking mount-point disk usage across MKT_LIST targets.
# Hardened with tr -d '\r' against Windows CRLF line endings.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

MKT_LIST="${MKT_LIST:-$SCRIPT_DIR/mkt_hosts.txt}"
THRESHOLD="${DISK_THRESHOLD:-85}"

if [ ! -f "$MKT_LIST" ]; then
  echo "Host list not found: $MKT_LIST"
  exit 1
fi

while true; do
  while IFS= read -r raw_host; do
    host=$(printf '%s' "$raw_host" | tr -d '\r' | xargs)
    [[ -z "$host" || "$host" == \#* ]] && continue

    usage=$(sshpass -p "$SSH_PASS_MKT" ssh -n -o ConnectTimeout=3 -o StrictHostKeyChecking=no       "${REMOTE_USER:-root}@${host}" "df -h /mnt 2>/dev/null | awk 'NR==2 {print \$5}' | tr -d '%\r'")

    if [[ -n "$usage" && "$usage" -ge "$THRESHOLD" ]]; then
      echo "[$(date '+%F %T')] ALERT: $host /mnt usage at ${usage}%"
    else
      echo "[$(date '+%F %T')] OK: $host /mnt usage at ${usage:-N/A}%"
    fi
  done < "$MKT_LIST"
  sleep 30
done
