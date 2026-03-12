# NCAE Cyber Games 2026 — Competition Day Guide

**Team Toolkit | March 2026**

---

## 🚀 Quick Start

```bash
# Copy scripts to each VM
sudo mkdir -p /opt/ncae
sudo cp -r * /opt/ncae/
cd /opt/ncae
sudo chmod +x *.sh

# Run deploy_all on each VM (auto-detects role)
sudo ./deploy_all.sh

# Monitor starts automatically in tmux
# Attach: tmux attach -t ncae_monitor
# Detach: Ctrl+B then D
```

---

## 📋 VM Reference

| VM | IP | Script | Points |
|---|---|---|---|
| Web Server | 192.168.t.5 | harden_www.sh | 3500 |
| PostgreSQL | 192.168.t.7 | harden_db.sh | 2000 |
| DNS | 192.168.t.12 | harden_dns.sh | 2000 |
| SSH/SMB | 172.18.14.t | harden_shell_smb.sh | 3500 |
| Backup | 192.168.t.15 | harden_backup.sh | 0 |
| Router | 172.18.13.t | harden_router.sh | 500 |

**Total Points: 11,500**

---

## 📦 Complete Script List

### Core Deployment (6 scripts)
1. **`deploy_all.sh`** - Master orchestration, auto-detects VM role
2. **`harden_www.sh`** - Apache2 + SSL + security headers
3. **`harden_dns.sh`** - BIND + forward/reverse zones
4. **`harden_db.sh`** - PostgreSQL + SCRAM-SHA-256
5. **`harden_shell_smb.sh`** - SSH + Samba + SELinux
6. **`harden_backup.sh`** - Backup server + immutable files

### Utilities (9 scripts)
7. **`00_recon.sh`** - Pre-hardening reconnaissance  
8. **`monitor.sh`** - Continuous monitoring (runs in tmux)
9. **`backup_configs.sh`** - Auto-backup every 5 min
10. **`backdoor_hunt.sh`** - Scan for persistence
11. **`incident_response.sh`** - Interactive IR menu
12. **`score_check.sh`** - ⭐ **Quick scoring verification**
13. **`install_deps.sh`** - Install required packages
14. **`harden_router.sh`** - MikroTik configuration
15. **`ssh_harden.sh`** - Standalone SSH hardening

---

## 🎯 Competition Timeline

### **Before 10:00 AM**
- [ ] Copy scripts to all VMs
- [ ] Run `./install_deps.sh` (installs curl, wget, ufw, fail2ban, auditd)
- [ ] Run `./deploy_all.sh` on every VM
- [ ] Verify monitor running: `tmux attach -t ncae_monitor`
- [ ] Confirm backups working: `ls /srv/ncae_backups/`

### **At 10:30 AM (Scoreboard opens)**
- [ ] Submit free CTF flag: `c2ctf{welcomeToTheCyberGames!}`
- [ ] Check exact SMB share names on scoreboard
- [ ] Add scoring SSH pubkey to shell VM: `/home/scoring/.ssh/authorized_keys`
- [ ] Get CA cert from `172.18.0.38`, replace self-signed on web server
- [ ] Add router port forwards for external DNS

### **During Competition**
- [ ] **Run `./score_check.sh` every 15 min** - Quick verification of all services
- [ ] Check alerts every 15 min: `tail -f /var/log/ncae_alerts.log`
- [ ] Run `./backdoor_hunt.sh` every 30 min
- [ ] Backups run automatically (verify occasionally)
- [ ] Monitor service watchdogs in cron

### **If Compromised**
1. Run `./incident_response.sh`
2. Kill attacker connections (option 1)
3. Hunt reverse shells (option 2)
4. Remove web shells (option 3)
5. Restore from backup (option 7)
6. Re-harden (option 6)

---

## 🔐 Default Credentials

**⚠️ ALL credentials saved to `/root/ncae_credentials_<role>.txt`**

View with:
```bash
sudo cat /root/ncae_credentials_www.txt
sudo cat /root/ncae_credentials_dns.txt
sudo cat /root/ncae_credentials_db.txt
sudo cat /root/ncae_credentials_shell.txt
```

