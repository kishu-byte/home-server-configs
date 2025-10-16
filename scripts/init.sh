#!/bin/bash

# Homelab Initialization Script
set -e

echo "=== Homelab Setup Initialization ==="

# Create Docker networks
echo "Creating Docker networks..."
docker network create homelab --subnet=172.20.0.0/24 2>/dev/null || echo "Network homelab already exists"
docker network create vpn --subnet=172.21.0.0/24 2>/dev/null || echo "Network vpn already exists"
docker network create mgmt --subnet=172.22.0.0/24 2>/dev/null || echo "Network mgmt already exists"

# Mount NAS storage
echo "Mounting NAS storage..."
sudo mkdir -p /mnt/nas
if ! mountpoint -q /mnt/nas; then
    sudo mount -t nfs 192.168.1.174:/volume1/Home-Streaming /mnt/nas
    echo "192.168.1.174:/volume1/Home-Streaming /mnt/nas nfs defaults 0 0" | sudo tee -a /etc/fstab
fi

# Create required directories
echo "Creating directory structure..."
mkdir -p ~/homelab/{config,data,scripts,backups}
mkdir -p ~/homelab/config/{traefik/certs,adguard/{work,conf},wireguard,gluetun}
mkdir -p ~/homelab/data/media/{movies,tv,music}

# Set proper permissions
echo "Setting permissions..."
sudo chown -R $USER:$USER ~/homelab
chmod +x ~/homelab/scripts/*.sh

# Generate required certificates and keys
echo "Generating security keys..."
if [ ! -f ~/homelab/config/traefik/certs/acme.json ]; then
    touch ~/homelab/config/traefik/certs/acme.json
    chmod 600 ~/homelab/config/traefik/certs/acme.json
fi

# Install Python dependencies for Telegram bot
echo "Installing Python dependencies..."
pip3 install python-telegram-bot docker

# Start core infrastructure
echo "Starting core infrastructure..."
cd ~/homelab
docker-compose up -d

echo "=== Initialization completed successfully ==="
echo "Next steps:"
echo "1. Configure your .env file with actual values"
echo "2. Set up Cloudflare DNS records"
echo "3. Configure NordVPN credentials"
echo "4. Start additional service stacks"
