---
name: Coolify Management
description: >-
  This skill should be used when the user asks to "deploy to Coolify", "manage Coolify",
  "check Coolify status", "list Coolify applications", "create Coolify service",
  "manage Coolify databases", "check deployment status", "restart application on Coolify",
  "configure Coolify server", "manage Coolify environment variables", "check Coolify logs",
  "deploy Docker image to Coolify", "set up Coolify project", or discusses any Coolify
  self-hosting platform operations including applications, services, databases, servers,
  deployments, backups, domains, and proxy configuration.
version: 0.1.0
---

# Coolify Management

Coolify is an open-source, self-hosted PaaS (Platform as a Service) — an alternative to Vercel, Heroku, and Railway. It deploys applications, databases, and 280+ one-click services to any server via SSH.

## Configuration Requirements

Before using the API, ensure the following environment variables or configuration are available:

- **`COOLIFY_API_URL`** — Base URL of the Coolify instance (e.g., `https://coolify.example.com`)
- **`COOLIFY_API_TOKEN`** — Bearer token generated from Coolify UI under `Keys & Tokens > API tokens`

If not set, prompt the user for these values. Store them for the session.

### API Access Pattern

All API requests follow this pattern:

```bash
curl -s -H "Authorization: Bearer $COOLIFY_API_TOKEN" \
  -H "Content-Type: application/json" \
  "$COOLIFY_API_URL/api/v1/{endpoint}"
```

### Token Permissions

| Permission | Access |
|---|---|
| `read-only` (default) | Read data, no mutations, no sensitive data |
| `read:sensitive` | Read data + see passwords/keys (redacted by default) |
| `view:sensitive` | See sensitive data in responses |
| `*` | Full access — read, write, delete, sensitive data |

For management operations, the token needs `*` permission.

## Core Concepts

### Hierarchy

```
Team → Project → Environment → Resources (Applications / Databases / Services)
                                    ↓
                                  Server (runs containers via Docker + Traefik/Caddy proxy)
```

### Resource Types

| Type | Description |
|---|---|
| **Application** | Web app from Git repo, Dockerfile, Docker image, or Docker Compose |
| **Database** | PostgreSQL, MySQL, MariaDB, MongoDB, Redis, KeyDB, DragonFly, ClickHouse |
| **Service** | One-click deployable service (280+ options: WordPress, n8n, Plausible, etc.) |

## Common Workflows

### 1. List and Inspect Resources

```bash
# List all servers
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/servers" | jq

# List all applications
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/applications" | jq

# List all databases
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/databases" | jq

# List all services
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/services" | jq

# List all projects
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/projects" | jq

# Get specific resource by UUID
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/applications/{uuid}" | jq
```

### 2. Deploy / Control Applications

```bash
# Deploy (start) an application
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/applications/{uuid}/start"

# Restart an application
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/applications/{uuid}/restart"

# Stop an application
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/applications/{uuid}/stop"

# Trigger deployment via webhook (supports tag/PR/commit query params)
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/deploy?uuid={uuid}"
```

### 3. Create Applications

Available creation endpoints:

| Endpoint | Source Type |
|---|---|
| `POST /applications/public` | Public Git repository |
| `POST /applications/private-github-app` | Private repo via GitHub App |
| `POST /applications/private-deploy-key` | Private repo via deploy key |
| `POST /applications/dockerfile` | Dockerfile-based |
| `POST /applications/dockerimage` | Pre-built Docker image |

### 4. Manage Environment Variables

```bash
# List env vars for an application
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/applications/{uuid}/envs" | jq

# Create single env var
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"key": "NODE_ENV", "value": "production", "is_build_time": false}' \
  "$URL/api/v1/applications/{uuid}/envs"

# Bulk update env vars
curl -s -X PATCH -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '[{"key": "KEY1", "value": "val1"}, {"key": "KEY2", "value": "val2"}]' \
  "$URL/api/v1/applications/{uuid}/envs/bulk"

# Delete env var
curl -s -X DELETE -H "Authorization: Bearer $TOKEN" \
  "$URL/api/v1/applications/{uuid}/envs/{env_uuid}"
```

### 5. Manage Deployments

```bash
# List all deployments
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/deployments" | jq

# Get deployment details
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/deployments/{uuid}" | jq

# Get deployments for specific application
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/deployments/applications/{uuid}" | jq

# Cancel a deployment
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/deployments/{uuid}/cancel"
```

