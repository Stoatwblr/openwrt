#!/bin/bash
# target/linux/econet/image/extract_en751627_zyxel_blobs.sh
set -e

# 1. Establish absolute portability relative to the OpenWrt tree root
# Dynamic target evaluation paths passed by the calling Makefile loop ($1 = $(TARGET_DIR))
TARGET_ROOTFS="$1"
if [ -z "$TARGET_ROOTFS" ]; then
    TARGET_ROOTFS="./build_dir/target-mips_1004kc_musl/root-econet"
fi

REPO_BASE="../../../../"
LOCAL_DL_DIR="${REPO_BASE}/dl"
EXTRACT_TMP="/tmp/zyxel_master_unzip"
IMAGE_TMP="/tmp/zyxel_master_binwalk"

# Target variables matched exactly to the official release note parameters
ZIP_FILE="DX3301-T0_Firmware_5.50(ABVY.7.2)C0.zip"
DIR_NAME="5.50(ABVY.7.2)C0"
BIN_NAME="V550ABVY7.2C0.bin"

# Mirror lists
ZYXEL_URL="https://spdl.zyxel.com/DX3301-T0/firmware(public_version)/"$ZIP_FILE
MIRROR_URL="https://github.com/Stoatwblr/EN751627/raw/refs/heads/main/zyxel/"$ZIP_FILE

# Optional local repository workspace tree check (stoatwblr/en751627 clone match)
LOCAL_GIT_WORKSPACE="${REPO_BASE}/../en751627"

mkdir -p "${LOCAL_DL_DIR}"

# -------------------------------------------------------------------------
# DEFENSIVE ARTIFACT RESCUE: VERIFY THE PAYLOAD SOURCE INDEX
# -------------------------------------------------------------------------
TARGET_ZIP_PATH="${LOCAL_DL_DIR}/${ZIP_FILE}"

# Step A: Check if the required zip module exists inside a peer local Git clone tracker
if [ ! -f "${TARGET_ZIP_PATH}" ] && [ -d "${LOCAL_GIT_WORKSPACE}" ]; then
    WORKSPACE_MATCH=$(find "${LOCAL_GIT_WORKSPACE}" -type f -name "${ZIP_FILE}" | head -n 1)
    if [ -n "${WORKSPACE_MATCH}" ]; then
        echo " 💾 Found target artifact inside your local workspace clone: ${WORKSPACE_MATCH}"
        cp "${WORKSPACE_MATCH}" "${TARGET_ZIP_PATH}"
    fi
fi

# Step B: Strict Archive Verification Loop
while true; do
    if [ -f "${TARGET_ZIP_PATH}" ]; then
        echo " 🛡️  Checking archive structural integrity for ${ZIP_FILE}..."
        # unzip -t carries out a silent test pass to detect corrupted chunks or HTML masks
        if unzip -t "$TARGET_ZIP_PATH" >/dev/null 2>&1; then
            echo " ✅ [VALID] Archive package structural signature passed."
            break
        else
            echo " ❌ [CORRUPT] Found invalid or HTML masked ZIP payload. Purging broken asset file..."
            rm -f "${TARGET_ZIP_PATH}"
        fi
    fi

    # Step C: Mirror Fallback Execution if file is missing or just got deleted due to corruption
    echo " 📥 Target firmware package missing or unverified. Fetching public vendor asset..."
    if ! wget -q -O "${TARGET_ZIP_PATH}" "${ZYXEL_URL}"; then
        echo " ⚠️  Primary vendor path failed or throttled. Pulling from stable community mirror..."
        wget -q -O "${TARGET_ZIP_PATH}" "${MIRROR_URL}" || {
            echo " ❌ [FATAL] Inaccessible firmware resource mirror blocks. Aborting image prep pass."
            exit 1
        }
    fi
done

# -------------------------------------------------------------------------
# CARVE & EXTRACTION EXTRACTION LAYER
# -------------------------------------------------------------------------
rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
mkdir -p "$EXTRACT_TMP" "$IMAGE_TMP"

echo " Unzipping vendor distribution bundle..."
unzip -q -j "${TARGET_ZIP_PATH}" "${DIR_NAME}/${BIN_NAME}" -d "$EXTRACT_TMP"

TARGET_BIN="${EXTRACT_TMP}/${BIN_NAME}"
if [ ! -f "$TARGET_BIN" ]; then
    echo " ❌ Error: Failed to extract target firmware binary payload data."
    rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
    exit 1
fi

echo " Extracting embedded squashfs layers via binwalk carving tools..."
binwalk -q -e -C "$IMAGE_TMP" "$TARGET_BIN"

UNPACKED_ROOT=$(find "$IMAGE_TMP" -type d -name "*squashfs-root*" | head -n 1)
if [ -z "$UNPACKED_ROOT" ]; then
    echo " ❌ Error: Failed to locate carved filesystem container blocks."
    rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
    exit 1
fi

