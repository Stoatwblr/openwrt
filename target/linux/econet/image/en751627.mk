# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 OpenWrt.org

TRX_ENDIAN := be


include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Device/en751627-zyxel-base
  DEVICE_VENDOR := Zyxel
  IMAGE_SIZE := 55296k
  KERNEL_SIZE := 4096k
  BLOCKSIZE := 128k
  PAGESIZE := 2048k

  DEVICE_TRX_ENDIAN := be

	KERNEL_NAME := vmlinuz.bin

  IMAGES := sysupgrade.bin tclinux.trx
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata

  IMAGE/tclinux.trx := append-kernel | lzma | tclinux-trx

  KERNEL := kernel-bin | append-dtb
endef

# ============================================================================
# SUB-FLEET 1: WI-FI 5 BASE CHASSIS GENERATION (T50B SERIES)
# ============================================================================
define Device/zyxel-t50b-base
  $(Device/en751627-zyxel-base)
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2 kmod-mt7603 kmod-mt76x2 kmod-mt7603-firmware kmod-mt76x2-firmware
endef

define Device/zyxel_emg3525-t50b
  $(Device/zyxel-t50b-base)
  DEVICE_MODEL := EMG3525-T50B
  DEVICE_DTS := en751627_zyxel_emg3525-t50b
  SUPPORTED_DEVICES := zyxel,emg3525-t50b
endef
TARGET_DEVICES += zyxel_emg3525-t50b

define Device/zyxel_vmg3625-t50b
  $(Device/zyxel-t50b-base)
  DEVICE_MODEL := VMG3625-T50B
  DEVICE_DTS := en751627_zyxel_vmg3625-t50b
  SUPPORTED_DEVICES := zyxel,vmg3625-t50b
  DEVICE_PACKAGES += kmod-econet-dsl dsl-utils
endef
TARGET_DEVICES += zyxel_vmg3625-t50b

define Device/zyxel_emg5523-t50b
  $(Device/zyxel-t50b-base)
  DEVICE_MODEL := EMG5523-T50B
  DEVICE_DTS := en751627_zyxel_emg5523-t50b
  SUPPORTED_DEVICES := zyxel,emg5523-t50b
  DEVICE_PACKAGES += kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_emg5523-t50b

define Device/zyxel_vmg8623-t50b
  $(Device/zyxel-t50b-base)
  DEVICE_MODEL := VMG8623-T50B
  DEVICE_DTS := en751627_zyxel_vmg8623-t50b
  SUPPORTED_DEVICES := zyxel,vmg8623-t50b
  DEVICE_PACKAGES += kmod-econet-dsl dsl-utils kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_vmg8623-t50b

# ============================================================================
# SUB-FLEET 2: WI-FI 5 HIGH-PERFORMANCE EXTENSION CHASSIS (T50K SERIES)
# ============================================================================
define Device/zyxel-t50k-base
  $(Device/en751627-zyxel-base)
  # FIXED: Added mt7615-firmware alongside its driver component
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2 kmod-usb3 kmod-mt7615e mt7615-firmware
endef

define Device/zyxel_vmg3927-t50k
  $(Device/zyxel-t50k-base)
  DEVICE_MODEL := VMG3927-T50K
  DEVICE_DTS := en751627_zyxel_vmg3927-t50k
  SUPPORTED_DEVICES := zyxel,vmg3927-t50k
  DEVICE_PACKAGES += kmod-econet-dsl dsl-utils
endef
TARGET_DEVICES += zyxel_vmg3927-t50k

define Device/zyxel_emg5723-t50k
  $(Device/zyxel-t50k-base)
  DEVICE_MODEL := EMG5723-T50K
  DEVICE_DTS := en751627_zyxel_emg5723-t50k
  SUPPORTED_DEVICES := zyxel,emg5723-t50k
  DEVICE_PACKAGES += kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_emg5723-t50k

define Device/zyxel_vmg8825-t50k
  $(Device/zyxel-t50k-base)
  DEVICE_MODEL := VMG8825-T50K
  DEVICE_DTS := en751627_zyxel_vmg8825-t50k
  SUPPORTED_DEVICES := zyxel,vmg8825-t50k
  DEVICE_PACKAGES += kmod-econet-dsl dsl-utils kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_vmg8825-t50k

