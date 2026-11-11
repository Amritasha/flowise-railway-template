# Flowise on Railway

[![CI](https://github.com/Amritasha/flowise-railway-template/actions/workflows/ci.yml/badge.svg)](https://github.com/Amritasha/flowise-railway-template/actions/workflows/ci.yml)
[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/template/flowise)

[Flowise](https://flowiseai.com) is an open-source drag-and-drop UI for building LLM-powered agents, RAG pipelines, and AI workflows — a self-hosted alternative to Make.com AI, Zapier AI, and Langchain Cloud.

## What's included

- **Flowise** — the app (port 3000), with SQLite embedded database
- **Persistent volume** — all flows, uploads, and API keys survive restarts

No PostgreSQL or Redis required to get started.

## One-click deploy

Click the **Deploy on Railway** button above.

## Environment variables

| Variable | Description |
|----------|-------------|
| `DATABASE_PATH` | SQLite database. Points at the volume. |
| `SECRETKEY_PATH` | Holds the key that encrypts every saved credential. Losing it makes them unreadable. |
| `APIKEY_PATH`, `LOG_PATH`, `BLOB_STORAGE_PATH` | API keys, logs and uploaded files. All on the volume. |
| `APP_URL` | Public URL, used in invitation and password-reset links. |
| `NUMBER_OF_PROXIES` | `1`, so rate limiting sees real client IPs behind Railway's proxy. |

`FLOWISE_USERNAME` and `FLOWISE_PASSWORD` are **gone**. They did nothing from
Flowise 3.0 onward — authentication moved to real accounts — and this template
no longer sets them.

## First launch

1. Open your Railway public domain.
2. **Create the administrator account immediately.** Flowise 3.x has no default
   login: the first person to reach the URL creates the admin account and owns
   the instance. Do this before sharing the link.
3. Start building from the canvas.

## Data and persistence

A volume is mounted at `/home/node/.flowise` and everything Flowise keeps lives
there: the database, your chatflows, uploaded documents and the encryption key
for saved credentials.

This matters more than it sounds. Flowise runs as the unprivileged `node` user,
so the data directory has to sit under that user's home — `/root/.flowise`,
which earlier versions of this template used, is not writable by it. And a
volume is not optional: without one, the encryption key is regenerated on every
redeploy and every credential you have saved becomes undecryptable.

## Scaling up

**Switch to PostgreSQL** (for larger teams):
```
DATABASE_TYPE=postgres
DATABASE_HOST=...
DATABASE_PORT=5432
DATABASE_NAME=flowise
DATABASE_USER=...
DATABASE_PASSWORD=...
```

**Enable queue mode with Redis** (for high load):
```
MODE=queue
REDIS_URL=${{Redis.REDIS_URL}}
```

**Switch to S3 file storage** (for multi-replica deployments):
```
STORAGE_TYPE=s3
S3_STORAGE_BUCKET_NAME=your-bucket
S3_STORAGE_ACCESS_KEY_ID=...
S3_STORAGE_SECRET_ACCESS_KEY=...
S3_STORAGE_REGION=us-east-1
```

## Upgrading

The image version is pinned in [`Dockerfile`](Dockerfile). A weekly GitHub Actions workflow opens a PR automatically when a new Flowise release is available. Merge and redeploy.

To upgrade manually:
```dockerfile
FROM flowiseai/flowise:3.2.0
```

## License

Flowise is [Apache 2.0](https://github.com/FlowiseAI/Flowise/blob/main/LICENSE). This template is MIT.
