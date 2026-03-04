# Coolify Skill for Claude Code

Manage your entire [Coolify](https://coolify.io) infrastructure from Claude Code. Deploy apps, control databases, manage services, handle environment variables, and troubleshoot — all through natural language.

## What It Does

This skill gives Claude Code deep knowledge of Coolify's API, architecture, and operations. Ask it to:

- **Deploy & control** — start, stop, restart applications, databases, and services
- **Create resources** — spin up apps from Git repos, Docker images, Dockerfiles, or Docker Compose
- **Manage env vars** — list, set, bulk-update, and delete environment variables
- **Monitor** — check deployment status, view logs, list resources across servers
- **Database ops** — create databases (PostgreSQL, MySQL, MariaDB, MongoDB, Redis, ClickHouse, DragonFly, KeyDB), configure automated S3 backups
- **Server management** — multi-server architecture, proxy config, Cloudflare tunnels
- **Troubleshoot** — diagnose 502s, SSL issues, connection problems, stuck services

Covers **all 80+ API endpoints** from the Coolify v4 source code.

## Install

```bash
claude skill install danieldoesmedia/coolify-skill
```

Or manually — clone this repo into your Claude Code skills directory:

```bash
git clone https://github.com/danieldoesmedia/coolify-skill.git ~/.claude/skills/coolify
```

## Setup

You need two environment variables for API access:

```bash
export COOLIFY_API_URL="https://coolify.example.com"
export COOLIFY_API_TOKEN="your-bearer-token-here"
```

Generate your API token in the Coolify dashboard under **Keys & Tokens → API tokens**. Use `*` permission for full management access.

## Usage Examples

Just talk to Claude naturally:

```
"List all my Coolify applications"
"Deploy the app with UUID abc123"
"Restart the PostgreSQL database"
"Set NODE_ENV to production on my-app"
"What's running on my Hetzner server?"
"Create a new Redis database in the staging environment"
"Show me the deployment logs"
"Why am I getting a 502 on my app?"
```

## What's Included

```
coolify-skill/
├── SKILL.md                              # Core skill (auto-loaded on trigger)
│   ├── API patterns & authentication
│   ├── Common workflows with curl examples
│   ├── Domain & SSL configuration
│   ├── Environment variable management
│   └── Troubleshooting quick reference
├── references/
│   ├── api-endpoints.md                  # Complete API reference (80+ endpoints)
│   └── server-management.md             # Server config, proxies, tunnels, backups
└── scripts/
    └── coolify-api.sh                    # Standalone helper script
```

### Progressive Disclosure

The skill loads efficiently:

1. **Always in context** — skill name + description (~100 words) for trigger matching
2. **On trigger** — SKILL.md body with core workflows and API patterns
3. **On demand** — reference files loaded only when deeper detail is needed

## Helper Script

`scripts/coolify-api.sh` can also be used standalone:

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

## Requirements

- A running Coolify instance (self-hosted or [Coolify Cloud](https://app.coolify.io))
- API token with appropriate permissions
- Claude Code CLI

## Built From

Sourced directly from:
- [Coolify official documentation](https://coolify.io/docs) (including LLM-optimized docs)
- [Coolify API routes source code](https://github.com/coollabsio/coolify) (`routes/api.php`)
- [Coolify CLI](https://github.com/coollabsio/coolify-cli)

## License

MIT
