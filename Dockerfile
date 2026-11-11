# Flowise runs as the unprivileged "node" user (the upstream Dockerfile ends in
# USER node), and everything it persists -- the SQLite database, the encryption
# key that protects saved credentials, uploaded blobs and logs -- lives under
# that user's home at /home/node/.flowise.
#
# A Railway volume mounts root-owned, so the node user cannot create anything
# inside it and Flowise dies on boot with
#   Error: EACCES: permission denied, mkdir '/home/node/.flowise/storage'
# We therefore take ownership of the mount as root at boot, then drop straight
# back to node before starting the app.
FROM flowiseai/flowise:3.1.3

USER root

# busybox's setpriv does not accept --init-groups, so install su-exec rather
# than probing for whatever the base image happens to ship.
RUN apk add --no-cache su-exec

COPY entrypoint.sh /usr/local/bin/flowise-entrypoint.sh
RUN chmod +x /usr/local/bin/flowise-entrypoint.sh

EXPOSE 3000

ENTRYPOINT ["/usr/local/bin/flowise-entrypoint.sh"]
