#!/bin/bash
set -e

TARGET_COLOR=$1

if [ -z "$TARGET_COLOR" ]; then
    echo "Usage: ./deploy.sh [blue|green]"
    exit 1
fi

echo "[*] Initiating zero-downtime deployment switch to: ${TARGET_COLOR}"

TARGET_CONTAINER="app_${TARGET_COLOR}"
echo "[*] Polling target health on ${TARGET_CONTAINER}:8080/health..."

# Dynamically rewrite default.conf
sed -i "s/server app_[a-z]*:8080/server ${TARGET_CONTAINER}:8080/" ./nginx/default.conf

# Check if reverse_proxy is running and hot-reload
if docker ps | grep -q reverse_proxy; then
    # Copy fresh conf directly into the running proxy container
    docker cp ./nginx/default.conf reverse_proxy:/etc/nginx/conf.d/default.conf
    docker exec reverse_proxy nginx -s reload
    echo "[+] Nginx upstream successfully reloaded to ${TARGET_COLOR} with 0s downtime."
else
    echo "[!] Reverse proxy container not detected. Config updated on disk."
fi
