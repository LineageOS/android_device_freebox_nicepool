#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

## Bluetooth
PRODUCT_PACKAGES += \
    NicepoolBluetoothOverlay

ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
PRODUCT_PACKAGES += \
    libbt-vendor

include kernel/amlogic/kernel-modules/dhd-driver/firmware/bluetooth/bluetooth.mk

$(call soong_config_set,brcm_libbt,bdroid_buildcfg_include_dir,$(LOCAL_PATH)/bluetooth/include)
$(call soong_config_set,brcm_libbt,custom_bt_config,//$(LOCAL_PATH):vnd_nicepool.txt)
else # RTK
include hardware/realtek/rtkbt/rtkbt.mk
endif

## Init-Files
ifneq ($(BOARD_HAVE_BLUETOOTH_RTK_TV),true)
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.amlogic.wifi_buildin_bcm.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc
else
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/init-files/init.amlogic.wifi_buildin_rtk.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.amlogic.wifi_buildin.rc
endif

## IR
PRODUCT_PACKAGES += \
    android.hardware.ir@1.0-service \
    android.hardware.ir@1.0-impl

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.consumerir.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.consumerir.xml

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
include kernel/amlogic/kernel-modules/dhd-driver/firmware/wifi/wifi.mk
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
