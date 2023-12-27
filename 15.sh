#!/bin/bash

# Add host entry to /etc/hosts
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1 localhost" >> /etc/hosts

# Set up Proxmox repository
echo "deb [arch=amd64] http://download.proxmox.com/debian/pve bookworm pve-no-subscription" > /etc/apt/sources.list.d/pve-install-repo.list

wget https://enterprise.proxmox.com/debian/proxmox-release-bookworm.gpg -O /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

# Verify checksum
checksum=$(sha512sum /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg | awk '{print $1}')
expected_checksum="7da6fe34168adc6e479327ba517796d4702fa2f8b4f0a9833f5ea6e6b48f6507a6da403a274fe201595edc86a84463d50383d07f64bdde2e3658108db7d6dc87"

if [ "$checksum" != "$expected_checksum" ]; then
    echo "Checksum verification failed. Exiting."
    exit 1
fi

# Update and upgrade
apt update && apt full-upgrade

# Install proxmox-default-kernel
apt install -y proxmox-default-kernel

# Reboot
echo "Rebooting..."
sleep 5
systemctl reboot

# Wait for the system to come back up
sleep 60

# Resume installation after reboot
# Install required packages
apt install -y proxmox-ve postfix open-iscsi chrony

# Update GRUB
update-grub

# Remove os-prober
apt remove -y os-prober

# Connect to the admin web interface and display information for 25 seconds
echo "Connect to the Proxmox admin web interface at https://"
sleep 25

# Create a Linux Bridge called vmbr0 and add the first network interface to it
# Assuming ens3 is the first network interface, change it accordingly
echo "Creating Linux Bridge vmbr0..."
sleep 5
echo "iface vmbr0 inet static" >> /etc/network/interfaces
echo "    address 192.168.1.2" >> /etc/network/interfaces
echo "    netmask 255.255.255.0" >> /etc/network/interfaces
echo "    gateway 192.168.1.1" >> /etc/network/interfaces
echo "    bridge_ports ens3" >> /etc/network/interfaces

# Restart networking
systemctl restart networking

echo "Proxmox installation completed successfully!"
