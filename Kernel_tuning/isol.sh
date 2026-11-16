#!/usr/bin/env bash
# Audits kernel boot parameters, isolated CPU cores, and nohz_full / rcu_nocbs status.

echo "=== Kernel Command Line ==="
cat /proc/cmdline

echo -e "\n=== Isolated CPUs ==="
cat /sys/devices/system/cpu/isolated 2>/dev/null || echo "None"

echo -e "\n=== Tickless (nohz_full) CPUs ==="
cat /sys/devices/system/cpu/nohz_full 2>/dev/null || echo "None"

echo -e "\n=== Tasks currently scheduled on isolated cores ==="
ISOL_LIST=$(cat /sys/devices/system/cpu/isolated 2>/dev/null)
if [ -n "$ISOL_LIST" ]; then
  ps -eLo psr,pid,comm | awk -v cores="$ISOL_LIST" '$1 ~ /^[0-9]+$/ {print}' | head -n 25
fi
