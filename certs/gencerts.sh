#!/bin/bash

duck="${SRV_DUCKDNS_SUBDOMAIN}.duckdns.org"

sudo docker run -v /srv/nginx/certbot/conf:/etc/letsencrypt \
    -v /srv/nginx/certbot/www:/var/www/certbot certbot/certbot:latest \
    certonly --webroot -w /var/www/certbot --force-renewal --email "${SRV_ADMIN_EMAIL}" -d "${duck}" --agree-tos

for sub in vpn plex files
do 
    sudo docker run -v /srv/nginx/certbot/conf:/etc/letsencrypt \
        -v /srv/nginx/certbot/www:/var/www/certbot certbot/certbot:latest \
        certonly --webroot -w /var/www/certbot --force-renewal --email "${SRV_ADMIN_EMAIL}" -d "${sub}.${duck}" --agree-tos
done

sudo docker restart nginx