#!/bin/bash
# Shell/SMB - Network Config Only (External LAN)
TEAM=5
nmcli con mod "System eth0" ipv4.addresses 172.18.14.${TEAM}/16 ipv4.gateway 172.18.0.1 ipv4.dns "8.8.8.8" ipv4.method manual 2>/dev/null || \
nmcli con mod ens18 ipv4.addresses 172.18.14.${TEAM}/16 ipv4.gateway 172.18.0.1 ipv4.dns "8.8.8.8" ipv4.method manual
nmcli con up "System eth0" 2>/dev/null || nmcli con up ens18
echo "✅ Shell/SMB network configured: 172.18.14.${TEAM}"
ip addr show | grep "inet 172.18"
