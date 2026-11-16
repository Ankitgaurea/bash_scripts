#!/usr/bin/env bash
# Continuous reachability monitor for MCX hosts logging RUNNING/UNREACHABLE states.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

: > output.txt
: > output_mcx_server

while true; do
  for ip in ${MCX_HOSTS:-10.0.0.1 10.0.0.2}; do
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    if ping -c 1 -W 1 "$ip" > /dev/null 2>&1; then
      echo "[$ts] $ip - RUNNING" | tee -a output.txt output_mcx_server
    else
      echo "[$ts] $ip - UNREACHABLE" | tee -a output.txt output_mcx_server
    fi
  done
  sleep 5
done