**Router:**
- User: `admin`
- Pass: Auto-generated (see `/root/ncae_credentials_router.txt`)

**SSH/SMB Scoring User:**
- User: `scoring`
- Pass: Set during `harden_shell_smb.sh` (see credentials file)

**PostgreSQL:**
- User: `scoring`
- Pass: Set during `harden_db.sh` (see credentials file)
- Database: `scoringdb`

---

## 📖 Script Walkthroughs

### **00_recon.sh**
**Run FIRST on every VM**

```bash
sudo ./00_recon.sh
```

Captures:
- Open ports & listening services
- User accounts & SSH keys
- Cron jobs
- SUID binaries
- Web root contents
- Firewall status
- Active connections

Output saved to: `/vagrant/logs/ncae_recon_*.log`

---

### **deploy_all.sh**
**Master deployment - auto-detects VM role**

```bash
sudo ./deploy_all.sh
```

Runs in sequence:
1. `00_recon.sh` - Baseline snapshot
2. Appropriate `harden_*.sh` for detected role
3. `monitor.sh` - Starts in tmux
4. `backup_configs.sh` - Initial backup

Auto-detection based on IP:
- `192.168.t.5` → Web Server
- `192.168.t.7` → PostgreSQL
- `192.168.t.12` → DNS
- `172.18.14.t` → SSH/SMB
- `192.168.t.15` → Backup

---

### **harden_www.sh** (3500 points)
**Ubuntu 24.04 - Apache2 + SSL**

```bash
sudo ./harden_www.sh
```

Features:
- Apache2 with security headers (X-Frame-Options, CSP, HSTS)
- SSL with self-signed placeholder cert
- HTTP → HTTPS redirect
- fail2ban for brute force protection
- auditd monitoring
- CISA 14+ character passwords
- UFW firewall
- Service watchdog cron

**Scoring:**
```bash
# HTTP (500pts)
curl -I http://192.168.t.5

# HTTPS (1500pts)
curl -Ik https://192.168.t.5

# Content (1500pts)
curl -sk https://192.168.t.5 | grep '<title>'
```

**At 10:30 AM - Replace self-signed cert:**
1. Get CSR: `/etc/ssl/ncace/certs/server.csr`
2. Submit to CA at `172.18.0.38`
3. Get signed cert back
4. Install: `cp signed.crt /etc/ssl/ncace/certs/server.crt`
5. Restart: `systemctl restart apache2`

---

### **harden_dns.sh** (2000 points)
**Rocky Linux 9 - BIND**

```bash
sudo ./harden_dns.sh
```

Features:
- Forward zone: `team<t>.local`
- Reverse zone: `<t>.168.192.in-addr.arpa`
- Records: www, dns, db, router, backup
- Recursion limited to internal LAN
- Rate limiting (anti-DDoS)
- firewalld configuration
- Zone validation

**Scoring:**
```bash
# Internal Forward (500pts)
dig @192.168.t.12 www.team<t>.local

# Internal Reverse (500pts)
dig @192.168.t.12 -x 192.168.t.5

# External Forward (500pts) - requires router port forward
dig @172.18.13.t www.team<t>.local

# External Reverse (500pts) - requires router port forward
dig @172.18.13.t -x 192.168.t.5
```

**Router Port Forwards Required:**
```
# On MikroTik router:
/ip firewall nat add chain=dstnat in-interface=ether1 dst-port=53 protocol=tcp \
    action=dst-nat to-addresses=192.168.t.12 to-ports=53
/ip firewall nat add chain=dstnat in-interface=ether1 dst-port=53 protocol=udp \
    action=dst-nat to-addresses=192.168.t.12 to-ports=53
```

---

### **harden_db.sh** (2000 points)
**Ubuntu 24.04 - PostgreSQL**

```bash
sudo ./harden_db.sh
```

