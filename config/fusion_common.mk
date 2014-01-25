# Vendor hack
#   $1 = vendor name
#   $2 = product name
define vendor-replace
  $(shell mkdir -p vendor/$(1); \
          rm -rf vendor/$(1)/$(2); \
          ln -sf ../$(1)-extra/$(2) vendor/$(1)/$(2))
endef

# use AOSP default sounds
PRODUCT_PROPERTY_OVERRIDES += \
  ro.config.ringtone=Themos.ogg \
  ro.config.notification_sound=Proxima.ogg \
  ro.config.alarm_alert=Cesium.ogg

# Copy specific ROM files
# PRODUCT_COPY_FILES += \


# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/bin/backuptool.sh:system/bin/backuptool.sh \
    vendor/fusion/prebuilt/common/bin/backuptool.functions:system/bin/backuptool.functions \
    vendor/fusion/prebuilt/common/bin/50-backupScript.sh:system/addon.d/50-backupScript.sh

# Using Custom ReleaseRool
TARGET_RELEASETOOL_OTA_FROM_TARGET_SCRIPT := vendor/fusion/overlay/build/tools/releasetools/ota_from_target_files

# T-Mobile theme engine
include vendor/fusion/config/themes_common.mk

# Screen recorder
PRODUCT_PACKAGES += \
    ScreenRecorder \
    libscreenrecorder

# init.d support
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/bin/sysinit:system/bin/sysinit \
    vendor/fusion/prebuilt/common/etc/init.d/00check:system/etc/init.d/00check \
    vendor/fusion/prebuilt/common/etc/init.d/01zipalign:system/etc/init.d/01zipalign \
    vendor/fusion/prebuilt/common/etc/init.d/02sysctl:system/etc/init.d/02sysctl \
    vendor/fusion/prebuilt/common/etc/init.d/03firstboot:system/etc/init.d/03firstboot \
    vendor/fusion/prebuilt/common/etc/init.d/05freemem:system/etc/init.d/05freemem \
    vendor/fusion/prebuilt/common/etc/init.d/06removecache:system/etc/init.d/06removecache \
    vendor/fusion/prebuilt/common/etc/init.d/07fixperms:system/etc/init.d/07fixperms \
    vendor/fusion/prebuilt/common/etc/init.d/09cron:system/etc/init.d/09cron \
    vendor/fusion/prebuilt/common/etc/init.d/10sdboost:system/etc/init.d/10sdboost \
    vendor/fusion/prebuilt/common/etc/init.d/11battery:system/etc/init.d/11battery \
    vendor/fusion/prebuilt/common/etc/init.d/12touch:system/etc/init.d/12touch \
    vendor/fusion/prebuilt/common/etc/init.d/13minfree:system/etc/init.d/13minfree \
    vendor/fusion/prebuilt/common/etc/init.d/14gpurender:system/etc/init.d/14gpurender \
    vendor/fusion/prebuilt/common/etc/init.d/15sleepers:system/etc/init.d/15sleepers \
    vendor/fusion/prebuilt/common/etc/init.d/16journalism:system/etc/init.d/16journalism \
    vendor/fusion/prebuilt/common/etc/init.d/17sqlite3:system/etc/init.d/17sqlite3 \
    vendor/fusion/prebuilt/common/etc/init.d/18wifisleep:system/etc/init.d/18wifisleep \
    vendor/fusion/prebuilt/common/etc/init.d/19iostats:system/etc/init.d/19iostats \
    vendor/fusion/prebuilt/common/etc/init.d/20setrenice:system/etc/init.d/20setrenice \
    vendor/fusion/prebuilt/common/etc/init.d/21tweaks:system/etc/init.d/21tweaks \
    vendor/fusion/prebuilt/common/etc/init.d/24speedy_modified:system/etc/init.d/24speedy_modified \
    vendor/fusion/prebuilt/common/etc/init.d/25loopy_smoothness_tweak:system/etc/init.d/25loopy_smoothness_tweak \
    vendor/fusion/prebuilt/common/etc/init.d/98tweaks:system/etc/init.d/98tweaks \
    vendor/fusion/prebuilt/common/etc/helpers.sh:system/etc/helpers.sh \
    vendor/fusion/prebuilt/common/etc/sysctl.conf:system/etc/sysctl.conf \
    vendor/fusion/prebuilt/common/etc/init.d.cfg:system/etc/init.d.cfg

