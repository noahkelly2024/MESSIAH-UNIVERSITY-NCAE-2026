# 🛡️ NCAE Cyber Games 2026 Toolkit - Team 11

**Simple, fast deployment - each machine independently configured**

---

## ⚡ Quick Start (5 Minutes Per Machine)

### **Competition Day Flow:**

```
1. Access VM via noVNC
2. Paste network config
3. Git clone this repo
4. Run deploy_all.sh
5. Select machine type from menu (1-6)
6. Wait ~3-5 minutes
7. Done! ✅
```

---

## 📋 Step-by-Step Instructions

### **Step 1: Configure Network (30 seconds)**

Via noVNC console, copy and paste the appropriate network config:

#### **Web Server (192.168.11.5)**
```bash
cat > /tmp/net.sh << 'EOF'
#!/bin/bash
TEAM=11
cat > /etc/netplan/01-netcfg.yaml << YAML
network:
  version: 2
  ethernets:
    ens18:
      addresses: [192.168.${TEAM}.5/24]
      routes: [{to: default, via: 192.168.${TEAM}.1}]
      nameservers: {addresses: [8.8.8.8]}
YAML
chmod 600 /etc/netplan/01-netcfg.yaml
netplan apply
echo "✅ Web Server configured: 192.168.${TEAM}.5"
EOF

bash /tmp/net.sh
```

#### **Database (192.168.11.7)**
```bash
cat > /tmp/net.sh << 'EOF'
#!/bin/bash
TEAM=11
cat > /etc/netplan/01-netcfg.yaml << YAML
network:
  version: 2
  ethernets:
    ens18:
      addresses: [192.168.${TEAM}.7/24]
      routes: [{to: default, via: 192.168.${TEAM}.1}]
      nameservers: {addresses: [8.8.8.8]}
YAML
chmod 600 /etc/netplan/01-netcfg.yaml
netplan apply
echo "✅ Database configured: 192.168.${TEAM}.7"
EOF

bash /tmp/net.sh
```

#### **DNS Server (192.168.11.12)**
```bash
cat > /tmp/net.sh << 'EOF'
#!/bin/bash
TEAM=11
nmcli con mod "System eth0" ipv4.addresses 192.168.${TEAM}.12/24 ipv4.gateway 192.168.${TEAM}.1 ipv4.dns "8.8.8.8" ipv4.method manual 2>/dev/null || \
nmcli con mod ens18 ipv4.addresses 192.168.${TEAM}.12/24 ipv4.gateway 192.168.${TEAM}.1 ipv4.dns "8.8.8.8" ipv4.method manual
nmcli con up "System eth0" 2>/dev/null || nmcli con up ens18
echo "✅ DNS configured: 192.168.${TEAM}.12"
EOF

bash /tmp/net.sh
```

#### **Shell/SMB (172.18.14.11)**
```bash
cat > /tmp/net.sh << 'EOF'
#!/bin/bash
TEAM=11
nmcli con mod "System eth0" ipv4.addresses 172.18.14.${TEAM}/16 ipv4.gateway 172.18.0.1 ipv4.dns "8.8.8.8" ipv4.method manual 2>/dev/null || \
nmcli con mod ens18 ipv4.addresses 172.18.14.${TEAM}/16 ipv4.gateway 172.18.0.1 ipv4.dns "8.8.8.8" ipv4.method manual
nmcli con up "System eth0" 2>/dev/null || nmcli con up ens18
echo "✅ Shell/SMB configured: 172.18.14.${TEAM}"
EOF

bash /tmp/net.sh
```

#### **Backup (192.168.11.15)**
```bash
cat > /tmp/net.sh << 'EOF'
#!/bin/bash
TEAM=11
cat > /etc/netplan/01-netcfg.yaml << YAML
network:
  version: 2
  ethernets:
    ens18:
      addresses: [192.168.${TEAM}.15/24]
      routes: [{to: default, via: 192.168.${TEAM}.1}]
      nameservers: {addresses: [8.8.8.8]}
YAML
chmod 600 /etc/netplan/01-netcfg.yaml
netplan apply
echo "✅ Backup configured: 192.168.${TEAM}.15"
EOF

bash /tmp/net.sh
```

