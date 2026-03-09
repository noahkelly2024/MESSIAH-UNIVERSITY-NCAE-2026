# 🎨 NEW NCAE Playbook - Navy & White Dark Theme

## ✨ What's New

Your HTML playbook has been **completely redesigned** with your school colors and comprehensive system coverage!

### 🎨 Visual Design
- **Color Scheme:** Navy blue (#001F3F, #003D7A, #0059B8) and white
- **Background:** Dark theme (#1a1a1a) for reduced eye strain during 6-hour competition
- **Accents:** Navy gradients, professional borders, modern shadows
- **Typography:** Clean, professional fonts with excellent readability

### 📑 Complete Tab Coverage (9 Tabs)

#### 1. **📋 Overview**
- Team assignments with names
- Quick start guide (10 minutes to full deployment)
- Scoring breakdown table (all 11,500 points)
- Critical 10:30 AM actions
- Emergency commands

#### 2. **🌐 Web Server** (3500 pts)
- VM info card with IP, services, points, assigned person
- Deployment instructions
- Scoring checklist
- Security features list
- SSL cert replacement walkthrough (collapsible)
- Common commands
- Credentials location

#### 3. **📡 DNS Server** (2000 pts)
- VM info card
- Forward & reverse zone configurations (collapsible)
- Router port forward requirements
- Testing commands
- Zone validation commands

#### 4. **💾 Database** (2000 pts)
- VM info card
- PostgreSQL configuration details
- pg_hba.conf example (collapsible)
- Connection testing
- Common troubleshooting commands

#### 5. **🖥️ SSH/SMB** (3500 pts)
- VM info card
- SSH scoring key setup (collapsible steps)
- SMB share configuration (collapsible)
- Testing commands for both services
- SELinux troubleshooting

#### 6. **💼 Backup** (0 pts, critical support)
- VM info card
- Backup storage structure
- Viewing backups
- Restore procedures (collapsible walkthrough)
- SSH key management

#### 7. **🔀 Router** (500 pts)
- External & internal IPs
- Deployment from Linux VM
- Port forwards table
- Manual application steps (collapsible)
- Verification commands

#### 8. **⚙️ Scripts**
- **15 script cards** organized by category
- Core deployment scripts (7 cards)
- Utility scripts (8 cards)
- Each card shows: name, description, badges (Essential/Points/Category)
- Download & setup instructions
- GitHub link placeholder for you to add

#### 9. **⏰ Timeline**
- **8 timeline events** from 9:00 AM to 4:30 PM
- Interactive checklists at each stage
- Color-coded alerts (success/warning/danger)
- Recurring tasks table

---

## 🎯 Interactive Features

### ✅ Team Number Auto-Update
- Input your team number (default: 5)
- Click "Update All IPs" button
- **ALL IP addresses update instantly** throughout entire playbook
- Examples:
  - `192.168.5.5` → `192.168.7.5` (if team 7)
  - `172.18.13.5` → `172.18.13.7`
  - `team5.local` → `team7.local`

### 📋 Interactive Checklists
- Click any checklist item to mark complete
- ☐ → ☑ (green checkmark)
- Completed items get strikethrough + opacity

### 📄 Collapsible Sections
- Click any collapsible header to expand/collapse
- Examples:
  - "SSL Cert Replacement Steps"
  - "Forward Zone Configuration"
  - "pg_hba.conf Example"
  - "SSH Key Setup Steps"
  - "How to Restore Configs"

### 📋 Copy Buttons
- Every code block has a "Copy" button
- Click → copies to clipboard
- Button shows "✓ Copied" for 2 seconds

---

## 🎨 Color System Breakdown

### Navy Blue Shades
- **Dark Navy:** `#001F3F` - Headers, buttons, accents
- **Medium Navy:** `#003D7A` - Gradients, borders
- **Light Navy:** `#0059B8` - Active states, highlights

### Grays (Dark Theme)
- **Dark Gray:** `#1a1a1a` - Main background
- **Medium Gray:** `#2a2a2a` - Content cards
- **Light Gray:** `#3a3a3a` - VM cards, sections

### Status Colors
- **Success:** `#00ff88` - Green (checkmarks, OK states)
- **Warning:** `#ffc107` - Yellow (alerts, actions needed)
- **Danger:** `#ff4444` - Red (critical, red team active)

### White
- **Pure White:** `#FFFFFF` - Text, borders, active highlights

---

## 📊 Component Examples

### VM Info Cards
```
┌─────────────────────────────────────┐
│ VM Information                      │
├─────────────────────────────────────┤
│ IP Address    | 192.168.5.5         │
│ Services      | Apache2, HTTP, HTTPS│
│ Total Points  | 3500                │
│ Assigned To   | Gabe & Noah K       │
└─────────────────────────────────────┘
```

### Scoring Tables
```
┌──────────────┬────────┬─────────────────────┐
│ Service      │ Points │ Verification        │
├──────────────┼────────┼─────────────────────┤
│ WWW HTTP     │   500  │ curl -I http://...  │
│ WWW HTTPS    │  1500  │ curl -Ik https://.. │
│ WWW Content  │  1500  │ curl -sk ... | grep │
└──────────────┴────────┴─────────────────────┘
```

### Alert Boxes
```
┌─────────────────────────────────────┐
│ ✅ SUCCESS: Scoring engine active   │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ ⚠️ WARNING: Replace SSL cert now    │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ 🔴 DANGER: Red team is active       │
└─────────────────────────────────────┘
```

### Script Cards
```
┌────────────────────────────────┐
│ score_check.sh                 │
│ Quick scoring verification -   │
│ YOUR DASHBOARD                 │
│                                │
│ [Critical] [Run Every 15min]  │
└────────────────────────────────┘
```

---

## 🚀 How to Use

### 1. Open in Browser
```bash
# From competition VM:
firefox /opt/ncae/ncae-playbook.html

# Or host locally:
python3 -m http.server 8000
# Then browse to http://localhost:8000/ncae-playbook.html
```

### 2. Set Your Team Number
- Input box at top: "Team Number: [5]"
- Click "Update All IPs"
- All IPs throughout playbook update instantly

### 3. Navigate Tabs
- Click tab headers to switch systems
- Each tab has complete info for that system
- Start with "Overview" for quick reference

### 4. Use Interactive Features
- ✅ Check off completed tasks
- 📄 Expand collapsible sections as needed
- 📋 Copy commands with one click

### 5. During Competition
- Keep playbook open in browser
- Quick tab switching for each system
- Copy/paste commands directly
- Check off tasks as completed

---

## 📱 Mobile Responsive

The playbook is **fully responsive**:
- Desktop: Full width, side-by-side layouts
- Tablet: Stacked grids, readable tables
- Mobile: Single column, touch-friendly buttons

---

## 🎯 GitHub Integration

In the **Scripts** tab, there's a placeholder:

```html
Download all scripts from GitHub: [Add your GitHub link here]
```

**To update:**
1. Upload all scripts to GitHub
2. Open `ncae-playbook.html` in editor
3. Find line ~1450 (Scripts tab)
4. Replace `[Add your GitHub link here]` with your actual GitHub URL

Example:
```html
Download all scripts from GitHub: 
<a href="https://github.com/yourname/ncae-toolkit" 
   style="color: var(--navy-light);">
   github.com/yourname/ncae-toolkit
</a>
```

---

## 💡 Pro Tips

### During Pre-Competition
1. **Print key pages** - Overview + Timeline for backup
2. **Bookmark** playbook on all VMs
3. **Practice** tab navigation beforehand

### During Competition
1. **Keep Overview tab open** - quick reference
2. **Use tab switching** - faster than scrolling
3. **Copy commands** - don't retype (typos = downtime)
4. **Check off tasks** - stay organized under pressure

### Team Coordination
1. **Assign tabs to people** - Web tab = Gabe & Noah K
2. **Share one browser** on big screen
3. **Update together** - check off tasks as team completes

---

## 🎨 Color Scheme Reference

Your school's navy and white colors are used throughout:

| Element | Color | Usage |
|---------|-------|-------|
| Background | Dark Gray | Main page background |
| Headers | Navy Gradient | Tab headers, section headers |
| Buttons | Light Navy | Interactive buttons, hover states |
| Text | White | Primary text, readability |
| Code Blocks | Dark Gray + Green | Command snippets |
| Success | Green | Checkmarks, completed tasks |
| Warning | Yellow | Action items, SSL replacement |
| Danger | Red | Red team alerts, critical issues |

---

## ✨ What Makes This Special

### 1. **Complete Coverage**
- Every VM has dedicated tab
- Every service documented
- Every command ready to copy

### 2. **Auto-Detection Integration**
- Matches `deploy_all.sh` auto-detection
- Same IP detection logic
- Consistent team numbering

### 3. **Competition-Focused**
- Timeline matches actual event
- Checklists for every stage
- Emergency commands ready

### 4. **Professional Design**
- School colors throughout
- Dark theme (less eye strain)
- Modern, clean interface

### 5. **Interactive UX**
- Team number updates everything
- Click to check tasks
- Expand sections as needed
- Copy commands instantly

---

## 🏆 Competition Day Usage

### Pre-Competition (9:00-9:30 AM)
- Open Overview tab
- Review team assignments
- Check timeline

### Deployment (9:30-10:00 AM)
- Keep Overview open
- Follow Quick Start checklist
- Copy commands from each VM tab

### Scoring Active (10:00 AM)
- Switch to Timeline tab
- Check off 10:30 AM critical actions
- Use system tabs for troubleshooting

### Active Defense (10:30 AM - 4:00 PM)
- Keep Scripts tab bookmarked
- Quick reference for `score_check.sh`
- Use IR section if compromised

### End (4:00 PM)
- Final checklist in Timeline
- Verify all systems green

---

**Your playbook is ready! Open it, set your team number, and dominate the competition! 🏆**
