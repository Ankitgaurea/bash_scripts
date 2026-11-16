#!/usr/bin/env bash
# Creates a timestamped compressed archive of daily operational/market logs.

SRC_DIR="${1:-/var/log/trading}"
DEST_DIR="${2:-/backup/dumps}"
STAMP="$(date +%Y%m%d_%H%M%S)"

mkdir -p "$DEST_DIR"
ARCHIVE="${DEST_DIR}/data_dump_${STAMP}.tar.gz"

tar -czf "$ARCHIVE" -C "$(dirname "$SRC_DIR")" "$(basename "$SRC_DIR")" &&   sha256sum "$ARCHIVE" > "${ARCHIVE}.sha256" &&   echo "Created archive: $ARCHIVE"
