#!/bin/bash

# Add host entry
echo "1 IPv4 or 1 IPv6 or 1 IPv4 and 1 IPv6" >> /etc/hosts

# Add Proxmox repository
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

# Download and verify Proxmox GPG key
wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg
echo "Verifying the GPG key..."
sleep 5
sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

# Update and upgrade the system
apt update && apt full-upgrade

# Install Proxmox default kernel
apt install proxmox-default-kernel

# Reboot the system
echo "The system will reboot in 5 seconds..."
sleep 5
systemctl reboot
