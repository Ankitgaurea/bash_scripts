#!/usr/bin/env bash
# Offloads movable system IRQs away from isolated trading cores onto housekeeping CPUs.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

HOUSEKEEPING_CORES="${HOUSEKEEPING_CORES:-0-1}"

echo "Shifting default and movable IRQs to housekeeping cores: $HOUSEKEEPING_CORES"
echo "$HOUSEKEEPING_CORES" > /proc/irq/default_smp_affinity 2>/dev/null

for irq_dir in /proc/irq/[0-9]*; do
  irq=$(basename "$irq_dir")
  if [ -w "$irq_dir/smp_affinity_list" ]; then
    echo "$HOUSEKEEPING_CORES" > "$irq_dir/smp_affinity_list" 2>/dev/null &&       echo "Moved IRQ $irq -> $HOUSEKEEPING_CORES"
  fi
done
