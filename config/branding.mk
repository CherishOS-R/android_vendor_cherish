# Set all versions
CHERISH_BUILD_TYPE ?= UNOFFICIAL

CUSTOM_DATE_YEAR := $(shell date -u +%Y)
CUSTOM_DATE_MONTH := $(shell date -u +%m)
CUSTOM_DATE_DAY := $(shell date -u +%d)
CUSTOM_DATE_HOUR := $(shell date -u +%H)
CUSTOM_DATE_MINUTE := $(shell date -u +%M)
CUSTOM_BUILD_DATE_UTC := $(shell date -d '$(CUSTOM_DATE_YEAR)-$(CUSTOM_DATE_MONTH)-$(CUSTOM_DATE_DAY) $(CUSTOM_DATE_HOUR):$(CUSTOM_DATE_MINUTE) UTC' +%s)
CUSTOM_BUILD_DATE := $(CUSTOM_DATE_YEAR)$(CUSTOM_DATE_MONTH)$(CUSTOM_DATE_DAY)-$(CUSTOM_DATE_HOUR)$(CUSTOM_DATE_MINUTE)

CUSTOM_PLATFORM_VERSION := 11.0

CHERISH_VERSION := 2.0-Beta

CUSTOM_DATE_CODE := $(CUSTOM_DATE_HOUR)$(CUSTOM_DATE_MINUTE)

TARGET_PRODUCT_SHORT := $(subst cherish_,,$(CHERISH_BUILD))

ifeq ($(CHERISH_WITHGAPPS), true)
CHERISH_MOD_VERSION := Cherish-OS-v$(CHERISH_VERSION)-$(CUSTOM_BUILD_DATE)-$(CHERISH_BUILD)-$(CHERISH_BUILD_TYPE)-Gapps
else
CHERISH_MOD_VERSION := Cherish-OS-v$(CHERISH_VERSION)-$(CUSTOM_BUILD_DATE)-$(CHERISH_BUILD)-$(CHERISH_BUILD_TYPE)-Vanilla
endif
CUSTOM_VERSION_PROP := 11

CUSTOM_PROPERTIES := \
    ro.cherish.version=$(CHERISH_VERSION) \
    ro.cherish.version.display=$(CHERISH_MOD_VERSION) \
    ro.cherish.build_date=$(CUSTOM_BUILD_DATE) \
    ro.cherish.build_date_utc=$(CUSTOM_BUILD_DATE_UTC) \
    ro.cherish.build_type=$(CHERISH_BUILD_TYPE) 
