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

# Dynamically rewrite default.conf on host
sed -i "s/server app_[a-z]*:8080/server ${TARGET_CONTAINER}:8080/" ./nginx/default.conf

# Overwrite config inside running container without unlinking the mount inode
if docker ps | grep -q reverse_proxy; then
    docker exec -i reverse_proxy sh -c 'cat > /etc/nginx/conf.d/default.conf' < ./nginx/default.conf
    docker exec reverse_proxy nginx -s reload
    echo "[+] Nginx upstream successfully reloaded to ${TARGET_COLOR} with 0s downtime."
else
    echo "[!] Reverse proxy container not detected. Config updated on disk."
fi
