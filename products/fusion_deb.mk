# Check for target product
ifeq (fusion_deb,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_flo

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/common_tablet


# Copy bootanimation
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/xxhdpi/8x/bootanimation.zip:system/media/bootanimation.zip

# include ParanoidAndroid common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/asus/deb/cm.mk)

PRODUCT_NAME := fusion_deb

# Update local_manifest.xml
GET_PROJECT_RMS := $(shell vendor/fusion/tools/removeprojects.py $(PRODUCT_NAME))
GET_PROJECT_ADDS := $(shell vendor/fusion/tools/addprojects.py $(PRODUCT_NAME))

endif
