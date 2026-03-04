#!/usr/bin/env bash
# Coolify API Helper Script
# Usage: ./coolify-api.sh <command> [args...]
#
# Environment variables required:
#   COOLIFY_API_URL   - Base URL (e.g., https://coolify.example.com)
#   COOLIFY_API_TOKEN - Bearer token from Coolify UI
#
# Commands:
#   health                          - Check API health
#   version                         - Get Coolify version
#   list <resource>                 - List resources (servers|applications|databases|services|projects|deployments)
#   get <resource> <uuid>           - Get resource details
#   deploy <uuid>                   - Deploy/start application
#   restart <resource> <uuid>       - Restart resource (applications|databases|services)
#   stop <resource> <uuid>          - Stop resource
#   logs <uuid>                     - Get application logs
#   envs <resource> <uuid>          - List env vars (applications|services)
#   set-env <resource> <uuid> <key> <value> [--build] - Set environment variable
#   deployments <app_uuid>          - List deployments for application
#   server-resources <uuid>         - List resources on a server
#   status                          - Overview of all resources

set -euo pipefail

# Validate configuration
if [[ -z "${COOLIFY_API_URL:-}" ]]; then
    echo "Error: COOLIFY_API_URL not set" >&2
    exit 1
fi
if [[ -z "${COOLIFY_API_TOKEN:-}" ]]; then
    echo "Error: COOLIFY_API_TOKEN not set" >&2
    exit 1
fi

BASE_URL="${COOLIFY_API_URL}/api/v1"
AUTH_HEADER="Authorization: Bearer ${COOLIFY_API_TOKEN}"

api() {
    local method="$1"
    local endpoint="$2"
    shift 2
    local url="${BASE_URL}${endpoint}"

    curl -s -w "\n%{http_code}" \
        -X "$method" \
        -H "$AUTH_HEADER" \
        -H "Content-Type: application/json" \
        "$@" \
        "$url"
}

api_get() { api GET "$1"; }
api_post() { api POST "$1" "${@:2}"; }
api_patch() { api PATCH "$1" "${@:2}"; }
api_delete() { api DELETE "$1"; }

check_response() {
    local response="$1"
    local body http_code
    http_code=$(echo "$response" | tail -1)
    body=$(echo "$response" | sed '$d')

    if [[ "$http_code" -ge 200 && "$http_code" -lt 300 ]]; then
        echo "$body" | jq . 2>/dev/null || echo "$body"
    else
        echo "Error (HTTP $http_code):" >&2
        echo "$body" | jq . 2>/dev/null || echo "$body" >&2
        return 1
    fi
}

cmd="${1:-help}"
shift || true

case "$cmd" in
    health)
        check_response "$(api_get /health)"
        ;;
    version)
        check_response "$(api_get /version)"
        ;;
    list)
        resource="${1:?Usage: list <servers|applications|databases|services|projects|deployments>}"
        check_response "$(api_get /$resource)"
        ;;
    get)
        resource="${1:?Usage: get <resource> <uuid>}"
        uuid="${2:?Usage: get <resource> <uuid>}"
        check_response "$(api_get /$resource/$uuid)"
        ;;
    deploy)
        uuid="${1:?Usage: deploy <uuid>}"
        check_response "$(api_post /applications/$uuid/start)"
        ;;
    restart)
        resource="${1:?Usage: restart <applications|databases|services> <uuid>}"
        uuid="${2:?Usage: restart <resource> <uuid>}"
        check_response "$(api_post /$resource/$uuid/restart)"
        ;;
    stop)
        resource="${1:?Usage: stop <applications|databases|services> <uuid>}"
        uuid="${2:?Usage: stop <resource> <uuid>}"
        check_response "$(api_post /$resource/$uuid/stop)"
        ;;
    logs)
        uuid="${1:?Usage: logs <uuid>}"
        check_response "$(api_get /applications/$uuid/logs)"
        ;;
    envs)
        resource="${1:?Usage: envs <applications|services> <uuid>}"
        uuid="${2:?Usage: envs <resource> <uuid>}"
        check_response "$(api_get /$resource/$uuid/envs)"
        ;;
    set-env)
        resource="${1:?Usage: set-env <applications|services> <uuid> <key> <value> [--build]}"
        uuid="${2:?}"
        key="${3:?}"
        value="${4:?}"
        is_build="false"
        [[ "${5:-}" == "--build" ]] && is_build="true"
        check_response "$(api_post /$resource/$uuid/envs -d "{\"key\":\"$key\",\"value\":\"$value\",\"is_build_time\":$is_build}")"
        ;;
    deployments)
        uuid="${1:?Usage: deployments <app_uuid>}"
        check_response "$(api_get /deployments/applications/$uuid)"
        ;;
    server-resources)
        uuid="${1:?Usage: server-resources <server_uuid>}"
        check_response "$(api_get /servers/$uuid/resources)"
        ;;
    status)
        echo "=== Servers ==="
        api_get /servers | sed '$d' | jq -r '.[] | "  \(.uuid) | \(.name) | \(.ip)"' 2>/dev/null || echo "  (no servers or error)"
        echo ""
        echo "=== Applications ==="
        api_get /applications | sed '$d' | jq -r '.[] | "  \(.uuid) | \(.name) | \(.status // "unknown")"' 2>/dev/null || echo "  (no applications or error)"
        echo ""
        echo "=== Databases ==="
        api_get /databases | sed '$d' | jq -r '.[] | "  \(.uuid) | \(.name) | \(.status // "unknown")"' 2>/dev/null || echo "  (no databases or error)"
        echo ""
        echo "=== Services ==="
        api_get /services | sed '$d' | jq -r '.[] | "  \(.uuid) | \(.name) | \(.status // "unknown")"' 2>/dev/null || echo "  (no services or error)"
        ;;
    help|*)
        cat <<'HELP'
Coolify API Helper

Commands:
  health                                    Check API health
  version                                   Get Coolify version
  list <resource>                           List resources (servers|applications|databases|services|projects|deployments)
  get <resource> <uuid>                     Get resource details
  deploy <uuid>                             Deploy/start application
  restart <resource> <uuid>                 Restart resource
  stop <resource> <uuid>                    Stop resource
  logs <uuid>                               Get application logs
  envs <resource> <uuid>                    List env vars
  set-env <resource> <uuid> <key> <value>   Set env var (add --build for build-time)
  deployments <app_uuid>                    List deployments for app
  server-resources <server_uuid>            List resources on server
  status                                    Overview of all resources

Environment:
  COOLIFY_API_URL   Base URL (required)
  COOLIFY_API_TOKEN Bearer token (required)
HELP
        ;;
esac
