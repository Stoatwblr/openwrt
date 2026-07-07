#!/bin/bash
# target/linux/econet/image/sync_upstream_firmware.sh
set -e

# 1. Establish absolute portability relative to the OpenWrt root directory
# Since this script runs from target/linux/econet/image/, four directories up is the root.
REPO_BASE="../../../../"

# Define the mt76 clone directory path relative to the repo root
# This expects the mt76 repo directory to be placed inside /opt/FASTMISC/stoatwblr/mt76
# which translates to the exact peer path structure next to the openwrt folder.
LOCAL_MT76_CLONE="${REPO_BASE}/../mt76"

LOCAL_FW_CACHE="${REPO_BASE}/dl/firmware/mediatek"
TARGET_ROOTFS="./build_dir/target-mips_1004kc_musl/root-econet"

# 2. HARD-ABORT CHECKPOINT: Validate that the mt76 clone physically exists
if [ ! -d "${LOCAL_MT76_CLONE}" ] || [ ! -d "${LOCAL_MT76_CLONE}/firmware" ]; then
    echo ""
    echo " ======================================================================= "
    echo "  ❌ FATAL BUILD ERROR: LOCAL 'mt76' REPOSITORY CLONE NOT FOUND!         "
    echo " ======================================================================= "
    echo "  The EcoNet Zyxel firmware build tree requires a local copy of the      "
    echo "  openwrt/mt76 repository to extract critical legacy firmware bin files. "
    echo ""
    echo "  REMINDER: Please clone the repository into your peer directory path:   "
    echo "  git clone https://github.com/openwrt/mt76 ${LOCAL_MT76_CLONE}"
    echo " ======================================================================= "
    echo ""
    exit 1 # Hard fail to halt the GNU Make compilation pipeline immediately
fi

# Define the exact manifest array of required fleet files
WANTED_FILES=(
    "mt7915_eeprom_dbdc.bin"
    "mt7916_eeprom.bin"
    "mt7603_e1.bin"
    "mt7603_e2.bin"
    "mt7662_rom_patch.bin"
    "mt7662.bin"
    "mt7615_rom_patch.bin"
    "mt7615_n9.bin"
    "mt7615_cr4.bin"
)

mkdir -p "${LOCAL_FW_CACHE}"
mkdir -p "${TARGET_ROOTFS}/lib/firmware/mediatek"

echo "=== Syncing MediaTek Firmware Assets from Portable Clone ==="

for FILE in "${WANTED_FILES[@]}"; do
    LOCAL_FILE="${LOCAL_FW_CACHE}/${FILE}"
    SRC_CLONE_FILE="${LOCAL_MT76_CLONE}/firmware/${FILE}"
    
    # Populate the global dl/ cache from the local peer mt76 clone folder
    if [ ! -f "${LOCAL_FILE}" ]; then
        if [ -f "${SRC_CLONE_FILE}" ]; then
            echo " 💾 Cache miss. Syncing ${FILE} from local mt76 clone..."
            cp "${SRC_CLONE_FILE}" "${LOCAL_FILE}"
        else
            # Soft-fail notification if an optional asset isn't tracked in this commit branch
            echo "  ⚠️  [SOFT FAIL] Asset ${FILE} not found inside your local mt76 clone folder."
        fi
    else
        echo " 💾 Found cached asset: ${FILE}"
    fi

    # Stage the verified file directly into the target filesystem
    if [ -f "${LOCAL_FILE}" ]; then
        cp "${LOCAL_FILE}" "${TARGET_ROOTFS}/lib/firmware/mediatek/"
        echo "  -> Staged asset successfully: ${FILE}"
    fi
done

echo " 🎉 Firmware synchronization pass complete."
exit 0
