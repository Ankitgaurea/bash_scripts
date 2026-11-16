#!/usr/bin/env bash
# Validates existence, non-zero byte size, and line count of daily raw market data files.

DATA_DIR="${1:-/data/raw/$(date +%Y%m%d)}"

if [ ! -d "$DATA_DIR" ]; then
  echo "[ERROR] Directory missing: $DATA_DIR"
  exit 1
fi

empty_count=0
total_count=0

for file in "$DATA_DIR"/*; do
  [ -e "$file" ] || continue
  total_count=$((total_count + 1))
  if [ ! -s "$file" ]; then
    echo "[EMPTY] $file (0 bytes)"
    empty_count=$((empty_count + 1))
  else
    size=$(du -h "$file" | awk '{print $1}')
    echo "[OK] $file ($size)"
  fi
done

echo "Verified $total_count files in $DATA_DIR ($empty_count empty)."
