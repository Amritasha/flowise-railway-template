#!/bin/sh
set -e

DATA_DIR="${DATABASE_PATH:-/home/node/.flowise}"

# Create the directories Flowise expects and hand the whole mount to the user
# that actually runs the app. Harmless when the volume is already correct.
mkdir -p "$DATA_DIR" "$DATA_DIR/logs" "$DATA_DIR/storage"
chown -R node:node "$DATA_DIR" 2>/dev/null || true

# pnpm is installed globally with npm, so resolve it to an absolute path here:
# su-exec execs directly without a shell, and inherits root's PATH rather than
# the node user's, so a bare "pnpm" fails with "No such file or directory".
PNPM="$(command -v pnpm || echo /usr/local/bin/pnpm)"

if [ ! -x "$PNPM" ]; then
  echo "FATAL: pnpm not found at $PNPM" >&2
  exit 1
fi

# su-exec is installed in the image, so this is the normal path. The fallback
# exists only so a base-image change cannot leave the container unable to boot.
if command -v su-exec >/dev/null 2>&1; then
  exec su-exec node "$PNPM" start
elif command -v gosu >/dev/null 2>&1; then
  exec gosu node "$PNPM" start
else
  echo "No privilege-dropping tool found; starting as root." >&2
  exec "$PNPM" start
fi
