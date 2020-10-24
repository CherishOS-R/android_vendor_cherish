PRODUCT_BRAND ?= CherishOS

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.android.dateformat=MM-dd-yyyy \
    persist.sys.disable_rescue=true \
    ro.setupwizard.rotation_locked=true

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1
endif

# Blur 
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
	
# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cherish/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/cherish/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cherish/prebuilt/common/bin/50-base.sh:system/addon.d/50-base.sh

# We modify several neverallows, so let the build proceed
ifneq ($(TARGET_BUILD_VARIANT),user)
    SELINUX_IGNORE_NEVERALLOWS := true
endif

# OTA
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif

ifneq ($(AB_OTA_PARTITIONS),)
PRODUCT_COPY_FILES += \
    vendor/cherish/prebuilt/common/bin/backuptool_ab.sh:system/bin/backuptool_ab.sh \
    vendor/cherish/prebuilt/common/bin/backuptool_ab.functions:system/bin/backuptool_ab.functions \
    vendor/cherish/prebuilt/common/bin/backuptool_postinstall.sh:system/bin/backuptool_postinstall.sh
endif

# Some permissions
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/backup.xml:system/etc/sysconfig/backup.xml \
    vendor/cherish/config/permissions/privapp-permissions-livedisplay.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-livedisplay.xml \
    vendor/cherish/config/permissions/privapp-permissions-lineagehw.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-lineagehw.xml \
    vendor/cherish/config/permissions/privapp-permissions-cherish.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-cherish.xml
# Copy all custom init rc files
$(foreach f,$(wildcard vendor/cherish/prebuilt/common/etc/init/*.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):system/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/cherish/prebuilt/common/lib/content-types.properties:system/lib/content-types.properties

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:system/usr/keylayout/Vendor_045e_Product_0719.kl

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=disable

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/custom-power-whitelist.xml:system/etc/sysconfig/custom-power-whitelist.xml

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Include CherishOS Themes Styles
include vendor/themes/themes.mk

# Charger
PRODUCT_PACKAGES += \
    charger_res_images
    
# Required packages
PRODUCT_PACKAGES += \
    BluetoothExt \
    ThemePicker \
	 CherishThemesStub

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.exfat \
    fsck.ntfs \
    mke2fs \
    mkfs.exfat \
    mkfs.ntfs \
    mount.ntfs

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# Media
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/cherish/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/cherish/overlay/common

# OmniStyle
PRODUCT_PACKAGES += \
    OmniStyle \
    
# PixelSetupWizard overlay
PRODUCT_PACKAGES += \
    PixelSetupWizardOverlay \
    PixelSetupWizardAodOverlay

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    NexusLauncherRelease

# Allows registering device to Google easier for gapps
# Integrates package for easier Google Pay fixing
PRODUCT_PACKAGES += \
    sqlite3

# Brightness Slider
PRODUCT_PACKAGES += \
    BrightnessSliderOverlay

# Long Screenshot
PRODUCT_PACKAGES += \
    StitchImage
    
# TouchGestures
PRODUCT_PACKAGES += \
    TouchGestures

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED := true
ifneq ($(TARGET_DISABLE_ALTERNATIVE_FACE_UNLOCK), true)
PRODUCT_PACKAGES += \
    FaceUnlockService
TARGET_FACE_UNLOCK_SUPPORTED := true
endif
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face.moto_unlock_service=$(TARGET_FACE_UNLOCK_SUPPORTED)

# Branding
include vendor/cherish/config/branding.mk

# OTA
include vendor/cherish/config/ota.mk

# Inherit from GMS product config
ifeq ($(CHERISH_WITHGAPPS), true)
$(call inherit-product, vendor/gapps/gapps.mk)
else
# AOSP Apps
include vendor/cherish/config/basicapps.mk
endif

# Bootanimation
ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
     PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
     PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_1440.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
     PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_720.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else
    ifeq ($(TARGET_BOOT_ANIMATION_RES),)
        $(warning "CherishStyle: TARGET_BOOT_ANIMATION_RES is undefined, assuming 1080p")
    else
        $(warning "CherishStyle: Current bootanimation res is not supported, forcing 1080p")
    endif
    PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
endif

# Plugins
#include packages/apps/PotatoPlugins/plugins.mk

-include $(WORKSPACE)/build_env/image-auto-bits.mk
