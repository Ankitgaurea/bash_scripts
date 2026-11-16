#!/usr/bin/env bash
# Audits and sets rp_filter and force_igmp_version for multicast market-data interfaces.

MODE="${1:-audit}" # audit | apply
TARGET_RP="${TARGET_RP_FILTER:-2}"
TARGET_IGMP="${TARGET_IGMP_VERSION:-2}"

if [ "$MODE" = "apply" ]; then
  sysctl -w "net.ipv4.conf.all.rp_filter=${TARGET_RP}"
  sysctl -w "net.ipv4.conf.default.rp_filter=${TARGET_RP}"
  sysctl -w "net.ipv4.conf.all.force_igmp_version=${TARGET_IGMP}"
  sysctl -w "net.ipv4.conf.default.force_igmp_version=${TARGET_IGMP}"
fi

echo "=== Current rp_filter & IGMP Settings ==="
sysctl -a 2>/dev/null | grep -E "rp_filter|force_igmp_version" | sort
