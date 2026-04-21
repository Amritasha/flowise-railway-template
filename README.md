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

Set these after deployment in the Railway service Variables tab:

| Variable | Required | Description |
|----------|----------|-------------|
| `FLOWISE_USERNAME` | Recommended | Admin login username |
| `FLOWISE_PASSWORD` | Recommended | Admin login password |
| `PORT` | Auto | Set to `3000` (pre-configured) |

All storage paths are pre-configured in `railway.toml` — no need to set them manually.

See [`.env.example`](.env.example) for the full list including PostgreSQL, Redis, S3, and SMTP options.

## First launch

1. Open your Railway public domain
2. Log in with your `FLOWISE_USERNAME` and `FLOWISE_PASSWORD`
3. Start building flows from the canvas

> If you didn't set credentials, Flowise is open with no auth — set them before sharing the URL.

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
