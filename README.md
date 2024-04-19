# Home Sever Instance

This repo contains a simple backup for my server's docker-compose. Fell free to use it if you wanna replicate all my configuration in your own linux instance, please note that you will need Docker for this process.

![CPU](https://img.shields.io/badge/CPU-i3_5005U-blue.svg?style=flat-square)
![RAM](https://img.shields.io/badge/RAM-16GB-green.svg?style=flat-square)
![OS](https://img.shields.io/badge/OS-Ubuntu_22.04-orange.svg?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-20.10-lightblue.svg?style=flat-square)

### Content of this Docker Compose

- AdGuard Home (adblock)
- Easy WireGuard (vpn)
- NGINX Instance (http)
- Minecraft Server (spigot)
- DuckDns (ddns)
- Emby Server (streaming)
- Filebrowser (filesharing)

### Install on Ubuntu Server 22.04

First clone this repo inside your server.

    git clone https://github.com/ramaureirac/home-server

Edit docker-compose file according to your needs.

    vim src/docker/docker-compose.yaml

Fill and export some variables:

    vim src/env/variables.env
    export $(xargs < src/env/variables.env)
    
Run the install.sh scripts. Please note this will install Docker and disable systemd-resolved.service

    bash ./install.sh

Create/Update SSL certificates. This requieres public internet access to Nginx:

    bash /srv/scripts/gencerts.sh

Once completed make sure to configure all your services and restart Docker!