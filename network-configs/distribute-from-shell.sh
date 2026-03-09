#!/bin/bash
# Run this on Shell/SMB VM AFTER network is configured
# Downloads toolkit from GitHub and distributes to all VMs

set -e
TEAM=5
GITHUB="https://github.com/YOUR-USERNAME/ncae-toolkit.git"

echo "════════════════════════════════════════════════════════"
echo "  NCAE Toolkit Distribution from Shell/SMB VM"
echo "  Team $TEAM"
echo "════════════════════════════════════════════════════════"
echo ""

# [1/4] Download toolkit
echo "[1/4] Downloading toolkit from GitHub..."
cd /tmp
rm -rf ncae-toolkit 2>/dev/null
if git clone --depth 1 "$GITHUB" ncae-toolkit; then
    echo "✅ Toolkit downloaded to /tmp/ncae-toolkit"
else
    echo "❌ GitHub clone failed - check internet connection"
    exit 1
fi

# [2/4] Deploy locally first
echo "[2/4] Deploying on Shell/SMB VM..."
mkdir -p /opt/ncae
cp -r /tmp/ncae-toolkit/* /opt/ncae/
cd /opt/ncae
chmod +x *.sh
./install_deps.sh
./deploy_all.sh &
echo "✅ Shell/SMB deployment started in background"

# [3/4] Wait for other VMs to have network
echo ""
echo "[3/4] Waiting for other VMs to have network configured..."
echo "     (Paste network-*.sh scripts via noVNC on each VM)"
echo ""
read -p "Press ENTER when all VMs have network configured..."

# [4/4] Distribute to all VMs
echo ""
echo "[4/4] Distributing toolkit to all VMs..."

VMS=(
    "192.168.${TEAM}.5:Web_Server"
    "192.168.${TEAM}.7:Database"
    "192.168.${TEAM}.12:DNS"
    "192.168.${TEAM}.15:Backup"
)

for vm_entry in "${VMS[@]}"; do
    IFS=':' read -r vm_ip vm_name <<< "$vm_entry"
    
    echo "→ Deploying to ${vm_name} (${vm_ip})..."
    
    # Create directory
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no root@"$vm_ip" "mkdir -p /opt/ncae" 2>/dev/null || {
        echo "  ⚠️  SSH failed - check if network configured on ${vm_name}"
        continue
    }
    
    # Copy toolkit
    scp -o ConnectTimeout=10 -o StrictHostKeyChecking=no -r /tmp/ncae-toolkit/* root@"$vm_ip":/opt/ncae/ 2>/dev/null || {
        echo "  ❌ SCP failed to ${vm_name}"
        continue
    }
    
    # Deploy in background
    ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no root@"$vm_ip" \
        "cd /opt/ncae && chmod +x *.sh && ./install_deps.sh && ./deploy_all.sh" &
    
    echo "  ✅ ${vm_name} deployment started"
done

echo ""
echo "Waiting for all background deployments to complete..."
wait

echo ""
echo "════════════════════════════════════════════════════════"
echo "  Distribution Complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Verify on each VM:"
for vm_entry in "${VMS[@]}"; do
    IFS=':' read -r vm_ip vm_name <<< "$vm_entry"
    echo "  ssh root@${vm_ip} '/opt/ncae/score_check.sh'"
done
echo ""