Features:
- PostgreSQL with SCRAM-SHA-256 auth
- Scoring database `scoringdb`
- Scoring user `scoring`
- Internal LAN access only
- pg_hba.conf properly configured
- UFW firewall
- .pgpass file for testing

**Scoring:**
```bash
# Test connection (500pts)
psql -h 192.168.t.7 -U scoring -d scoringdb -c "SELECT NOW();"

# Password in:
cat /root/ncae_credentials_db.txt
```

---

### **harden_shell_smb.sh** (3500 points)
**Rocky Linux 9 - SSH + Samba**

```bash
# Set scoring password via env var:
NCAE_SCORING_PASS='YourPassword123!' sudo ./harden_shell_smb.sh

# Or run and enter when prompted:
sudo ./harden_shell_smb.sh
```

Features:
- SSH hardening
- Samba with SELinux contexts
- Read and write shares
- firewalld configuration
- Scoring user creation

**Scoring:**
```bash
# SMB Login (500pts)
smbclient -L //172.18.14.t -U scoring

# SMB Write (1000pts)
smbclient //172.18.14.t/write -U scoring -c 'put /etc/hostname test.txt'

# SMB Read (1000pts)
smbclient //172.18.14.t/read -U scoring -c 'get readme.txt /tmp/out.txt'

# SSH (1000pts) - requires scoring pubkey
ssh scoring@172.18.14.t
```

**At 10:30 AM - Add scoring SSH pubkey:**
```bash
# Get pubkey from competition platform, then:
echo '<PUBKEY>' >> /home/scoring/.ssh/authorized_keys

# Lock SSH to key-only:
sudo /root/ncae_lock_ssh.sh
```

---

### **monitor.sh**
**Continuous monitoring in tmux**

Auto-started by `deploy_all.sh`

```bash
# Attach to monitor:
tmux attach -t ncae_monitor

# Detach: Ctrl+B then D
```

Monitors:
- Service status (auto-restart if down)
- New SUID binaries (every 10 min)
- Web root integrity (every 5 min)
- Suspicious connections (every 30 sec)
- New cron jobs (every 5 min)

Alerts logged to: `/var/log/ncae_alerts.log`

---

### **backup_configs.sh**
**Auto-backup every 5 minutes**

```bash
sudo ./backup_configs.sh
```

Backs up:
- `/etc/ssh`, `/etc/apache2`, `/etc/bind`, `/etc/samba`
- `/var/www/html`, pg_hba.conf, SSL certs
- Users, groups, cron jobs

Local: `/root/ncae_config_backups/`  
Remote: `192.168.t.15:/srv/ncae_backups/`

**Restore:**
```bash
# List backups:
ls /root/ncae_config_backups/

# Restore example:
cp /root/ncae_config_backups/<timestamp>/smb.conf /etc/samba/
systemctl restart smb
```

---

### **backdoor_hunt.sh**
**Scan for persistence**

```bash
sudo ./backdoor_hunt.sh
```

Scans:
- Recently modified files in /root
- SSH authorized_keys
- Cron jobs
- Systemd services & timers
- PAM modules
- SUID binaries
- Temp executables (/tmp, /var/tmp, /dev/shm)
- Kernel modules
- Web shells
- Sudoers NOPASSWD entries
- Unusual listening ports

---

### **incident_response.sh**
**Interactive IR menu**

```bash
sudo ./incident_response.sh
```

Options:
1. Kill suspicious connections / block IP
2. Hunt & kill reverse shells
3. Remove web shells
4. Purge unauthorized SSH keys
5. Purge unauthorized cron jobs
6. Force re-harden
7. Restore config from backup
8. Emergency restart all services
9. Status snapshot

---

### **score_check.sh** ⭐
**Quick scoring verification - Run every 15 minutes!**

```bash
sudo ./score_check.sh
```

Checks:
- HTTP (500pts)
- HTTPS (1500pts) + cert validation
- WWW Content (1500pts)
- DNS Internal Forward (500pts)
- DNS Internal Reverse (500pts)
- PostgreSQL (500pts)
- SMB Login (500pts)
- SSH scoring key (1000pts)
- All local services running

