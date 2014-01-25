# Check for target product
ifeq (fusion_codinavid,$(TARGET_PRODUCT))

include vendor/fusion/products/fusion_codina-common.mk

# Inherit CM device configuration
$(call inherit-product, device/samsung/codinavid/cm.mk)

PRODUCT_NAME := fusion_codinavid

# Update local_manifest.xml
GET_PROJECT_RMS := $(shell vendor/fusion/tools/removeprojects.py $(PRODUCT_NAME))
GET_PROJECT_ADDS := $(shell vendor/fusion/tools/addprojects.py $(PRODUCT_NAME))

endif
