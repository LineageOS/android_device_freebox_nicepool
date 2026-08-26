#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

## Bluetooth
PRODUCT_PACKAGES += \
    BluetoothOverlayTarget

ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
PRODUCT_PACKAGES += \
    libbt-vendor

include kernel/platform/kernel-5.15/vendor/amlogic/bt-modules/firmware/bluetooth.mk

$(call soong_config_set,brcm_libbt,bdroid_buildcfg_include_dir,$(LOCAL_PATH)/bluetooth/include)
$(call soong_config_set,brcm_libbt,custom_bt_config,//$(LOCAL_PATH):vnd_nicepool.txt)
else # RTK
include hardware/realtek/rtkbt/rtkbt.mk
PRODUCT_VENDOR_PROPERTIES += \
    bluetooth.profile.a2dp.sink.enabled=false \
    bluetooth.profile.avrcp.controller.enabled=false \
    bluetooth.profile.hfp.hf.enabled=false \
    bluetooth.profile.map.client.enabled=false \
    bluetooth.profile.map.server.enabled=true \
    bluetooth.profile.pan.panu.enabled=false \
    bluetooth.profile.pbap.client.enabled=false
endif

## Init-Files
ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.amlogic.wifi_buildin_bcm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.amlogic.wifi_buildin_rtk.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc
endif

## Keylayout (IR)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/keylayout/Vendor_0001_Product_0001.kl:$(TARGET_COPY_OUT_VENDOR)/usr/keylayout/Vendor_0001_Product_0001.kl

## Keymaster
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1-service

## Netflix
PRODUCT_PACKAGES += \
    NetflixConfig \
    NicepoolNetflixConfigOverlay

## Soong Namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
PRODUCT_SOONG_NAMESPACES += \
    hardware/broadcom/libbt
endif

## Wi-Fi
ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
include kernel/platform/kernel-5.15/vendor/amlogic/dhd-driver/firmware/wifi.mk
PRODUCT_VENDOR_PROPERTIES += \
    vendor.bcm_wifi=bcm
else
PRODUCT_CFI_INCLUDE_PATHS += hardware/realtek/wlan/wpa_supplicant_8_lib
PRODUCT_VENDOR_PROPERTIES += \
    vendor.bcm_wifi=rtl
endif

## Inherit from the common tree product makefile
$(call inherit-product, device/amlogic/g12-common/g12.mk)

## Inherit from the proprietary files makefile
$(call inherit-product, vendor/freebox/nicepool/nicepool-vendor.mk)
