#!/bin/sh
set -e

DATA_DIR="${DATABASE_PATH:-/home/node/.flowise}"

# Create the directories Flowise expects and hand the whole mount to the user
# that actually runs the app. Harmless when the volume is already correct.
mkdir -p "$DATA_DIR" "$DATA_DIR/logs" "$DATA_DIR/storage"
chown -R node:node "$DATA_DIR" 2>/dev/null || true

# Locate pnpm. su-exec execs without a shell and inherits root's PATH, so a
# bare "pnpm" can fail even though the image has it. Ask the node user's own
# login shell first -- that is the environment the image was built for.
PNPM="$(su-exec node sh -lc 'command -v pnpm' 2>/dev/null || true)"
[ -n "$PNPM" ] || PNPM="$(command -v pnpm 2>/dev/null || true)"
for c in /usr/local/bin/pnpm /usr/bin/pnpm /home/node/.local/share/pnpm/pnpm; do
  [ -n "$PNPM" ] && break
  [ -x "$c" ] && PNPM="$c"
done

if [ -z "$PNPM" ]; then
  echo "FATAL: could not locate pnpm. Searched the node user's PATH and:" >&2
  ls -la /usr/local/bin 2>/dev/null | head -40 >&2
  echo "--- node user PATH ---" >&2
  su-exec node sh -lc 'echo $PATH' >&2 || true
  exit 1
fi

echo "[entrypoint] starting Flowise as node via $PNPM"
exec su-exec node "$PNPM" start
