#!/usr/bin/env bash
# Verifies NTP/chrony/PTP clock synchronization across hosts ahead of market open.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

for host in ${MCX_BSE_HOSTS:-10.0.0.1 10.0.0.2}; do
  remote_time=$(sshpass -p "$SSH_PASS_BSE" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no     "${REMOTE_USER:-root}@${host}" "date '+%Y-%m-%d %H:%M:%S %Z' && chronyc tracking 2>/dev/null | grep 'System time'" 2>/dev/null)
  echo "=== $host ==="
  echo "${remote_time:-UNREACHABLE}"
done
