# Home Sever Instance

This repo contains a simple backup for my server's docker-compose. Fell free to use it if you wanna replicate all my configuration in your own linux instance, please note that you will need Docker for this process, but alternatively you should be able to use Podman as well or even transform everything into KubeConfig files.

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
- Plex Home Server (streaming)
- Filebrowser (filesharing)

### Installation

First, clone this repo and prepare your Ubuntu instance by running the following script

    sudo sudo apt update && sudo apt upgrade -y && sudo apt install -y ca-certificates curl gnupg lsb-release build-essential

Also, install latest Docker version if needed

    sudo mkdir -p /etc/apt/keyrings && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker.service

Disable ```systemd-resolved.service``` in order to use AdGuard and remember to re-configure ```/etc/resolv.conf``` file

    sudo systemctl disable --now systemd-resolved.service
    sudo rm -f /etc/resolv.conf && sudo echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf >> /dev/null

Finally, edit ```.env``` and ```docker-compose.yaml``` files according to your preferences and run the content

    sudo docker compose --env-file .env up -d