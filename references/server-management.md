# Coolify Server Management Reference

## Server Requirements

- SSH connectivity with key authentication (root user's `~/.ssh/authorized_keys`)
- Docker Engine 24+
- Linux OS (any distribution)

## Server Types

### Localhost
The server where Coolify is installed. Not recommended for production resources — high usage can prevent Coolify dashboard access.

### Remote Server
Any Linux server reachable via SSH: VPS, Raspberry Pi, EC2, bare metal, etc.

## Multi-Server Architecture

Each server runs its own reverse proxy (Traefik or Caddy). Traffic flows directly to the server hosting the application — NOT through the main Coolify server.

**Main Coolify server role:**
- Management UI
- SSH connections to secondary servers for deployment
- Health checks and monitoring
- Does NOT proxy traffic to other servers

**DNS requirement:** Point each domain to the IP of the server where the app runs, not the Coolify server.

## Proxy Configuration

### Traefik (Default)
Coolify uses Traefik v2 by default. Starts automatically when a resource has a domain configured.

Dynamic configuration can be added via the UI at `/server/<server_uuid>/proxy`.

### Caddy
Alternative proxy option available in newer versions.

### Custom/None
Manual proxy configuration for advanced users.

## Wildcard Domains

Set on the server level (e.g., `http://example.com`). All resources automatically get domains like:
- `http://{resource_uuid}.example.com`

Without a wildcard domain, Coolify generates sslip.io domains:
- `http://{resource_uuid}.{server_ip}.sslip.io`

## Automated Docker Cleanup

Configure under `Servers > YOUR_SERVER > Configuration > Advanced`.

### Settings
- **Docker Cleanup Threshold**: Disk percentage that triggers cleanup (e.g., 80%)
- **Docker Cleanup Frequency**: Cron expression for scheduled cleanups (requires `Force Docker Cleanup` enabled)
- **Optional**: Unused volumes cleanup (risk of data loss), unused networks cleanup

### Cleanup Process
When triggered:
1. Removes stopped containers managed by Coolify
2. Deletes unused Docker images
3. Clears Docker build cache
4. Removes old Coolify helper images
5. (Optional) Removes unused volumes/networks

Safety: Skips cleanup during active deployments.

## Cloudflare Tunnels Integration

### For All Resources (Wildcard)
1. Create Cloudflare Tunnel in Zero Trust dashboard
2. Configure wildcard subdomain hostname → `localhost:80` (HTTP)
3. Set SSL/TLS encryption mode to **Full**
4. Deploy `cloudflared` as a service in Coolify with the tunnel token
5. Start Coolify Proxy
6. Configure resources with HTTP domains (not HTTPS — Cloudflare handles TLS)

### For Single Resource
1. Set app port mapping in Coolify
2. Create tunnel with specific hostname → `localhost:{port}`
3. Deploy cloudflared with token

### Important Notes
- Use HTTP for resource domains when behind Cloudflare Tunnel (HTTPS causes TOO_MANY_REDIRECTS)
- For apps requiring HTTPS cookies/login, follow Full TLS HTTPS guide after tunnel setup
- No need for public IP — tunnel handles connectivity

## Firewall Configuration

### Required Ports
| Port | Protocol | Purpose |
|---|---|---|
| 22 | TCP | SSH (Coolify management) |
| 80 | TCP | HTTP (Let's Encrypt + proxy) |
| 443 | TCP | HTTPS (proxy) |
| 8000 | TCP | Coolify dashboard + API |

### UFW Rules
```bash
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8000/tcp
```

**Common issue:** `ufw limit 22/tcp` causes connection instability. Remove LIMIT rules and use plain `allow`.

## Build Server

Separate server dedicated to building Docker images, keeping production servers lightweight.

Configure under application settings to offload builds.

## Server Sentinel

Coolify's monitoring agent that runs on managed servers. Pushes metrics (CPU, memory, disk) to the Coolify instance.

## Installation

### Fresh Install
```bash
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash
```

### Upgrade
Coolify supports auto-update. Disable via `Settings > Auto Update` before manual version management.

### Downgrade
```bash
# SSH into server, then:
curl -fsSL https://cdn.coollabs.io/coolify/install.sh | bash -s -- --version=v4.x.x
```

### Uninstall
```bash
curl -fsSL https://cdn.coollabs.io/coolify/uninstall.sh | bash
```

## SSH Commands (Direct Server Access)

```bash
# Reset root password (when SMTP not configured)
docker exec -ti coolify sh -c "php artisan root:reset-password"

# Change root email
docker exec -ti coolify sh -c "php artisan root:change-email"

# Delete stuck service
docker exec -ti coolify sh -c "php artisan services:delete"
```

## S3 Backup Configuration

Supported S3-compatible providers:
- AWS S3
- DigitalOcean Spaces
- MinIO
- Cloudflare R2
- Backblaze B2
- Scaleway Object Storage
- Hetzner S3
- Wasabi
- Vultr

Coolify uses MinIO client (`mc`) for backup operations. Bucket must be created first, then verified via `ListObjectsV2`.

## Notifications

Supported channels:
- Discord
- Telegram
- Email
- Custom webhooks

Configure under `Settings > Notifications`.

## Build Packs

| Build Pack | Description |
|---|---|
| **Nixpacks** | Auto-detects language and builds (default, recommended) |
| **Static** | For SPAs and static sites (served by Nginx) |
| **Dockerfile** | Custom Dockerfile |
| **Docker Compose** | Multi-service applications |
| **Docker Image** | Pre-built images from registries |

## Health Checks

All containers are checked for liveness by default. Traefik won't route to unhealthy containers.

Disable health checks if unsure about configuration — unhealthy containers block routing.

## Persistent Storage

Configure volume mounts for data that needs to survive container restarts and redeployments.

## Rolling Updates

Available when port mappings to host are NOT used. Enables zero-downtime deployments.

## DNS Configuration

Coolify validates DNS with Cloudflare DNS (`1.1.1.1`) by default. Change custom DNS servers under `Settings > Advanced > Custom DNS Servers`.

## Troubleshooting

### Bad Gateway (502)
- Check container is running
- Verify port configuration matches application
- Check health check status
- Review application logs

### Let's Encrypt Not Working
- Verify DNS A record points to correct server IP
- Ensure ports 80 and 443 are open
- Check domain is publicly accessible
- Review proxy logs

### Dashboard Inaccessible
- SSH into server, check Coolify containers: `docker ps | grep coolify`
- Restart Coolify: `docker restart coolify coolify-proxy`
- Check port 8000 is open

### Connection Unstable
- Remove UFW LIMIT rules on port 22
- Check iptables for rate limiting
- Review `/var/log/auth.log` for connection drops

### 2FA Stopped Working
- Time sync issue. Fix with: `sudo timedatectl set-ntp true`
- Or: `sudo ntpdate ntp.ubuntu.com`
- Check firewall allows port 123 (NTP)
