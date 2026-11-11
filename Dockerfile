# Flowise runs as the unprivileged "node" user (see the upstream Dockerfile's
# USER node), whose home is /home/node. Everything Flowise persists -- the
# SQLite database, the encryption key for saved credentials, uploaded blobs and
# logs -- goes under that home directory, which is why the Railway volume is
# mounted at /home/node/.flowise rather than /root/.flowise.
FROM flowiseai/flowise:3.1.4
