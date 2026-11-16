#!/usr/bin/env bash
# Distributes NIC RX/TX IRQ queues across dedicated housekeeping/network CPU cores.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

NIC_NAME="${1:?Usage: $0 <nic_name>}"
IFS=',' read -r -a TARGET_CORES <<< "${IRQ_CORES:-2,3,4,5}"

mapfile -t irqs < <(grep "$NIC_NAME" /proc/interrupts | awk -F: '{print $1}' | tr -d ' ')
if [ "${#irqs[@]}" -eq 0 ]; then
  echo "No IRQs found for interface $NIC_NAME"
  exit 1
fi

count=${#TARGET_CORES[@]}
for idx in "${!irqs[@]}"; do
  irq="${irqs[$idx]}"
  core="${TARGET_CORES[$((idx % count))]}"
  echo "$core" > "/proc/irq/${irq}/smp_affinity_list" &&     echo "Pinned IRQ $irq ($NIC_NAME queue $idx) -> CPU $core"
done
