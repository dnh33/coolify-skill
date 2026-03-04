# Coolify API Endpoint Reference

Base URL: `http://<ip>:8000/api/v1`

Authentication: `Authorization: Bearer <token>` header on all requests.

## Health & System

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/health` | None | Health check (no auth required) |
| GET | `/version` | read | Get Coolify version |
| GET | `/enable` | write | Enable API access |
| GET | `/disable` | write | Disable API access |

## Teams

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/teams` | read | List all teams |
| GET | `/teams/current` | read | Get current team |
| GET | `/teams/current/members` | read | List current team members |
| GET | `/teams/{id}` | read | Get team by ID |
| GET | `/teams/{id}/members` | read | List team members by ID |

## Projects

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/projects` | read | List all projects |
| POST | `/projects` | read | Create project |
| GET | `/projects/{uuid}` | read | Get project by UUID |
| PATCH | `/projects/{uuid}` | write | Update project |
| DELETE | `/projects/{uuid}` | write | Delete project |
| GET | `/projects/{uuid}/environments` | read | List environments |
| POST | `/projects/{uuid}/environments` | write | Create environment |
| GET | `/projects/{uuid}/{env_name_or_uuid}` | read | Get environment details |
| DELETE | `/projects/{uuid}/environments/{env_name_or_uuid}` | write | Delete environment |

## Servers

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/servers` | read | List all servers |
| POST | `/servers` | read | Create server |
| GET | `/servers/{uuid}` | read | Get server by UUID |
| PATCH | `/servers/{uuid}` | write | Update server |
| DELETE | `/servers/{uuid}` | write | Delete server |
| GET | `/servers/{uuid}/domains` | read | List domains on server |
| GET | `/servers/{uuid}/resources` | read | List resources on server |
| GET | `/servers/{uuid}/validate` | read | Validate server connectivity |

## Hetzner Integration

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/hetzner/locations` | read | List Hetzner locations |
| GET | `/hetzner/server-types` | read | List Hetzner server types |
| GET | `/hetzner/images` | read | List Hetzner images |
| GET | `/hetzner/ssh-keys` | read | List Hetzner SSH keys |
| POST | `/servers/hetzner` | write | Create server on Hetzner |

## Applications

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/applications` | read | List all applications |
| GET | `/applications/{uuid}` | read | Get application details |
| PATCH | `/applications/{uuid}` | write | Update application |
| DELETE | `/applications/{uuid}` | write | Delete application |

### Create Applications

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| POST | `/applications/public` | write | From public Git repo |
| POST | `/applications/private-github-app` | write | From private repo (GitHub App) |
| POST | `/applications/private-deploy-key` | write | From private repo (deploy key) |
| POST | `/applications/dockerfile` | write | From Dockerfile |
| POST | `/applications/dockerimage` | write | From Docker image |

### Application Environment Variables

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/applications/{uuid}/envs` | read | List env vars |
| POST | `/applications/{uuid}/envs` | write | Create env var |
| PATCH | `/applications/{uuid}/envs` | write | Update env var by UUID |
| PATCH | `/applications/{uuid}/envs/bulk` | write | Bulk create/update env vars |
| DELETE | `/applications/{uuid}/envs/{env_uuid}` | write | Delete env var |

### Application Actions

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET/POST | `/applications/{uuid}/start` | write | Deploy/start application |
| GET/POST | `/applications/{uuid}/restart` | write | Restart application |
| GET/POST | `/applications/{uuid}/stop` | write | Stop application |
| GET | `/applications/{uuid}/logs` | read | Get application logs |

## Deployments

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET/POST | `/deploy` | deploy | Trigger deployment (supports `uuid`, `tag`, `pr_id`, `commit` query params) |
| GET | `/deployments` | read | List all deployments |
| GET | `/deployments/{uuid}` | read | Get deployment by UUID |
| POST | `/deployments/{uuid}/cancel` | deploy | Cancel deployment |
| GET | `/deployments/applications/{uuid}` | read | List deployments for application |

### Deploy Query Parameters

The `/deploy` endpoint supports filtering:

```
/deploy?uuid=<app_uuid>              # Deploy specific app
/deploy?uuid=<app_uuid>&tag=v1.0.0   # Deploy specific tag
/deploy?uuid=<app_uuid>&pr_id=42     # Deploy specific PR
/deploy?uuid=<app_uuid>&commit=abc123 # Deploy specific commit
```

## Databases

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/databases` | read | List all databases |
| GET | `/databases/{uuid}` | read | Get database details |
| PATCH | `/databases/{uuid}` | write | Update database |
| DELETE | `/databases/{uuid}` | write | Delete database |

