# Check for target product
ifeq (fusion_evita,$(TARGET_PRODUCT))

# OVERLAY_TARGET adds overlay asset source
OVERLAY_TARGET := pa_xhdpi

# AOKP device overlay
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/device/galaxys2

# PAC device overlay
$(shell cp -f vendor/fusion/prebuilt/common/bootanimation_framework/android-logo-mask_htc-xhdpi.png frameworks/base/core/res/assets/images/android-logo-mask.png)

# PAC boot logo
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/xhdpi/bootanimation.zip:system/media/bootanimation.zip

# include PAC common configuration
include vendor/fusion/config/fusion_common.mk

# Inherit CM device configuration
$(call inherit-product, device/htc/evita/cm.mk)

PRODUCT_NAME := fusion_evita

# Update local_manifest.xml
GET_PROJECT_RMS := $(shell vendor/fusion/tools/removeprojects.py $(PRODUCT_NAME))
GET_PROJECT_ADDS := $(shell vendor/fusion/tools/addprojects.py $(PRODUCT_NAME))

endif