# Check for target product
ifeq (fusion_mb886,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_nav_xhdpi

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/device/mb886

# PAC device overlay
$(shell cp -f vendor/fusion/prebuilt/common/bootanimation_framework/android-logo-mask_motorola-xhdpi.png frameworks/base/core/res/assets/images/android-logo-mask.png)

# PAC boot logo
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/bootlogo/fusion_logo_720x1280.rle:root/logo.rle

# Copy bootanimation
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/xhdpi/bootanimation.zip:system/media/bootanimation.zip

# include PAC common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/motorola/mb886/cm.mk)

PRODUCT_NAME := fusion_mb886

# Update local_manifest.xml
GET_PROJECT_RMS := $(shell vendor/fusion/tools/removeprojects.py $(PRODUCT_NAME))
GET_PROJECT_ADDS := $(shell vendor/fusion/tools/addprojects.py $(PRODUCT_NAME))

endif
