# SPDX-License-Identifier: GPL-2.0-only

ARCH:=mips
SUBTARGET:=en751627
BOARDNAME:=EN7516 and EN7527 based boards
CPU_TYPE:=1004kc
KERNELNAME:=vmlinuz.bin
FEATURES:=pci page_pool

# Bind mainline Airoha Ethernet framework and the native MT7530 DSA switch driver modules
DEFAULT_PACKAGES += kmod-dsa-mt7530 kmod-leds-gpio kmod-gpio-button-hotplug wpad-mbedtls

define Target/Description
	Build firmware images for EcoNet EN7516 and EN7527 based boards.
endef

