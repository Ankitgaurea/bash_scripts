#!/usr/bin/env bash
# Sanitized template reconstructed from chat history (April 22, 2026 design)
# Loads credentials and host lists from ../.env

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

TEMP_THRESHOLD="${TEMP_THRESHOLD:-75}"
DB_HOST="${PG_HOST:-127.0.0.1}"
DB_USER="${PG_USER:-db_user}"
DB_NAME="${PG_NAME:-infra_monitor}"

for host in ${MCX_BSE_HOSTS:-10.0.0.1 10.0.0.2}; do
  raw_output=$(sshpass -p "$SSH_PASS_BSE" ssh -o ConnectTimeout=3 -o StrictHostKeyChecking=no "root@${host}" '
    core_temp=$(sensors 2>/dev/null | awk "/Package id 0:/ {gsub(/[+°C]/,"",\$4); print \$4; exit}")
    exanic_temp=$(exanic-config 2>/dev/null | awk "/Temperature:/ {print \$2; exit}")
    disk_pct=$(df -h / | awk "NR==2 {print \$5}" | sed "s/%//g")
    net_errs=$(ip -s link | awk "/RX:/{getline; print \$3; exit}")
    net_drops=$(ip -s link | awk "/RX:/{getline; print \$4; exit}")
    echo "${core_temp:-0} ${exanic_temp:-0} ${disk_pct:-0} ${net_errs:-0} ${net_drops:-0}"
  ' 2>/dev/null)

  read -r -a metrics <<< "${raw_output:-0 0 0 0 0}"
  core_t="${metrics[0]:-0}"
  exanic_t="${metrics[1]:-0}"
  disk_u="${metrics[2]:-0}"
  rx_err="${metrics[3]:-0}"
  rx_drp="${metrics[4]:-0}"

  if (( $(echo "$core_t > $TEMP_THRESHOLD" | bc -l 2>/dev/null || echo 0) )); then
    echo "[ALERT] $host Core Temp high: ${core_t}C"
  fi

  echo "[$host] Core=${core_t}C ExaNIC=${exanic_t}C Disk=${disk_u}% Err=${rx_err} Drop=${rx_drp}"
done
