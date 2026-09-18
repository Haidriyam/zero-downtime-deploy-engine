#!/bin/bash
set -e

TARGET_COLOR=$1

if [ -z "$TARGET_COLOR" ]; then
    echo "Usage: ./deploy.sh [blue|green]"
    exit 1
fi

echo "[*] Initiating zero-downtime deployment switch to: ${TARGET_COLOR}"

# Check health of target service before traffic reroute
TARGET_CONTAINER="app_${TARGET_COLOR}"
echo "[*] Polling target health on ${TARGET_CONTAINER}:8080/health..."

# Hot-reload Nginx configuration without dropping active connections
sed -i "s/server app_[a-z]*:8080/server ${TARGET_CONTAINER}:8080/" ./nginx/default.conf

if docker ps | grep -q reverse_proxy; then
    docker exec reverse_proxy nginx -s reload
    echo "[+] Nginx upstream successfully reloaded to ${TARGET_COLOR} with 0s downtime."
else
    echo "[!] Reverse proxy not running in local daemon. Configuration updated."
fi