# Added xbin files
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/xbin/zip:system/xbin/zip \
    vendor/fusion/prebuilt/common/xbin/zipalign:system/xbin/zipalign

# Configurable init.d
PRODUCT_COPY_FILES += \
    vendor/fusion/prebuilt/common/su/su:system/xbin/daemonsu \
    vendor/fusion/prebuilt/common/su/99SuperSUDaemon:system/etc/init.d/99SuperSUDaemon \


# FUSION Packages
PRODUCT_PACKAGES += \
    FusionBox \
    Fusionlauncher \
    Superuser \
    su 

# FUSION Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/fusion/common

# AOKP Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/fusion/overlay/aokp/common

### PARANOID ###
# PARANOID Packages
PRODUCT_PACKAGES += \
    HALO

# ParanoidAndroid Overlays
PRODUCT_PACKAGE_OVERLAYS += vendor/pa/overlay/common
PRODUCT_PACKAGE_OVERLAYS += vendor/pa/overlay/$(TARGET_PRODUCT)

# Allow device family to add overlays and use a same prop.conf
ifneq ($(OVERLAY_TARGET),)
    PRODUCT_PACKAGE_OVERLAYS += vendor/pa/overlay/$(OVERLAY_TARGET)
    PA_CONF_SOURCE := $(OVERLAY_TARGET)
else
    PA_CONF_SOURCE := $(TARGET_PRODUCT)
endif

# ParanoidAndroid Proprietary
PRODUCT_COPY_FILES += \
#     vendor/pa/prebuilt/apk/ParanoidPreferences.apk:system/app/ParanoidPreferences.apk \
    vendor/fusion/prebuilt/pa/$(PA_CONF_SOURCE).conf:system/etc/paranoid/properties.conf \
    vendor/fusion/prebuilt/pa/$(PA_CONF_SOURCE).conf:system/etc/paranoid/backup.conf

# ParanoidAndroid Images
# PA_IMAGE_FILES := $(wildcard vendor/pa/prebuilt/preferences/images/*.png)
# PRODUCT_COPY_FILES += \
#     $(foreach f,$(PA_IMAGE_FILES),$(f):system/etc/paranoid/preferences/images/$(notdir $(f)))

# ParanoidAndroid Preferences
PA_PREF_FILES := $(wildcard vendor/fusion/prebuilt/pa/preferences/$(PA_CONF_SOURCE)/*.xml)
PRODUCT_COPY_FILES += \
    $(foreach f,$(PA_PREF_FILES),$(f):system/etc/paranoid/preferences/$(notdir $(f)))

BOARD := $(subst fusion_,,$(TARGET_PRODUCT))

# Add CM release version
CM_RELEASE := true
CM_BUILD := $(BOARD)

# Add PA release version
PA_VERSION_MAJOR = 3
PA_VERSION_MINOR = 9
PA_VERSION_MAINTENANCE = 9-RC2
PA_PREF_REVISION = 1
VERSION := $(PA_VERSION_MAJOR).$(PA_VERSION_MINOR)$(PA_VERSION_MAINTENANCE)
PA_VERSION := pa_$(BOARD)-$(VERSION)-$(shell date +%0d%^b%Y-%H%M%S)

# FUSION version
FUSION_VERSION_MAJOR = 1
FUSION_VERSION_MINOR = 0
FUSION_VERSION_MAINTENANCE = 4-KK-BETA
FUSION_VERSION := $(FUSION_VERSION_MAJOR).$(FUSION_VERSION_MINOR).$(FUSION_VERSION_MAINTENANCE)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.fusion.version=$(FUSION_VERSION) \
    ro.fusionrom.version=fusion_$(BOARD)_$(FUSION_VERSION)_$(shell date +%Y%m%d-%H%M%S) \
    ro.modversion=$(PA_VERSION) \
    ro.pa.family=$(PA_CONF_SOURCE) \
    ro.pa.version=$(VERSION) \
    ro.papref.revision=$(PA_PREF_REVISION) \
    ro.aokp.version=$(BOARD)_jb-mr2

# Disable ADB authentication and set root access to Apps and ADB
ADDITIONAL_DEFAULT_PROPERTIES += \
    ro.adb.secure=3 \
    persist.sys.root_access=3