**Example Output:**
```
[✔] HTTP responding on 192.168.5.5:80 (500pts)
[✔] HTTPS responding on 192.168.5.5:443 (1500pts)
[?] Cert may be self-signed — replace with CA cert
[✔] WWW content present — <title>Team 5</title> (1500pts)
[✔] DNS INT FWD: www.team5.local resolves (500pts)
[✔] DNS INT REV: 192.168.5.5 reverse resolves (500pts)
[✔] PostgreSQL accepting connections (500pts)
[✔] apache2 running
[✗] smb DOWN
```

**This is your dashboard - run it constantly during competition!**

---

### **install_deps.sh**
**Quick dependency installer**

```bash
sudo ./install_deps.sh
```

Installs:
- curl, wget, git, vim
- ufw (firewall)
- fail2ban (brute force protection)
- auditd (file integrity monitoring)
- net-tools (networking utilities)

**Run on every VM BEFORE deploy_all.sh**

---

## 🎯 Scoring Checklist

| Service | Points | Verify |
|---|---|---|
| WWW HTTP | 500 | `curl -I http://192.168.t.5` |
| WWW HTTPS | 1500 | `curl -Ik https://192.168.t.5` |
| WWW Content | 1500 | `curl -sk https://192.168.t.5 \| grep title` |
| DNS Int Fwd | 500 | `dig @192.168.t.12 www.team<t>.local` |
| DNS Int Rev | 500 | `dig @192.168.t.12 -x 192.168.t.5` |
| DNS Ext Fwd | 500 | `dig @172.18.13.t www.team<t>.local` |
| DNS Ext Rev | 500 | `dig @172.18.13.t -x 192.168.t.5` |
| SSH Login | 1000 | Scoring pubkey in authorized_keys |
| SMB Login | 500 | `smbclient -L //172.18.14.t -U scoring` |
| SMB Write | 1000 | `smbclient //172.18.14.t/write ...` |
| SMB Read | 1000 | `smbclient //172.18.14.t/read ...` |
| DB SSH | 1000 | Scoring pubkey in authorized_keys |
| DB Access | 1000 | Scoring engine connects to PostgreSQL |
| **TOTAL** | **11000** | |

---

## 🚨 Emergency Commands

```bash
# Quick scoring check
sudo ./score_check.sh

# Restart all services
sudo ./incident_response.sh  # Option 8

# Block IP immediately
sudo ufw deny from <IP>                    # Ubuntu
sudo firewall-cmd --add-rich-rule="rule family='ipv4' source address='<IP>' reject" --permanent && sudo firewall-cmd --reload  # Rocky

# Check listening ports
ss -tulpn

# Check who's logged in
w
last | head -20

# Kill process
sudo kill -9 <PID>

# Check auth failures
grep "Failed password" /var/log/auth.log | tail -20  # Ubuntu
grep "Failed password" /var/log/secure | tail -20    # Rocky

# Reload DNS
sudo rndc reload

# Restart SMB
sudo systemctl restart smb nmb

# Check Apache config
sudo apache2ctl configtest

# Check named config
sudo named-checkconf
```

---

## 💡 Pro Tips

1. **Run `./score_check.sh` every 15 min** - Your scoring dashboard
2. **Always run `00_recon.sh` first** - Baseline before changes
3. **Monitor tmux session** - Detach with Ctrl+B then D
4. **Backups every 5 min** - Check `/srv/ncae_backups/` occasionally
5. **Hunt backdoors every 30 min** - `./backdoor_hunt.sh`
6. **Check alerts regularly** - `tail -f /var/log/ncae_alerts.log`
7. **SSL certs at 10:30 AM** - Replace self-signed immediately
8. **Router port forwards** - Required for external DNS scoring
9. **Scoring SSH keys** - Add at 10:30 AM for shell/db VMs
10. **Service watchdogs** - Auto-restart in cron every minute
11. **Credentials locked** - All in `/root/ncae_credentials_*.txt` (chmod 600)

---

**Built for NCAE Cyber Games 2026 | Deploy smarter, not harder. 🏆**
