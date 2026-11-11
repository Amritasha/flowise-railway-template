#!/bin/sh
set -e

DATA_DIR="${DATABASE_PATH:-/home/node/.flowise}"

# Create the directories Flowise expects and hand the whole mount to the user
# that actually runs the app. Harmless when the volume is already correct.
mkdir -p "$DATA_DIR" "$DATA_DIR/logs" "$DATA_DIR/storage"
chown -R node:node "$DATA_DIR" 2>/dev/null || true

# Drop privileges with whatever this image provides, rather than assuming one
# tool exists. Running as root is the last resort: a working Flowise with the
# wrong uid beats a container that will not start.
if command -v su-exec >/dev/null 2>&1; then
  exec su-exec node pnpm start
elif command -v gosu >/dev/null 2>&1; then
  exec gosu node pnpm start
elif command -v setpriv >/dev/null 2>&1; then
  exec setpriv --reuid=node --regid=node --init-groups pnpm start
elif command -v su >/dev/null 2>&1; then
  exec su node -s /bin/sh -c 'pnpm start'
else
  echo "No privilege-dropping tool found; starting as root." >&2
  exec pnpm start
fi
