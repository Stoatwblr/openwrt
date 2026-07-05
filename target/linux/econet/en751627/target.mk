# SPDX-License-Identifier: GPL-2.0-only

ARCH:=mips
SUBTARGET:=en751627
BOARDNAME:=EN7516 and EN7527 based boards
CPU_TYPE:=1004kc
KERNELNAME:=vmlinuz.bin
FEATURES:=pci page_pool

DEFAULT_PACKAGES += kmod-mtk-eth-soc -kmod-econet-eth kmod-leds-gpio kmod-gpio-button-hotplug wpad-mbedtls 

define Target/Description
	Build firmware images for EcoNet EN7516 and EN7527 based boards.
endef

# Force include the module explicitly in the early user-space startup scripts array
define Image/Config/Default
	echo "econet_eth" >> $(TARGET_DIR)/etc/modules.boot.d/90-econet-eth
endef

