# Check for target product
ifeq (fusion_e610,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_mdpi

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/celox-common

# PAC boot logo
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/bootlogo/fusion_logo_320x480.rle:root/logo.rle

# Copy bootanimation
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/mdpi/bootanimation.zip:system/media/bootanimation.zip

# include PAC common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/lge/e610/cm.mk)

PRODUCT_NAME := fusion_e610

# Update local_manifest.xml
GET_PROJECT_RMS := $(shell vendor/fusion/tools/removeprojects.py $(PRODUCT_NAME))
GET_PROJECT_ADDS := $(shell vendor/fusion/tools/addprojects.py $(PRODUCT_NAME))

endif
