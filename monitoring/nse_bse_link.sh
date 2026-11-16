#!/usr/bin/env bash
# Checks network interface carrier state and exchange gateway reachability for NSE/BSE links.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

NSE_IFACE="${NSE_IFACE:-eth1}"
BSE_IFACE="${BSE_IFACE:-eth2}"
NSE_GW="${NSE_GATEWAY:-10.0.1.1}"
BSE_GW="${BSE_GATEWAY:-10.0.2.1}"

check_link() {
  local label="$1" iface="$2" gw="$3"
  local state
  state=$(cat "/sys/class/net/${iface}/operstate" 2>/dev/null || echo "missing")
  if [ "$state" = "up" ] && ping -I "$iface" -c 1 -W 1 "$gw" >/dev/null 2>&1; then
    echo "[$(date '+%F %T')] $label ($iface -> $gw): UP"
  else
    echo "[$(date '+%F %T')] $label ($iface -> $gw): DOWN (operstate=$state)"
  fi
}

check_link "NSE" "$NSE_IFACE" "$NSE_GW"
check_link "BSE" "$BSE_IFACE" "$BSE_GW"
