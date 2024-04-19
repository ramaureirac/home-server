#!/bin/bash

# Update Ubuntu + Some pre-requirements
echo "Updating Ubuntu Server . . ."
sudo apt update && sudo apt upgrade -y
sudo apt install -y ca-certificates curl gnupg lsb-release build-essential vim


# Install Docker Engine
if [ -x "$(command -v docker)" ]; then
    echo "Installing Docker Engine . . ."
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi


# Stop systemd-resolved
if [ $(systemctl is-active systemd-resolved.service) = "active" ]; then
    echo "Disabling systemd-resolved.service . . ."
    sudo systemctl disable --now systemd-resolved.service
    sudo rm -rf /etc/resolv.conf && sudo touch /etc/resolv.conf
    echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "nameserver 8.8.4.4" | sudo tee -a /etc/resolv.conf > /dev/null
fi


# Installing Docker Compose and configuration files
sudo mkdir -p /srv/nginx/conf /srv/scripts
envsubst '${SRV_DUCKDNS_SUBDOMAIN}' < src/templates/certbot.nginx.conf.tpl | sudo tee /srv/nginx/conf/certbot.nginx.conf > /dev/null
envsubst '${SRV_DUCKDNS_SUBDOMAIN}' < src/templates/main.nginx.conf.tpl | sudo tee /srv/nginx/conf/main.nginx.conf > /dev/null
envsubst '${SRV_DUCKDNS_SUBDOMAIN} ${SRV_ADMIN_EMAIL}' < src/templates/gencerts.sh.tpl | sudo tee /srv/scripts/gencerts.sh > /dev/null
envsubst < src/docker/docker-compose.yaml | sudo tee /srv/docker-compose.yaml > /dev/null


# Start containers
cd /srv
sudo docker compose up -d
