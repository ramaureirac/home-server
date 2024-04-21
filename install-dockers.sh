#!/bin/bash

# This script will install all docker service inside /srv
# pls make sure to review and edit if needed.
#
# All docker files are inside src/docker
# Note: this requiere to have docker installed and systemd-resolved disabled!!


read -p "This script will install Docker services inside /srv. Continue? (y/n) : " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then exit 0; fi


### INSTALL DOCKER ENGINE --------------------------
read -p "Install Docker? (y/n) : " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo apt update && sudo apt install -y ca-certificates curl gnupg lsb-release build-essential vim
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker && sudo systemctl status docker
fi


### DISABLE SYSTEMD RESOLVED --------------------------
read -p "Disable systemd-resolved service? (y/n) : " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    read -p "Primary DNS Server (e.g. 8.8.8.8) : " -r PRIMARY_DNS
    read -p "Secondary DNS Server (e.g. 8.8.4.4) : " -r SECONDARY_DNS
    sudo systemctl disable --now systemd-resolved.service
    sudo rm -rf /etc/resolv.conf && sudo touch /etc/resolv.conf
    echo "nameserver $PRIMARY_DNS" | sudo tee -a /etc/resolv.conf > /dev/null
    echo "nameserver $SECONDARY_DNS" | sudo tee -a /etc/resolv.conf > /dev/null  
fi


### DISABLE SYSTEMD RESOLVED --------------------------
echo "Installing Docker Services"
read -p "DuckDNS subdomain : " -r SRV_DUCKDNS_SUBDOMAIN
read -p "DuckDNS token : " -r SRV_DUCKDNS_TOKEN
read -p "Webmaster email : " -r SRV_ADMIN_EMAIL
read -p "Server password : " -r SRV_ADMIN_PASSWORD


sudo mkdir -p /srv/nginx/conf /srv/scripts
envsubst '${SRV_DUCKDNS_SUBDOMAIN}' < src/templates/certbot.nginx.conf | sudo tee /srv/nginx/conf/certbot.nginx.conf > /dev/null
envsubst '${SRV_DUCKDNS_SUBDOMAIN}' < src/templates/main.nginx.conf | sudo tee /srv/nginx/conf/main.nginx.conf > /dev/null
envsubst '${SRV_DUCKDNS_SUBDOMAIN} ${SRV_ADMIN_EMAIL}' < src/templates/gencerts.sh | sudo tee /srv/scripts/gencerts.sh > /dev/null
envsubst < src/docker/docker-compose.yaml | sudo tee /srv/docker-compose.yaml > /dev/null


cd /srv
sudo docker compose up -d