# Check for target product
ifeq (fusion_fascinatemtd,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_hdpi

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/device/fascinatemtd

# Fusion device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/fusion/hdpi_480x800
#$(shell cp -f vendor/fusion/prebuilt/common/bootanimation_framework/android-logo-mask_samsung-hdpi.png frameworks/base/core/res/assets/images/android-logo-mask.png)

# Copy bootanimation
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/hdpi/6x/bootanimation.zip:system/media/bootanimation.zip

# include Fusion common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/samsung/fascinatemtd/cm.mk)

PRODUCT_NAME := fusion_fascinatemtd

# Update local_manifest.xml
GET_PROJECT_RMS := $(shell vendor/fusion/tools/removeprojects.py $(PRODUCT_NAME))
GET_PROJECT_ADDS := $(shell vendor/fusion/tools/addprojects.py $(PRODUCT_NAME))

endif