#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/freebox/nicepool

## Bluetooth
BOARD_HAVE_BLUETOOTH := true

## Bootloader
TARGET_BOOTLOADER_BOARD_NAME := nicepool

## DTB
TARGET_DTB_NAME := g12a_s905x2_u215_nicepool
TARGET_DTBO_NAME := g12a_s905x2_u215_nicepool_overlay

<<<<<<< PATCH SET (1127892c8240187e8db7e23c4e227c546d395473 nicepool: consumer ir is no longer (hidl))
BOOT_KERNEL_MODULES := $(strip $(shell cat $(DEVICE_PATH)/ramdisk.modules.load))
RECOVERY_KERNEL_MODULES := $(BOOT_KERNEL_MODULES)

BOARD_RECOVERY_KERNEL_MODULES_LOAD := $(RECOVERY_KERNEL_MODULES)
BOARD_VENDOR_KERNEL_MODULES_LOAD := $(strip $(shell cat $(DEVICE_PATH)/vendor_dlkm.modules.load))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := $(BOOT_KERNEL_MODULES)
=======
## HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

## Kernel modules
TARGET_KERNEL_EXT_MODULES := \
    dhd-driver/bcmdhd.101.10.361.x \
    rtl8822cs/rtl88x2CS:kbuild
>>>>>>> BASE      (35805f1d630207b4384e7ff60393a87e3b799cb2 nicepool: Remove variant-related soong_config_set call)

## Partitions
BOARD_SUPER_PARTITION_SIZE := 2692743168

## Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

## SELinux
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

## Wi-Fi
ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE := bcmdhd
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_AP := "/wifi/fw_bcm4356a2_ag_apsta.bin"
WIFI_DRIVER_FW_PATH_STA := "/wifi/fw_bcm4356a2_ag.bin"
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/dhd/parameters/firmware_path"
else
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_WLAN_DEVICE := realtek
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
WIFI_DRIVER_SOCKET_IFACE := wlan0
endif

BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_8_X

## Include the common tree BoardConfig makefile
include device/amlogic/g12-common/BoardConfigCommon.mk

TARGET_KERNEL_CONFIG += usb_reconfigure_quirk.config

## Include the proprietary BoardConfig makefile
include vendor/freebox/nicepool/BoardConfigVendor.mk
