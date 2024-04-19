worker_processes 4;

events {
    use epoll;
    worker_connections 10240;
}

http {
    server_tokens off;
    include mime.types;
    charset utf-8;
    server {
        server_name ${SRV_DUCKDNS_SUBDOMAIN}.duckdns.org;
        listen 80;
        location ~ /.well-known/acme-challenge/ {
            root /var/www/certbot;
        }
        location / {
            return 301 https://$host$request_uri;
        }
    }
}