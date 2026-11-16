#!/usr/bin/env bash
# Exports current user and system /etc/cron* schedules into a dated backup directory.

BACKUP_ROOT="${1:-/backup/crons}"
HOST_TAG="$(hostname -s)"
DATE_TAG="$(date +%Y%m%d)"
OUT_DIR="${BACKUP_ROOT}/${HOST_TAG}/${DATE_TAG}"

mkdir -p "$OUT_DIR"
crontab -l > "${OUT_DIR}/user_crontab.bak" 2>/dev/null
cp -a /etc/crontab "${OUT_DIR}/etc_crontab.bak" 2>/dev/null
cp -a /etc/cron.d "${OUT_DIR}/cron.d" 2>/dev/null

echo "Cron schedules backed up to $OUT_DIR"