---

### **Step 2: Clone Repository (15 seconds)**

```bash
git clone --depth 1 https://github.com/noahkelly2024/MU_NCAE.git /opt/ncae
cd /opt/ncae
chmod +x *.sh
```

---

### **Step 3: Run Deployment (3-5 minutes)**

```bash
sudo ./deploy_all.sh
```

**Interactive Menu Will Appear:**
```
╔═══════════════════════════════════════════════════════╗
║         SELECT MACHINE TYPE FOR DEPLOYMENT           ║
╠═══════════════════════════════════════════════════════╣
║                                                       ║
║  1. Web Server    (192.168.11.5)   - Apache/HTTPS    ║
║  2. DNS Server    (192.168.11.12)  - BIND            ║
║  3. Database      (192.168.11.7)   - PostgreSQL      ║
║  4. Shell/SMB     (172.18.14.11)   - SSH + Samba     ║
║  5. Backup        (192.168.11.15)  - Storage         ║
║  6. Router        (172.18.13.11)   - MikroTik        ║
║                                                       ║
╚═══════════════════════════════════════════════════════╝

Enter machine number (1-6):
```

**Enter the appropriate number for your machine.**

**The script will automatically:**
- ✅ Install dependencies (curl, wget, ufw, fail2ban, etc.)
- ✅ Run reconnaissance report
- ✅ Execute appropriate hardening script
- ✅ Start continuous monitoring in tmux
- ✅ Configure automated backups

---

## 🎯 What Gets Deployed

### **Deployment Phases:**

```
Phase 1: Install Dependencies
  → curl, wget, git, vim, ufw, fail2ban, auditd, net-tools

Phase 2: Reconnaissance
  → System info, network, users, services, processes
  → Saved to: /vagrant/logs/ncae_recon_*.log

Phase 3: Hardening (based on machine type)
  → Machine-specific security configuration
  → Service setup and configuration
  → Firewall rules
  → Security headers, SELinux, etc.

Phase 4: Continuous Monitoring
  → Auto-restart services if they fail
  → Monitor running in tmux session
  → Alerts logged to /var/log/ncae_alerts.log

Phase 5: Automated Backups
  → Config backups every 5 minutes
  → Pushed to backup VM (192.168.11.15)
  → SSH key-based authentication

Phase 6: Script Protection
  → Immutable flags on all scripts
  → Prevents red team modification
```

---

## 🗺️ Network Topology - Team 11

**External LAN (172.18.0.0/16):**
- Competition Router: 172.18.0.1
- Shell/SMB: **172.18.14.11** ← External access
- Team Router (ext): 172.18.13.11

**Internal LAN (192.168.11.0/24):**
- Team Router (int): 192.168.11.1
- Web Server: **192.168.11.5**
- Database: **192.168.11.7**
- DNS: **192.168.11.12**
- Backup: **192.168.11.15**

---

## 📦 Included Scripts (15 Total)

### **Core Deployment:**
- `deploy_all.sh` - Interactive deployment orchestrator
- `install_deps.sh` - Install all required packages
- `harden_www.sh` - Web server (Apache/SSL)
- `harden_dns.sh` - DNS server (BIND)
- `harden_db.sh` - Database (PostgreSQL)
- `harden_shell_smb.sh` - Shell/SMB (SSH + Samba)
- `harden_backup.sh` - Backup server
- `harden_router.sh` - Router configuration generator

### **Utilities:**
- `00_recon.sh` - Pre-hardening reconnaissance
- `monitor.sh` - Continuous service monitoring
- `backup_configs.sh` - Automated config backups
- `backdoor_hunt.sh` - Persistence detection
- `incident_response.sh` - Interactive IR menu
- `score_check.sh` - Scoring verification dashboard
- `ssh_harden.sh` - SSH hardening

---

## 🎯 Points Breakdown (11,500 Total)

