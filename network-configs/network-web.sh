#!/bin/bash
# Web Server - Network Config Only
TEAM=5
cat > /etc/netplan/01-netcfg.yaml << EOF
network:
  version: 2
  ethernets:
    ens18:
      addresses: [192.168.${TEAM}.5/24]
      routes: [{to: default, via: 192.168.${TEAM}.1}]
      nameservers: {addresses: [8.8.8.8]}
EOF
chmod 600 /etc/netplan/01-netcfg.yaml
netplan apply
echo "✅ Web Server network configured: 192.168.${TEAM}.5"
ip addr show | grep "inet 192.168"
