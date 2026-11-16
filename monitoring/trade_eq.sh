#!/usr/bin/env bash
# Verifies equity trading engine processes and active TCP session readiness.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

PROC_PATTERN="${TRADE_EQ_PROC:-trade_eq}"
EXPECTED_PORT="${TRADE_EQ_PORT:-9001}"

pids=$(pgrep -f "$PROC_PATTERN")
if [ -n "$pids" ]; then
  conns=$(ss -tn state established "( sport = :$EXPECTED_PORT or dport = :$EXPECTED_PORT )" | tail -n +2 | wc -l)
  echo "[$(date '+%F %T')] RUNNING: $PROC_PATTERN (PIDs: $pids) | Active sessions: $conns"
else
  echo "[$(date '+%F %T')] CRITICAL: $PROC_PATTERN is NOT running!"
  exit 1
fi
