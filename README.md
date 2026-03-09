# 🛡️ NCAE Cyber Games 2026 Toolkit

**Comprehensive defense automation for NCAE Cyber Games 2026 Regional Competition**

---

## ⚡ Quick Start - 8 Minute Deployment

### **Step 1: Configure Networks (2 minutes)**

On each VM via noVNC, paste the appropriate network config from `network-configs/`:

| VM | Config File | Size |
|----|-------------|------|
| Web Server | `network-web.sh` | 428 bytes |
| Database | `network-db.sh` | 424 bytes |
| DNS | `network-dns.sh` | 488 bytes |
| Shell/SMB | `network-shell.sh` | 483 bytes |
| Backup | `network-backup.sh` | 422 bytes |

### **Step 2: Download & Distribute from Shell/SMB (6 minutes)**

On Shell/SMB VM (172.18.14.5), run:

```bash
#!/bin/bash
TEAM=5  # Change to your team number
GITHUB="https://github.com/noahkelly2024/MU_NCAE.git"

# Download toolkit
cd /tmp && git clone --depth 1 "$GITHUB" ncae-toolkit

# Deploy locally on Shell/SMB
mkdir -p /opt/ncae && cp -r /tmp/ncae-toolkit/* /opt/ncae/
cd /opt/ncae && chmod +x *.sh && ./install_deps.sh && ./deploy_all.sh &

# Distribute to all VMs
VMS=("192.168.${TEAM}.5:Web" "192.168.${TEAM}.7:DB" "192.168.${TEAM}.12:DNS" "192.168.${TEAM}.15:Backup")

for vm_entry in "${VMS[@]}"; do
    IFS=':' read -r vm_ip vm_name <<< "$vm_entry"
    echo "→ ${vm_name} (${vm_ip})..."
    ssh -o StrictHostKeyChecking=no root@"$vm_ip" "mkdir -p /opt/ncae" && \
    scp -o StrictHostKeyChecking=no -r /tmp/ncae-toolkit/* root@"$vm_ip":/opt/ncae/ && \
    ssh -o StrictHostKeyChecking=no root@"$vm_ip" "cd /opt/ncae && chmod +x *.sh && ./install_deps.sh && ./deploy_all.sh" &
done

wait
echo "🎉 ALL VMS DEPLOYED!"
```

**Done! All 5 VMs deployed in ~8 minutes.**

---

## 📦 What's Included

### **Core Deployment Scripts (15 scripts)**

| Script | Description | Target |
|--------|-------------|--------|
| `deploy_all.sh` | Master orchestrator - auto-detects VM role | All VMs |
| `harden_www.sh` | Apache2 + SSL + security headers | Web Server |
| `harden_dns.sh` | BIND with forward/reverse zones | DNS |
| `harden_db.sh` | PostgreSQL SCRAM-SHA-256 | Database |
| `harden_shell_smb.sh` | SSH + Samba + SELinux | Shell/SMB |
| `harden_backup.sh` | Backup server + immutable protection | Backup |
| `harden_router.sh` | MikroTik config generator | Router |
| `00_recon.sh` | Pre-hardening reconnaissance | All VMs |
| `monitor.sh` | Continuous monitoring in tmux | All VMs |
| `backup_configs.sh` | Auto-backup every 5 minutes | All VMs |
| `backdoor_hunt.sh` | Scan for persistence mechanisms | All VMs |
| `incident_response.sh` | Interactive IR menu | All VMs |
| `score_check.sh` | Quick scoring verification | All VMs |
| `install_deps.sh` | Install required packages | All VMs |
| `ssh_harden.sh` | Standalone SSH hardening | All VMs |

### **Network Configuration Scripts**

Pre-built network configs for each VM (400-500 bytes each):
- `network-configs/network-web.sh` - Web Server (192.168.5.5)
- `network-configs/network-db.sh` - Database (192.168.5.7)
- `network-configs/network-dns.sh` - DNS (192.168.5.12)
- `network-configs/network-shell.sh` - Shell/SMB (172.18.14.5)
- `network-configs/network-backup.sh` - Backup (192.168.5.15)
- `network-configs/distribute-from-shell.sh` - Complete distribution script

### **Interactive HTML Playbook**

`ncae-playbook.html` - Open in browser for:
- ✅ Team number auto-update (changes all IPs)
- ✅ System-specific deployment guides
- ✅ Copy/paste network configs
- ✅ Competition timeline
- ✅ Scoring reference
- ✅ Mobile responsive

---

## 🎯 Points Breakdown

| Service | Points | VM |
|---------|--------|----|
| HTTP | 500 | Web Server |
| HTTPS | 1500 | Web Server |
| WWW Content | 1500 | Web Server |
| DNS Internal Fwd | 500 | DNS |
| DNS Internal Rev | 500 | DNS |
| DNS External Fwd | 500 | DNS |
| DNS External Rev | 500 | DNS |
| SSH Login | 1000 | Shell/SMB |
| SMB Login | 500 | Shell/SMB |
| SMB Write | 1000 | Shell/SMB |
| SMB Read | 1000 | Shell/SMB |
| PostgreSQL | 2000 | Database |
| Router ICMP | 500 | Router |
| **TOTAL** | **11,500** | |

---

## 🗺️ Network Topology

**External LAN:** 172.18.0.0/16
- Competition Router: 172.18.0.1
- DNS: 172.18.0.12
- Blue Team Jumphost: 172.18.12.15:2213
- CA: 172.18.0.38
- **Shell/SMB:** 172.18.14.5 ← Has internet immediately!
- Team Router (external): 172.18.13.5