### 6. Database Operations

```bash
# Create PostgreSQL database
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"server_uuid": "xxx", "project_uuid": "xxx", "environment_name": "production", ...}' \
  "$URL/api/v1/databases/postgresql"

# Start/Restart/Stop database
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/databases/{uuid}/start"
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/databases/{uuid}/restart"
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/databases/{uuid}/stop"

# Manage database backups
curl -s -H "Authorization: Bearer $TOKEN" "$URL/api/v1/databases/{uuid}/backups" | jq
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"s3_storage_id": "xxx", "frequency": "0 2 * * *", ...}' \
  "$URL/api/v1/databases/{uuid}/backups"
```

Supported database types: `postgresql`, `mysql`, `mariadb`, `mongodb`, `redis`, `clickhouse`, `dragonfly`, `keydb`.

### 7. Service Operations

```bash
# Create a service (docker-compose based)
curl -s -X POST -H "Authorization: Bearer $TOKEN" -H "Content-Type: application/json" \
  -d '{"server_uuid": "xxx", "project_uuid": "xxx", "environment_name": "production", "type": "plausible", ...}' \
  "$URL/api/v1/services"

# Start/Restart/Stop service
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/services/{uuid}/start"
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/services/{uuid}/restart"
curl -s -X POST -H "Authorization: Bearer $TOKEN" "$URL/api/v1/services/{uuid}/stop"
```

## Coolify CLI

Coolify has an official CLI tool (`coolify-cli`) for terminal-based management.

### Installation

```bash
# Linux/macOS
curl -fsSL https://raw.githubusercontent.com/coollabsio/coolify-cli/main/scripts/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/coollabsio/coolify-cli/main/scripts/install.ps1 | iex
```

The CLI wraps the API and provides interactive commands for managing resources.

## SSH Server Commands

For direct server access (when API is insufficient), use `docker exec` on the Coolify container:

```bash
# Reset root password
docker exec -ti coolify sh -c "php artisan root:reset-password"

# Change root email
docker exec -ti coolify sh -c "php artisan root:change-email"

# Delete stuck service
docker exec -ti coolify sh -c "php artisan services:delete"
```

## Domain Configuration

- Use FQDN format: `https://coolify.io`
- Multiple domains separated by comma: `https://coolify.io,https://www.coolify.io`
- Port mapping in domain: `https://coolify.io:8080`
- Path-based routing: `https://coolify.io/api` (more specific paths get higher priority)
- HTTPS is automatic via Let's Encrypt when using `https://` prefix
- Wildcard domains on server level generate auto-domains for all resources

## Predefined Environment Variables

Applications automatically have access to:

| Variable | Value |
|---|---|
| `COOLIFY_FQDN` | Domain(s) of the application |
| `COOLIFY_URL` | URL(s) of the application |
| `COOLIFY_BRANCH` | Git branch name |
| `COOLIFY_RESOURCE_UUID` | Unique resource identifier |
| `COOLIFY_CONTAINER_NAME` | Container name |
| `SOURCE_COMMIT` | Git commit hash |
| `PORT` | First exposed port |
| `HOST` | `0.0.0.0` |

## Shared Variables

Shared variables can be scoped at three levels and referenced using template syntax:

- **Team**: `{{team.VAR_NAME}}`
- **Project**: `{{project.VAR_NAME}}`
- **Environment**: `{{environment.VAR_NAME}}`

## Troubleshooting Quick Reference

| Issue | Check |
|---|---|
| Bad Gateway (502) | Application health check, container running, port config |
| Gateway Timeout (504) | Application response time, resource limits |
| Let's Encrypt fails | DNS A record pointing to server IP, port 80/443 open |
| Dashboard slow | Server resources, Docker cleanup threshold |
| Connection unstable | Firewall UFW LIMIT rules on port 22 |
| 2FA stopped working | Server time sync (`timedatectl set-ntp true`) |

## Additional Resources

### Reference Files

For detailed API endpoint documentation and advanced operations:
- **`references/api-endpoints.md`** — Complete API endpoint reference with all routes, methods, and permissions
- **`references/server-management.md`** — Server configuration, proxy setup, Cloudflare tunnels, multi-server architecture

### Scripts

- **`scripts/coolify-api.sh`** — Helper script for common API operations with error handling
