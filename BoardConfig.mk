#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/freebox/nicepool

## Bootloader
TARGET_BOOTLOADER_BOARD_NAME := nicepool

## DTB
TARGET_DTB_NAME := g12a_s905x2_u215_nicepool
TARGET_DTBO_NAME := g12a_s905x2_u215_nicepool_overlay

## HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/manifest.xml

## Kernel modules
TARGET_KERNEL_EXT_MODULES := \
    rtl8822cs/rtl88x2CS:kbuild

## Partitions
BOARD_SUPER_PARTITION_SIZE := 2692743168

## Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

## SELinux
SELINUX_IGNORE_NEVERALLOWS := true
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

## Wi-Fi
BOARD_WLAN_DEVICE := realtek
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_rtl
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_rtl
WIFI_DRIVER_SOCKET_IFACE := wlan0

## Include the common tree BoardConfig makefile
include device/amlogic/g12-common/BoardConfigCommon.mk

TARGET_KERNEL_CONFIG += usb_reconfigure_quirk.config

## Include the proprietary BoardConfig makefile
include vendor/freebox/nicepool/BoardConfigVendor.mk