# ============================================================================
# SUB-FLEET 3: WI-FI 6 MAINSTREAM SERIES (330X RANGE)
# ============================================================================
define Device/zyxel-3300-base
  $(Device/en751627-zyxel-base)
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2 kmod-usb3 kmod-mt7915e kmod-mt7915-firmware mt7915-firmware
endef

define Device/zyxel_ex3300-t0
  $(Device/zyxel-3300-base)
  DEVICE_MODEL := EX3300-T0
  DEVICE_DTS := en751627_zyxel_ex3300-t0
  SUPPORTED_DEVICES := zyxel,ex3300-t0
  DEVICE_PACKAGES += kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_ex3300-t0

define Device/zyxel_dx3300-t0
  $(Device/zyxel-3300-base)
  DEVICE_MODEL := DX3300-T0
  DEVICE_DTS := en751627_zyxel_dx3300-t0
  SUPPORTED_DEVICES := zyxel,dx3300-t0
  DEVICE_PACKAGES += kmod-econet-dsl dsl-utils kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_dx3300-t0

define Device/zyxel_ex3301-t0
  $(Device/zyxel-3300-base)
  DEVICE_MODEL := EX3301-T0
  DEVICE_DTS := en751627_zyxel_ex3301-t0
  SUPPORTED_DEVICES := zyxel,ex3301-t0
  DEVICE_PACKAGES += kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_ex3301-t0

define Device/zyxel_dx3301-t0
  $(Device/zyxel-3300-base)
  DEVICE_MODEL := DX3301-T0
  DEVICE_DTS := en751627_zyxel_dx3301-t0
  SUPPORTED_DEVICES := zyxel,dx3301-t0
  DEVICE_PACKAGES += kmod-econet-dsl dsl-utils kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_dx3301-t0

define Device/zyxel_wx3100-t0
  $(Device/zyxel-3300-base)
  DEVICE_MODEL := WX3100-T0
  DEVICE_DTS := en751627_zyxel_wx3100-t0
  SUPPORTED_DEVICES := zyxel,wx3100-t0
endef
TARGET_DEVICES += zyxel_wx3100-t0

# ============================================================================
# SUB-FLEET 4: WI-FI 6 MULTI-GIGABIT HIGH-PERFORMANCE FLEET (560X RANGE)
# ============================================================================
define Device/zyxel-5600-base
  $(Device/en751627-zyxel-base)
  # FIXED: Appended mt7916-firmware to pull down the correct 2.5G default template layout
  DEVICE_PACKAGES += kmod-mt7915e kmod-msc-2.5g-phy kmod-mt7916-firmware kmod-mt7915-firmware mt7915-firmware mt7916-firmware
endef

define Device/zyxel_ex5600-t0
  $(Device/zyxel-5600-base)
  DEVICE_MODEL := EX5600-T0
  DEVICE_DTS := en751627_zyxel_ex5600-t0
  SUPPORTED_DEVICES := zyxel,ex5600-t0
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2 kmod-usb3 kmod-sfp kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_ex5600-t0

define Device/zyxel_ex5600-t1
  $(Device/zyxel-5600-base)
  DEVICE_MODEL := EX5600-T1
  DEVICE_DTS := en751627_zyxel_ex5600-t1
  SUPPORTED_DEVICES := zyxel,ex5600-t1
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2
endef
TARGET_DEVICES += zyxel_ex5600-t1

define Device/zyxel_ex5601-t0
  $(Device/zyxel-5600-base)
  DEVICE_MODEL := EX5601-T0
  DEVICE_DTS := en751627_zyxel_ex5601-t0
  SUPPORTED_DEVICES := zyxel,ex5601-t0
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2 kmod-usb3 kmod-sfp kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_ex5601-t0

define Device/zyxel_ex5601-t1
  $(Device/zyxel-5600-base)
  DEVICE_MODEL := EX5601-T1
  DEVICE_DTS := en751627_zyxel_ex5601-t1
  SUPPORTED_DEVICES := zyxel,ex5601-t1
  DEVICE_PACKAGES += kmod-usb-ohci kmod-usb2 kmod-usb3 kmod-voip-slic-si32280
endef
TARGET_DEVICES += zyxel_ex5601-t1

define Device/zyxel_wx5600-t0
  $(Device/zyxel-5600-base)
  DEVICE_MODEL := WX5600-T0
  DEVICE_DTS := en751627_zyxel_wx5600-t0
  SUPPORTED_DEVICES := zyxel,wx5600-t0
endef
TARGET_DEVICES += zyxel_wx5600-t0

$(eval $(call BuildImage))
