#!/usr/bin/env bash
# Synchronizes operational script directories to a central backup server using rsync.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
[ -f "$SCRIPT_DIR/../.env" ] && source "$SCRIPT_DIR/../.env"

LOCAL_SCRIPTS_DIR="${LOCAL_SCRIPTS_DIR:-/opt/scripts/}"
BACKUP_HOST="${BACKUP_HOST:-10.0.0.10}"
BACKUP_DIR="${BACKUP_DIR:-/backup/scripts/$(hostname -s)/}"

sshpass -p "$SSH_PASS_MKT" rsync -avz --delete   -e "ssh -o StrictHostKeyChecking=no"   "$LOCAL_SCRIPTS_DIR" "${REMOTE_USER:-root}@${BACKUP_HOST}:${BACKUP_DIR}"
