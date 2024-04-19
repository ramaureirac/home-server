#!/bin/bash

for SUBSUBDOM in "" "vpn." "plex." "files."
do 
    sudo docker run -v /srv/nginx/certbot/conf:/etc/letsencrypt \
        -v /srv/nginx/certbot/www:/var/www/certbot certbot/certbot:latest \
        certonly --webroot -w /var/www/certbot --force-renewal --email "${SRV_ADMIN_EMAIL}" -d "${SUBSUBDOM}${SRV_DUCKDNS_SUBDOMAIN}.duckdns.org" --agree-tos
done

sudo docker restart nginx-ssl