**Internal LAN:** 192.168.5.0/24 (team 5 example)
- Team Router (internal): 192.168.5.1
- Web Server: 192.168.5.5
- Database: 192.168.5.7
- DNS: 192.168.5.12
- Backup: 192.168.5.15

---

## 📋 Team Assignments

- **Web Server:** Gabe & Noah K
- **Router:** Noah K
- **DNS:** Nick
- **SSH/SMB:** Jonah & Drew
- **PostgreSQL:** Noah E
- **Backup:** Gabe
- **CTFs/Floater:** Zach, Alex, Sebastian

---

## 🔑 Default Credentials

**VMs:**
- ubuntu / webserver (Web Server)
- database / database (Database)
- rocky / rocky (DNS, Shell/SMB)
- kali / backup (Backup)

**Router:**
- admin / CantGuessThis67!

**Scoring:**
- scorer / ScorePassword123! (SSH/SMB)
- scoring / StrongPassword123! (PostgreSQL)

---

## 🚀 Why This Toolkit?

### **Shell/SMB Distribution Hub**
- ✅ Shell/SMB is on **external LAN** - has internet from minute 1
- ✅ Download toolkit **once**, distribute to all VMs via SCP
- ✅ No repeated GitHub clones, no router dependency
- ✅ **Fastest deployment method**

### **Battle-Tested Scripts**
- ✅ Based on NightHax v5 (proven in competition)
- ✅ Auto-detection of VM roles
- ✅ Comprehensive hardening
- ✅ Continuous monitoring

### **Tiny Network Configs**
- ✅ Only 400-500 bytes each
- ✅ Works in ANY noVNC paste buffer
- ✅ Plain bash - no encoding, no dependencies

---

## 📚 Documentation

- **COMPETITION_GUIDE.md** - Complete competition day guide
- **SHELL_DISTRIBUTION_GUIDE.md** - Detailed Shell/SMB distribution guide
- **docs/BOOTSTRAP_GUIDE.md** - Alternative bootstrap method
- **docs/PLAYBOOK_GUIDE.md** - HTML playbook features
- **docs/SCRIPT_ANALYSIS.md** - Script design decisions

---

## 🛠️ Advanced Usage

### **Manual Deployment (if Shell/SMB unavailable)**

```bash
# On each VM individually
git clone https://github.com/noahkelly2024/MU_NCAE.git /opt/ncae
cd /opt/ncae
chmod +x *.sh
./install_deps.sh
./deploy_all.sh
```

### **Bootstrap Scripts (offline deployment)**

See `docs/BOOTSTRAP_GUIDE.md` for self-contained bootstrap scripts that embed all toolkit scripts via base64. Useful if GitHub is unavailable.

---

## ⚙️ Key Features

### **Automatic Service Restart**
- Monitors running every second in tmux
- Auto-restarts Apache2, named, postgresql, smb, sshd
- Alerts logged to `/var/log/ncae_alerts.log`

### **Automated Backups**
- Every 5 minutes to backup VM
- SSH key-based authentication
- Last 12 backups retained per VM
- Immutable flag protection

### **Scoring Verification**
```bash
/opt/ncae/score_check.sh
```
Color-coded dashboard showing all service statuses.

### **Incident Response**
```bash
/opt/ncae/incident_response.sh
```
Interactive menu with 9 IR options:
1. Block IP address
2. Kill reverse shells
3. Remove web shells
4. Purge SSH keys
5. Purge cron jobs
6. Re-harden system
7. Restore from backup
8. Emergency restart
9. System status snapshot

---

## 🏆 Competition Day Checklist

### **Pre-Competition:**
- [ ] Clone this repo
- [ ] Review `ncae-playbook.html` in browser
- [ ] Update team number in network configs
- [ ] Review `COMPETITION_GUIDE.md`

### **9:00 AM - Access Granted:**
- [ ] Open all 5 VMs via noVNC
- [ ] Paste network configs (network-configs/*.sh)
- [ ] Verify IPs: `ip addr show`

### **9:05 AM - Deploy:**
- [ ] On Shell/SMB: Paste distribution script
- [ ] Wait for "ALL VMS DEPLOYED!" (~6 minutes)

### **9:12 AM - Verify:**
- [ ] Run `score_check.sh` on each VM
- [ ] Check monitors: `tmux attach -t ncae_monitor`
- [ ] Configure router: `./harden_router.sh`

### **10:00 AM - Scoring Begins:**
- [ ] All systems ready! ✅

---

## 🔧 Troubleshooting

### **"SSH connection refused" during distribution**
```bash
# On the VM, check if network is configured
ip addr show
# Should see: 192.168.5.X
```

### **"git clone failed" on Shell/SMB**
```bash
# Check internet connectivity
ping -c2 8.8.8.8
```

### **"Service not starting"**
```bash
# Check monitor
tmux attach -t ncae_monitor

# Check logs
tail -f /var/log/ncae_alerts.log

# Manual restart
systemctl restart apache2  # or named, postgresql, etc.
```

---

## 📞 Support

For issues or questions:
1. Check `COMPETITION_GUIDE.md`
2. Check `SHELL_DISTRIBUTION_GUIDE.md`
3. Open HTML playbook for system-specific guides

---

## 📜 License

Created for NCAE Cyber Games 2026 Regional Competition.

---

## 🎉 Credits

- **NightHax v5** scripts (battle-tested foundation)
- **Team Members:** Gabe, Noah K, Nick, Jonah, Drew, Noah E, Zach, Alex, Sebastian

---

**Good luck in the competition! 🏆**
