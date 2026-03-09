# 🚀 **One-Script-Per-VM Bootstrap Guide**

## ✨ **What This Is**

**5 self-contained bootstrap scripts** - one per VM. Each script:
- ✅ Configures networking
- ✅ Contains ALL 15 toolkit scripts embedded (base64 encoded)
- ✅ Generates scripts locally (no GitHub needed!)
- ✅ Runs full deployment automatically

**Perfect for noVNC paste!**

---

## 📦 **Files Generated**

```
bootstrap-scripts/
├── bootstrap-web.sh      (202 KB) - Web Server
├── bootstrap-db.sh       (202 KB) - Database  
├── bootstrap-dns.sh      (202 KB) - DNS Server
├── bootstrap-shell.sh    (202 KB) - Shell/SMB
└── bootstrap-backup.sh   (202 KB) - Backup Server
```

Each script is **~200 KB** - contains everything!

---

## 🎯 **How to Use (Competition Day)**

### **For Each VM:**

1. **Open VM via Proxmox noVNC**
2. **Copy the appropriate bootstrap script** (open .sh file, Ctrl+A, Ctrl+C)
3. **Paste into VM terminal:**
   ```bash
   cat > /tmp/bootstrap.sh
   [Ctrl+V to paste the script]
   [Ctrl+D to save]
   ```
4. **Run it:**
   ```bash
   bash /tmp/bootstrap.sh
   ```
5. **Done!** Script will:
   - Configure network
   - Generate all toolkit scripts
   - Run full deployment
   - Start monitor in tmux

---

## 📋 **Competition Day Checklist**

### **9:00 AM - VM Setup (15 minutes)**

**✅ Web Server (192.168.5.5)**
```bash
# Via noVNC:
cat > /tmp/bootstrap.sh
[Paste bootstrap-web.sh contents]
[Ctrl+D]
bash /tmp/bootstrap.sh
```

**✅ Database (192.168.5.7)**
```bash
# Via noVNC:
cat > /tmp/bootstrap.sh
[Paste bootstrap-db.sh contents]
[Ctrl+D]
bash /tmp/bootstrap.sh
```

**✅ DNS (192.168.5.12)**
```bash
# Via noVNC:
cat > /tmp/bootstrap.sh
[Paste bootstrap-dns.sh contents]
[Ctrl+D]
bash /tmp/bootstrap.sh
```

**✅ Shell/SMB (172.18.14.5)**
```bash
# Via noVNC:
cat > /tmp/bootstrap.sh
[Paste bootstrap-shell.sh contents]
[Ctrl+D]
bash /tmp/bootstrap.sh
```

**✅ Backup (192.168.5.15)**
```bash
# Via noVNC:
cat > /tmp/bootstrap.sh
[Paste bootstrap-backup.sh contents]
[Ctrl+D]
bash /tmp/bootstrap.sh
```

---

## ⚡ **What Each Script Does**

### **Step 1: Network Configuration** (10 seconds)

**Ubuntu VMs (Web, DB, Backup):**
```yaml
# Creates /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    ens18:
      addresses: [192.168.5.X/24]
      routes: [{to: default, via: 192.168.5.1}]
      nameservers: {addresses: [8.8.8.8]}
```

**Rocky VMs (DNS, Shell):**
```bash
# Uses nmcli
nmcli con mod "System eth0" ipv4.addresses 192.168.5.X/24
nmcli con mod "System eth0" ipv4.gateway 192.168.5.1
nmcli con mod "System eth0" ipv4.method manual
nmcli con up "System eth0"
```

### **Step 2: Generate Toolkit Scripts** (5 seconds)

Creates in `/opt/ncae/`:
- deploy_all.sh
- 00_recon.sh
- monitor.sh
- backup_configs.sh
- backdoor_hunt.sh
- incident_response.sh
- score_check.sh
- install_deps.sh
- harden_www.sh
- harden_dns.sh
- harden_db.sh
- harden_shell_smb.sh
- harden_backup.sh
- harden_router.sh
- ssh_harden.sh

**All scripts are extracted from base64 embedded in bootstrap script!**

### **Step 3: Run Deployment** (2-5 minutes)

```bash
./install_deps.sh     # Install packages
./deploy_all.sh       # Auto-detect role & harden
```

---

## 🔄 **Regenerating for Different Team Number**

If your team number changes:

```bash
# Regenerate all bootstrap scripts
bash generate-bootstrap-scripts.sh 7

# New scripts in bootstrap-scripts/ for team 7
```

---

## 📊 **Timeline**

| VM | Paste Time | Deploy Time | Total |
|----|------------|-------------|-------|
| Web Server | 1 min | 3 min | **4 min** |
| Database | 1 min | 3 min | **4 min** |
| DNS | 1 min | 3 min | **4 min** |
| Shell/SMB | 1 min | 3 min | **4 min** |
| Backup | 1 min | 2 min | **3 min** |

**If done in parallel (5 noVNC windows open):**
- **Total time: ~5-7 minutes for ALL 5 VMs!** ⚡

---

## 💡 **Pro Tips**

