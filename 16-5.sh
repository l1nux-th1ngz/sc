#!/bin/bash

# Install Proxmox VE, postfix, open-iscsi, and chrony
apt install proxmox-ve postfix open-iscsi chrony

# Update grub
update-grub

# Remove os-prober
apt remove os-prober

# Connect to the admin web interface
echo "Please connect to the admin web interface at https://<your-ip-address>:8006"
sleep 25

# Create a Linux Bridge called vmbr0 and add your first network interface to it
# Replace eth0 with your network interface name
echo "auto vmbr0
iface vmbr0 inet static
    address  <your-ip-address>
    netmask  <your-netmask>
    gateway  <your-gateway>
    bridge_ports eth0
    bridge_stp off
    bridge_fd 0" >> /etc/network/interfaces