### Create Databases

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| POST | `/databases/postgresql` | write | Create PostgreSQL |
| POST | `/databases/mysql` | write | Create MySQL |
| POST | `/databases/mariadb` | write | Create MariaDB |
| POST | `/databases/mongodb` | write | Create MongoDB |
| POST | `/databases/redis` | write | Create Redis |
| POST | `/databases/clickhouse` | write | Create ClickHouse |
| POST | `/databases/dragonfly` | write | Create DragonFly |
| POST | `/databases/keydb` | write | Create KeyDB |

### Database Actions

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET/POST | `/databases/{uuid}/start` | write | Start database |
| GET/POST | `/databases/{uuid}/restart` | write | Restart database |
| GET/POST | `/databases/{uuid}/stop` | write | Stop database |

### Database Backups

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/databases/{uuid}/backups` | read | List backup configurations |
| POST | `/databases/{uuid}/backups` | write | Create backup config |
| PATCH | `/databases/{uuid}/backups/{backup_uuid}` | write | Update backup config |
| DELETE | `/databases/{uuid}/backups/{backup_uuid}` | write | Delete backup config |
| GET | `/databases/{uuid}/backups/{backup_uuid}/executions` | read | List backup executions |
| DELETE | `/databases/{uuid}/backups/{backup_uuid}/executions/{exec_uuid}` | write | Delete backup execution |

## Services

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/services` | read | List all services |
| POST | `/services` | write | Create service |
| GET | `/services/{uuid}` | read | Get service details |
| PATCH | `/services/{uuid}` | write | Update service |
| DELETE | `/services/{uuid}` | write | Delete service |

### Service Environment Variables

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/services/{uuid}/envs` | read | List env vars |
| POST | `/services/{uuid}/envs` | write | Create env var |
| PATCH | `/services/{uuid}/envs` | write | Update env var |
| PATCH | `/services/{uuid}/envs/bulk` | write | Bulk create/update env vars |
| DELETE | `/services/{uuid}/envs/{env_uuid}` | write | Delete env var |

### Service Actions

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET/POST | `/services/{uuid}/start` | write | Deploy/start service |
| GET/POST | `/services/{uuid}/restart` | write | Restart service |
| GET/POST | `/services/{uuid}/stop` | write | Stop service |

## Resources

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/resources` | read | List all resources (apps + dbs + services) |

## Security (SSH Keys)

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/security/keys` | read | List SSH keys |
| POST | `/security/keys` | write | Create SSH key |
| GET | `/security/keys/{uuid}` | read | Get key by UUID |
| PATCH | `/security/keys/{uuid}` | write | Update key |
| DELETE | `/security/keys/{uuid}` | write | Delete key |

## Cloud Provider Tokens

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/cloud-tokens` | read | List cloud tokens |
| POST | `/cloud-tokens` | write | Create cloud token |
| GET | `/cloud-tokens/{uuid}` | read | Get token by UUID |
| PATCH | `/cloud-tokens/{uuid}` | write | Update token |
| DELETE | `/cloud-tokens/{uuid}` | write | Delete token |
| POST | `/cloud-tokens/{uuid}/validate` | read | Validate token |

## GitHub Apps

| Method | Endpoint | Permission | Description |
|---|---|---|---|
| GET | `/github-apps` | read | List GitHub Apps |
| POST | `/github-apps` | write | Create GitHub App |
| PATCH | `/github-apps/{id}` | write | Update GitHub App |
| DELETE | `/github-apps/{id}` | write | Delete GitHub App |
| GET | `/github-apps/{id}/repositories` | read | List repos for GitHub App |
| GET | `/github-apps/{id}/repositories/{owner}/{repo}/branches` | read | List branches for repo |

## Common Response Patterns

### Success Responses

```json
// List endpoint
[
  {"uuid": "abc123", "name": "my-app", "status": "running", ...},
  {"uuid": "def456", "name": "my-db", "status": "stopped", ...}
]

// Single resource
{"uuid": "abc123", "name": "my-app", "status": "running", "fqdn": "https://app.example.com", ...}

// Action response
{"message": "Deployment queued.", "deployment_uuid": "xyz789"}
```

### Error Responses

```json
{"message": "Not found.", "docs": "https://coolify.io/docs"}
{"message": "Unauthorized"}
{"message": "Validation failed.", "errors": {"field": ["error message"]}}
```

## Notes

- All UUIDs are short alphanumeric strings (e.g., `vgsco4o`)
- The token scope limits access to resources owned by the token's team
- Write operations require `*` permission on the token
- Sensitive data (passwords, keys) is redacted unless token has `read:sensitive` or `view:sensitive` permission
- GET and POST are both accepted for action endpoints (start/restart/stop/deploy)
