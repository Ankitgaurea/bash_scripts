#!/usr/bin/env bash
# Audits current IRQ bindings and CPU core smp_affinity_list assignments for NICs.

NIC_PREFIX="${1:-eth}"

printf "%-8s %-22s %-18s %s\n" "IRQ" "DEVICE" "AFFINITY_LIST" "TOTAL_INTERRUPTS"
for irq_dir in /proc/irq/[0-9]*; do
  irq=$(basename "$irq_dir")
  dev=$(ls "$irq_dir" 2>/dev/null | grep -E "^${NIC_PREFIX}|mlx|exanic|ens|enp" | head -n 1)
  [ -z "$dev" ] && continue
  aff=$(cat "$irq_dir/smp_affinity_list" 2>/dev/null || echo "N/A")
  total=$(awk -v id="^${irq}:" '$1 ~ id {sum=0; for(i=2;i<=NF-2;i++) sum+=$i; print sum}' /proc/interrupts)
  printf "%-8s %-22s %-18s %s\n" "$irq" "$dev" "$aff" "${total:-0}"
done
