#!/bin/sh
set -e

DATA_DIR="${DATABASE_PATH:-/home/node/.flowise}"

# Create the directories Flowise expects and hand the whole mount to the user
# that actually runs the app. Harmless when the volume is already correct.
mkdir -p "$DATA_DIR" "$DATA_DIR/logs" "$DATA_DIR/storage"
chown -R node:node "$DATA_DIR" 2>/dev/null || true

# Start the app as the node user.
#
# Note: the published flowiseai/flowise image is NOT built from the Dockerfile
# in the Flowise repo -- that one is for local monorepo builds and ends in
# "pnpm start". The published image contains no pnpm at all; it installs the
# package globally and exposes /usr/local/bin/flowise. So invoke that, and keep
# a pnpm fallback only in case the image layout changes again.
if [ -x /usr/local/bin/flowise ]; then
  echo "[entrypoint] starting Flowise as node"
  exec su-exec node /usr/local/bin/flowise start
fi

PNPM="$(su-exec node sh -lc 'command -v pnpm' 2>/dev/null || true)"
if [ -n "$PNPM" ]; then
  echo "[entrypoint] no flowise binary; falling back to $PNPM start"
  exec su-exec node "$PNPM" start
fi

echo "FATAL: neither /usr/local/bin/flowise nor pnpm found in this image." >&2
ls -la /usr/local/bin 2>/dev/null | head -30 >&2
exit 1
