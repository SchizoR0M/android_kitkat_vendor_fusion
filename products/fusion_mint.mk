# Check for target product
ifeq (fusion_mint,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_sony-blue

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/device/mint

# PAC device overlay
$(shell cp -f vendor/fusion/prebuilt/common/bootanimation_framework/android-logo-mask_sony-xhdpi.png frameworks/base/core/res/assets/images/android-logo-mask.png)

# PAC boot logo
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/bootlogo/fusion_logo_720x1280.rle:root/logo.rle

# Copy bootanimation
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/xhdpi/bootanimation.zip:system/media/bootanimation.zip

# include PAC common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/sony/mint/cm.mk)

PRODUCT_NAME := fusion_mint

endif
