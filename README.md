# Coolify Skill for Claude Code

[![Install Claude Code Skill](https://img.shields.io/badge/Claude_Code-Install_Skill-blue?style=for-the-badge&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IndoaXRlIiBzdHJva2Utd2lkdGg9IjIiPjxwYXRoIGQ9Ik0xMiAydjIwTTIgMTJoMjAiLz48L3N2Zz4=)](#install)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENSE)
[![Coolify](https://img.shields.io/badge/Coolify-v4-6C47FF?style=flat-square&logo=data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJ3aGl0ZSI+PGNpcmNsZSBjeD0iMTIiIGN5PSIxMiIgcj0iMTAiLz48L3N2Zz4=)](https://coolify.io)
[![API Endpoints](https://img.shields.io/badge/API_Endpoints-80+-orange?style=flat-square)](#api-coverage)

Manage your entire [Coolify](https://coolify.io) infrastructure from [Claude Code](https://claude.com/claude-code). Deploy apps, control databases, manage services, handle environment variables, and troubleshoot — all through natural language.

---

## Install

### One-liner (recommended)

```bash
git clone https://github.com/danielhjermitslev/coolify-skill.git ~/.claude/skills/coolify
```

### Manual

Download this repo and drop the folder into `~/.claude/skills/coolify`. That's it — Claude Code auto-discovers skills on next session start.

---

## Setup

Two environment variables are needed for API access:

```bash
export COOLIFY_API_URL="https://coolify.example.com"
export COOLIFY_API_TOKEN="your-bearer-token-here"
```

> **Get your token:** Coolify Dashboard → **Keys & Tokens** → **API tokens** → Create with `*` permission for full access.

---

## What It Does

This skill gives Claude Code deep knowledge of Coolify's API, architecture, and operations:

| Capability | Examples |
|---|---|
| **Deploy & control** | Start, stop, restart applications, databases, and services |
| **Create resources** | Spin up apps from Git repos, Docker images, Dockerfiles, or Compose |
| **Environment vars** | List, set, bulk-update, and delete env vars |
| **Monitor** | Deployment status, application logs, resource overview |
| **Database ops** | Create 8 DB types, configure automated S3 backups |
| **Server management** | Multi-server architecture, proxy config, Cloudflare tunnels |
| **Troubleshoot** | Diagnose 502s, SSL issues, connection problems, stuck services |

### Just Talk Naturally

```
"List all my Coolify applications"
"Deploy the app with UUID abc123"
"Restart the PostgreSQL database"
"Set NODE_ENV to production on my-app"
"What's running on my Hetzner server?"
"Create a new Redis database in staging"
"Show me the deployment logs"
"Why am I getting a 502 on my app?"
```

---

## What's Included

```
coolify-skill/
├── SKILL.md                              # Core skill — auto-loaded on trigger
├── references/
│   ├── api-endpoints.md                  # Complete API reference (80+ endpoints)
│   └── server-management.md             # Servers, proxies, tunnels, backups, troubleshooting
└── scripts/
    └── coolify-api.sh                    # Standalone CLI helper script
```

The skill uses **progressive disclosure** — only loads what's needed:

1. **Always in context** — name + description for trigger matching (~100 words)
2. **On trigger** — SKILL.md with core workflows and API patterns
3. **On demand** — reference files when deeper detail is needed

---

## API Coverage

| Category | Endpoints | Operations |
|---|---|---|
| Applications | 15 | CRUD, deploy, restart, stop, logs, env vars |
| Databases | 16 | Create (8 types), CRUD, backups, start/stop |
| Services | 11 | CRUD, env vars, start/restart/stop |
| Servers | 8 | CRUD, validate, list domains/resources |
| Projects | 7 | CRUD, environments |
| Deployments | 5 | Trigger, list, cancel |
| Security | 5 | SSH key management |
| GitHub Apps | 6 | CRUD, list repos/branches |
| Hetzner | 5 | Locations, server types, images, create |
| Cloud Tokens | 5 | CRUD, validate |
| System | 4 | Health, version, enable/disable API |

---

## Helper Script

`scripts/coolify-api.sh` also works standalone outside Claude Code:

```bash
export COOLIFY_API_URL="https://coolify.example.com"
export COOLIFY_API_TOKEN="your-token"

./scripts/coolify-api.sh status              # Overview of all resources
./scripts/coolify-api.sh list applications   # List all apps
./scripts/coolify-api.sh deploy abc123       # Deploy an app
./scripts/coolify-api.sh restart services xyz456
./scripts/coolify-api.sh logs abc123
./scripts/coolify-api.sh set-env applications abc123 NODE_ENV production
./scripts/coolify-api.sh envs applications abc123
```

---

## Requirements

- [Claude Code CLI](https://claude.com/claude-code)
- A running Coolify instance ([self-hosted](https://coolify.io/docs/get-started/installation) or [Coolify Cloud](https://app.coolify.io))
- API token with appropriate permissions

## Built From

Sourced directly from:
- [Coolify official docs](https://coolify.io/docs) (including LLM-optimized `/docs/llms-full.txt`)
- [Coolify API source code](https://github.com/coollabsio/coolify) (`routes/api.php`)
- [Coolify CLI](https://github.com/coollabsio/coolify-cli)

## Author

**Daniel Hjermitslev** — [danielhjermitslev](https://github.com/danielhjermitslev)

## License

[MIT](LICENSE)