| Service | Points | Machine |
|---------|--------|---------|
| HTTP | 500 | Web |
| HTTPS | 1500 | Web |
| WWW Content | 1500 | Web |
| DNS Int Fwd | 500 | DNS |
| DNS Int Rev | 500 | DNS |
| DNS Ext Fwd | 500 | DNS |
| DNS Ext Rev | 500 | DNS |
| SSH Login | 1000 | Shell/SMB |
| SMB Login | 500 | Shell/SMB |
| SMB Write | 1000 | Shell/SMB |
| SMB Read | 1000 | Shell/SMB |
| PostgreSQL | 2000 | Database |
| Router ICMP | 500 | Router |

---

## 🔧 Post-Deployment Verification

### **Check Monitor:**
```bash
tmux attach -t ncae_monitor
# Press Ctrl+B, then D to detach
```

### **Check Alerts:**
```bash
tail -f /var/log/ncae_alerts.log
```

### **Verify Scoring:**
```bash
/opt/ncae/score_check.sh
```

### **View Credentials:**
```bash
cat /root/ncae_credentials_*.txt
```

---

## 🏆 Competition Timeline

### **9:00 AM - Access Granted**
- Open all 5 VMs via noVNC
- Paste network configs (30 sec each)
- Verify IPs: `ip addr show`

### **9:05 AM - Deploy (in parallel on all VMs)**
- Clone repo: `git clone https://github.com/noahkelly2024/MU_NCAE.git /opt/ncae`
- Run: `cd /opt/ncae && chmod +x *.sh && sudo ./deploy_all.sh`
- Select machine type from menu
- Wait 3-5 minutes per machine

### **9:15 AM - All Systems Deployed**
- Run `score_check.sh` on each VM
- Verify monitors running
- Check backups

### **10:00 AM - Scoring Begins**
- All services should be scoring! ✅

### **10:30 AM - Critical Actions**
- Submit CTF flag: `c2ctf{welcomeToTheCyberGames!}`
- Add scoring SSH pubkey to Shell/SMB
- Replace SSL cert from CA (172.18.0.38)
- Configure router port forwards

---

## 🔑 Default Credentials

**VMs:**
- ubuntu / webserver (Web, Database, Backup)
- rocky / rocky (DNS, Shell/SMB)

**Router:**
- admin / CantGuessThis67!

**Scoring:**
- scorer / ScorePassword123! (SSH/SMB)
- scoring / StrongPassword123! (PostgreSQL)

---

## 📚 Additional Documentation

- `COMPETITION_GUIDE.md` - Detailed competition workflow
- `network-configs/` - All network configuration scripts
- `ncae-playbook.html` - Interactive HTML playbook
- `docs/` - Extra guides and references

---

## 🛠️ Troubleshooting

### **"Git clone failed"**
```bash
# Check network
ping -c2 8.8.8.8

# Check DNS
nslookup github.com
```

### **"Service not starting"**
```bash
# Check specific service
systemctl status apache2  # or named, postgresql, smb

# Check logs
journalctl -xe -u apache2

# Manual restart
systemctl restart apache2
```

### **"Monitor not running"**
```bash
# Check if tmux is installed
which tmux

# Start monitor manually
cd /opt/ncae && ./monitor.sh
```

---

## 📞 Quick Commands Reference

```bash
# View monitor
tmux attach -t ncae_monitor

# Check alerts
tail -f /var/log/ncae_alerts.log

# Run incident response
/opt/ncae/incident_response.sh

# Verify scoring
/opt/ncae/score_check.sh

# Hunt for backdoors
/opt/ncae/backdoor_hunt.sh

# Manual backup
/opt/ncae/backup_configs.sh 192.168.11.15
```

---

## 🎉 Team Assignments

- **Web Server:** Gabe & Noah K
- **Router:** Noah K  
- **DNS:** Nick
- **Shell/SMB:** Jonah & Drew
- **Database:** Noah E
- **Backup:** Gabe
- **CTFs/Floater:** Zach, Alex, Sebastian

---

**Good luck! 🏆**

**Total deployment time: ~25 minutes for all 5 VMs in parallel**