# -------------------------------------------------------------------------
# FLEET INJECTION LAYER
# -------------------------------------------------------------------------
# 1. Map the common DSL modem microcode firmware binary blob universally
if [ -f "$UNPACKED_ROOT/lib/firmware/mtk_dsl_fw.bin" ]; then
    mkdir -p "${TARGET_ROOTFS}/lib/firmware"
    cp "$UNPACKED_ROOT/lib/firmware/mtk_dsl_fw.bin" "${TARGET_ROOTFS}/lib/firmware/"
    echo "  -> Extracted and injected generic MediaTek VDSL microcode."
fi

# 2. Map the common Silicon Labs Si3228x Voice Processor module fleet-wide
VOIP_MODULE=$(find "$UNPACKED_ROOT" -type f -name "*voip_drv.ko*" -o -name "*slic_drv.ko*" | head -n 1)
if [ -n "$VOIP_MODULE" ]; then
    mkdir -p "${TARGET_ROOTFS}/lib/modules"
    cp "$VOIP_MODULE" "${TARGET_ROOTFS}/lib/modules/"
    echo "  -> Extracted and injected generic MediaTek/SiLabs VoIP SLIC kernel module."
fi

# Clean up transient preprocessor workspace crumbs
rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
echo " 🎉 Universal proprietary driver blob extraction complete."
exit 0





#!/bin/bash
# target/linux/econet/image/extract_en751627_zyxel_blobs.sh
set -e

ARCHIVE_DIR="./dl/vendor_archive"
TARGET_ROOTFS="./build_dir/target-mips_1004kc_musl/root-econet"
EXTRACT_TMP="./tmp/zyxel_master_unzip"
IMAGE_TMP="./tmp/zyxel_master_binwalk"

# Target variables matched exactly to the official release note
ZIP_FILE="DX3301-T0_Firmware_5.50(ABVY.7.2)C0.zip"
DIR_NAME="5.50(ABVY.7.2)C0"
BIN_NAME="V550ABVY7.2C0.bin"

mkdir -p "$ARCHIVE_DIR"
LOCAL_ZIP="${ARCHIVE_DIR}/${ZIP_FILE}"

# 1. Defensive Network Fetch: Local cache priority loop
if [ ! -f "$LOCAL_ZIP" ]; then
    echo " 📥 Local firmware archive empty. Attempting public vendor download..."
    if ! wget -q -O "$LOCAL_ZIP" "$ZYXEL_URL"; then
        echo " ⚠️  Primary vendor path failed or expired. Pulling from stable community archive mirror..."
        wget -q -O "$LOCAL_ZIP" "$MIRROR_URL" || {
            echo " ❌ Critical Error: Inaccessible firmware resource mirror blocks."
            exit 1
        }
    fi
else
    echo " 💾 Found verified archive package: ${ZIP_FILE}"
fi

# 2. Extract the archive structure
rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
mkdir -p "$EXTRACT_TMP" "$IMAGE_TMP"

echo " Unzipping vendor distribution bundle..."
unzip -q -j "$LOCAL_ZIP" "${DIR_NAME}/${BIN_NAME}" -d "$EXTRACT_TMP"

TARGET_BIN="${EXTRACT_TMP}/${BIN_NAME}"
if [ ! -f "$TARGET_BIN" ]; then
    echo " ❌ Error: Failed to extract target firmware binary payload."
    exit 1
fi

# 3. Carve open the squashfs payload inside the factory binary
echo " Extracting embedded file system layers via binwalk..."
binwalk -q -e -C "$IMAGE_TMP" "$TARGET_BIN"

UNPACKED_ROOT=$(find "$IMAGE_TMP" -type d -name "*squashfs-root*" | head -n 1)
if [ -z "$UNPACKED_ROOT" ]; then
    echo " ❌ Error: Failed to carve out raw filesystem container blocks."
    rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
    exit 1
fi

# 4. Inject the common DSL Front-End firmware binary blob fleet-wide
if [ -f "$UNPACKED_ROOT/lib/firmware/mtk_dsl_fw.bin" ]; then
    mkdir -p "$TARGET_ROOTFS/lib/firmware"
    cp "$UNPACKED_ROOT/lib/firmware/mtk_dsl_fw.bin" "$TARGET_ROOTFS/lib/firmware/"
    echo "  -> Extracted and injected generic MediaTek DSL microcode."
fi

# 5. Inject the common Silicon Labs Si3228x Voice Processor module fleet-wide
VOIP_MODULE=$(find "$UNPACKED_ROOT" -type f -name "*voip_drv.ko*" -o -name "*slic_drv.ko*" | head -n 1)
if [ -n "$VOIP_MODULE" ]; then
    mkdir -p "$TARGET_ROOTFS/lib/modules"
    cp "$VOIP_MODULE" "$TARGET_ROOTFS/lib/modules/"
    echo "  -> Extracted and injected generic MediaTek/SiLabs VoIP SLIC module."
fi

# Clean up transient preprocessor garbage crumbs
rm -rf "$EXTRACT_TMP" "$IMAGE_TMP"
echo " 🎉 Universal driver blob extraction complete."
exit 0
