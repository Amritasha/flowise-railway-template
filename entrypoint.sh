#!/bin/sh
set -e

DATA_DIR="${DATABASE_PATH:-/home/node/.flowise}"

# Create the directories Flowise expects and hand the whole mount to the user
# that actually runs the app. Harmless when the volume is already correct.
mkdir -p "$DATA_DIR" "$DATA_DIR/logs" "$DATA_DIR/storage"
chown -R node:node "$DATA_DIR" 2>/dev/null || true

# su-exec is installed in the image, so this is the normal path. The fallback
# exists only so a base-image change cannot leave the container unable to boot.
if command -v su-exec >/dev/null 2>&1; then
  exec su-exec node pnpm start
elif command -v gosu >/dev/null 2>&1; then
  exec gosu node pnpm start
else
  echo "No privilege-dropping tool found; starting as root." >&2
  exec pnpm start
fi
