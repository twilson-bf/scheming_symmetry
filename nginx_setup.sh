#!/bin/bash
# Push-button installer for Nginx Reverse Proxy
# Usage: ./nginx_setup.sh <domain> <full_domain>

DOMAIN=\$1
FULL_DOMAIN=$2

# Install dependencies
sudo apt-get update && sudo apt-get install -y nginx certbot python3-certbot-nginx

# Configure Nginx Reverse Proxy
cat > /etc/nginx/sites-available/fid-login <<EOF
server {
    listen 443 ssl;
    server_name ${DOMAIN}.azureedge.net;

    ssl_certificate /etc/letsencrypt/live/${DOMAIN}.azureedge.net/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/${DOMAIN}.azureedge.net/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_prefer_server_ciphers on;
    ssl_session_cache shared:SSL:10m;

    location /login/ {
        rewrite ^/login(/.*)$ \$1 break;
        proxy_pass https://login.${FULL_DOMAIN};
        proxy_pass_request_headers on;
        proxy_http_version 1.1;
        sub_filter 'https://login.${FULL_DOMAIN}' 'https://${DOMAIN}.azureedge.net/login';
        sub_filter_once off;
        proxy_set_header Host login.${FULL_DOMAIN};
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_ssl_server_name on;
        proxy_ssl_verify off;
        proxy_redirect ~^https?://login\.${FULL_DOMAIN}(/?.*)$ https://${DOMAIN}.azureedge.net/login\$1;
    }

    location /www/ {
        rewrite ^/www(/.*)$ \$1 break;
        proxy_pass https://www.${FULL_DOMAIN};
        proxy_pass_request_headers on;
        proxy_http_version 1.1;
        sub_filter 'https://www.${FULL_DOMAIN}' 'https://${DOMAIN}.azureedge.net/www';
        sub_filter_once off;
        proxy_set_header Host www.${FULL_DOMAIN};
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_ssl_server_name on;
        proxy_ssl_verify off;
        proxy_redirect ~^https?://www\.${FULL_DOMAIN}(/?.*)$ https://${DOMAIN}.azureedge.net/www\$1;
    }

    location / {
        return 404 "Invalid request";
    }
}

server {
    listen 80;
    server_name ${DOMAIN}.azureedge.net;
    return 301 https://$host$request_uri;
}
EOF

# Enable and Restart Nginx
sudo ln -sf /etc/nginx/sites-available/fid-login /etc/nginx/sites-enabled/
sudo systemctl restart nginx