### **1. Open All noVNC Windows First**

Open all 5 VM consoles in separate browser tabs **before** competition starts.

### **2. Have Scripts Ready in Notepad**

Before competition:
- Open all 5 bootstrap scripts in Notepad/VS Code
- Have them ready to copy

### **3. Paste in Parallel**

With 5 browser tabs open, paste into all VMs simultaneously:
1. Tab 1 (Web): Paste bootstrap-web.sh
2. Tab 2 (DB): Paste bootstrap-db.sh
3. Tab 3 (DNS): Paste bootstrap-dns.sh
4. Tab 4 (Shell): Paste bootstrap-shell.sh
5. Tab 5 (Backup): Paste bootstrap-backup.sh

Then run `bash /tmp/bootstrap.sh` in each.

### **4. Verify Each VM After Bootstrap**

```bash
# Check if scripts were generated
ls -l /opt/ncae/*.sh | wc -l
# Should show: 15

# Check if monitor is running
tmux ls
# Should show: ncae_monitor

# Check scoring status
/opt/ncae/score_check.sh
```

---

## 🚨 **If Paste Buffer Limits Hit**

Some noVNC implementations have paste buffer limits (~100KB). If you hit this:

### **Option 1: Split the Paste**

```bash
# First half
cat > /tmp/part1.txt
[Paste first 100KB]
[Ctrl+D]

# Second half
cat > /tmp/part2.txt
[Paste remaining]
[Ctrl+D]

# Combine
cat /tmp/part1.txt /tmp/part2.txt > /tmp/bootstrap.sh
bash /tmp/bootstrap.sh
```

### **Option 2: Upload to Proxmox Storage**

If Proxmox allows snippet uploads:
1. Upload bootstrap scripts to Proxmox storage
2. Each VM can access: `/mnt/pve/snippets/bootstrap-web.sh`

### **Option 3: Use Jumphost Distribution**

Fallback plan - paste ONE bootstrap script to jumphost, then SCP to VMs.

---

## ✅ **Advantages of This Method**

| Advantage | Benefit |
|-----------|---------|
| **No GitHub needed** | Works even if internet down |
| **No SSH needed initially** | Network configured by script |
| **Self-contained** | Everything embedded in one file |
| **Fast** | Parallel deployment in 5-7 min |
| **Simple** | Just paste & run |
| **Reliable** | No external dependencies |

---

## 🎯 **Competition Day Quick Reference**

```
╔═══════════════════════════════════════════════════════╗
║ BOOTSTRAP DEPLOYMENT - ONE SCRIPT PER VM             ║
╠═══════════════════════════════════════════════════════╣
║ 1. Open VM via noVNC                                 ║
║ 2. cat > /tmp/bootstrap.sh                           ║
║ 3. [Paste appropriate bootstrap script]             ║
║ 4. [Ctrl+D]                                          ║
║ 5. bash /tmp/bootstrap.sh                            ║
║ 6. Wait 3-5 minutes                                  ║
║ 7. Verify: /opt/ncae/score_check.sh                 ║
╚═══════════════════════════════════════════════════════╝

VM-to-Script Mapping:
  Web Server     → bootstrap-web.sh
  Database       → bootstrap-db.sh
  DNS Server     → bootstrap-dns.sh
  Shell/SMB      → bootstrap-shell.sh
  Backup Server  → bootstrap-backup.sh
```

---

## 🏆 **Why This is The Best Method**

### **Comparison with Other Methods:**

| Method | Internet Needed? | SSH Needed? | Time | Complexity |
|--------|------------------|-------------|------|------------|
| **Bootstrap Scripts** | ❌ No | ❌ No | 5-7 min | ⭐ Easy |
| GitHub Clone | ✅ Yes | ❌ No | 5 min | ⭐⭐ Medium |
| Jumphost SCP | ❌ No | ✅ Yes | 15 min | ⭐⭐⭐ Hard |
| Manual Scripts | ❌ No | ✅ Yes | 30 min | ⭐⭐⭐⭐ Very Hard |

**Bootstrap = Fastest + Most Reliable** 🚀

---

## 📝 **What's Embedded in Each Script**

Each 202KB bootstrap script contains:

```
Network configuration code
  +
Base64-encoded versions of:
  ├── deploy_all.sh (10 KB)
  ├── harden_www.sh (14 KB)
  ├── harden_dns.sh (13 KB)
  ├── harden_db.sh (13 KB)
  ├── harden_shell_smb.sh (15 KB)
  ├── harden_backup.sh (10 KB)
  ├── harden_router.sh (9 KB)
  ├── 00_recon.sh (7 KB)
  ├── monitor.sh (4 KB)
  ├── backup_configs.sh (8 KB)
  ├── backdoor_hunt.sh (18 KB)
  ├── incident_response.sh (16 KB)
  ├── score_check.sh (5 KB)
  ├── install_deps.sh (1 KB)
  └── ssh_harden.sh (1 KB)
  +
Deployment automation
```

**Everything you need in one paste!** 💪

---

**This is the ultimate competition day strategy - paste once, deploy everything, win! 🏆**
