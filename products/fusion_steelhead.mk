# Check for target product
ifeq (fusion_steelhead,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_steelhead

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/common_tablet

# Copy bootanimation
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/xxhdpi/bootanimation.zip:system/media/bootanimation.zip

# include PAC common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/google/steelhead/cm.mk)

PRODUCT_NAME := fusion_steelhead

endif
