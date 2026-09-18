#!/bin/bash
set -e

TARGET_COLOR=$1

if [ -z "$TARGET_COLOR" ]; then
    echo "Usage: ./deploy.sh [blue|green]"
    exit 1
fi

echo "[*] Initiating zero-downtime deployment switch to: ${TARGET_COLOR}"
TARGET_CONTAINER="app_${TARGET_COLOR}"
echo "[*] Target upstream container: ${TARGET_CONTAINER}:8080"

# Target the configuration inside the mounted directory
CONFIG_FILE="./nginx/conf.d/default.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "[!] Error: $CONFIG_FILE does not exist."
    exit 1
fi

# Update upstream on the host system
sed -i "s/server app_[a-z]*:8080/server ${TARGET_CONTAINER}:8080/" "$CONFIG_FILE"

# Instruct Nginx to reload without breaking connections
if docker ps | grep -q reverse_proxy; then
    docker exec reverse_proxy nginx -t
    docker exec reverse_proxy nginx -s reload
    echo "[+] Nginx upstream successfully reloaded to ${TARGET_COLOR} with 0s downtime."
else
    echo "[!] Reverse proxy container not detected."
fi
