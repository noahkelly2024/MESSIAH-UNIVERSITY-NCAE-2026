#!/bin/bash
# DNS - Network Config Only (Rocky Linux)
TEAM=11
nmcli con mod "System eth0" ipv4.addresses 192.168.${TEAM}.12/24 ipv4.gateway 192.168.${TEAM}.1 ipv4.dns "8.8.8.8" ipv4.method manual 2>/dev/null || \
nmcli con mod ens18 ipv4.addresses 192.168.${TEAM}.12/24 ipv4.gateway 192.168.${TEAM}.1 ipv4.dns "8.8.8.8" ipv4.method manual
nmcli con up "System eth0" 2>/dev/null || nmcli con up ens18
echo "✅ DNS network configured: 192.168.${TEAM}.12"
ip addr show | grep "inet 192.168"
