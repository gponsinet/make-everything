ifndef $(dotmk)/android.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
android.mk := $(dotmk)/android.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

ifdef system/linux
 export ANDROID_HOME ?= $(HOME)/.android
 export ANDROID_TOOLS_HREF ?= https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
else ifdef system/darwin
 export ANDROID_HOME ?= $(HOME)/Library/Android/sdk
 export ANDROID_TOOLS_HREF ?= https://dl.google.com/android/repository/commandlinetools-mac-6200805_latest.zip
else ifdef system/windows
 export ANDROID_HOME ?=
 export ANDROID_HOME_HREF ?= https://dl.google.com/android/repository/commandlinetools-win-6200805_latest.zip
endif

export ANDROID_BUILD_TOOLS_VERSION ?= 29.0.3
export ANDROID_PLATFORM ?= android-29
export ANDROID_SYSTEM_IMAGE ?= $(ANDROID_PLATFORM);default;x86
export ANDROID_EMULATOR ?= default

export PATH := $(ANDROID_HOME)/tools/bin:$(PATH)

.PHONY: \
	install \
	install.android \
	install.android.tools \
	install.android.build-tools \
	install.android.platform-tools \
	install.android.platform \
	install.android.emulator \
	install.android.system-image

install:

install.android: \
	install.android.tools \
	install.android.build-tools \
	install.android.platform-tools \
	install.android.platforms \
	install.android.emulator

install.android.tools: \
	$(ANDROID_HOME)/tools

install.android.build-tools:
	make $(ANDROID_HOME)/build-tools/$(ANDROID_BUILD_TOOLS_VERSION)

install.android.platform-tools:
	make $(ANDROID_HOME)/platform-tools

install.android.platform:
	make $(ANDROID_HOME)/platforms/$(ANDROID_PLATFORM)

install.android.emulator: create.android.emulator

install.android.system-image:
	make $(ANDROID_HOME)/system-images/$(subst ;,/,$(ANDROID_SYSTEM_IMAGE))

.PHONY: create.android.emulator
create.android.emulator: $(ANDROID_HOME)/emulator install.android.system-image
	avdmanager create avd \
		-n $(ANDROID_EMULATOR) \
		-k "system-images;$(ANDROID_SYSTEM_IMAGE)" \

.PHONY: \
	update \
	update.android

update.android: install.android
	sdkmanager --sdk_root=$(ANDROID_HOME) --update

.IGNORE \
.PHONY: \
	clean \
	clean.android

clean: clean.android
clean.android:

.IGNORE \
.PHONY: \
	trash \
	trash.android

trash: trash.android
trash.android: clean.android
	rm -rf $(ANDROID_HOME)

$(ANDROID_HOME): | \
		$(BREW_HOME)/Cellar/wget \
		$(BREW_HOME)/Cellar/unzip \
		$(BREW_HOME)/Cellar/adoptopenjdk
	mkdir -p $@

$(ANDROID_HOME)/tools: | $(ANDROID_HOME)
	wget -O $@.zip $(ANDROID_TOOLS_HREF)
	unzip -d $(ANDROID_HOME) $@.zip

$(ANDROID_HOME)/licenses: | $(ANDROID_HOME)/tools
	sdkmanager --sdk_root=$(ANDROID_HOME) --licenses || true

$(ANDROID_HOME)/build-tools/%: | $(ANDROID_HOME)/tools $(ANDROID_HOME)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'build-tools;$*' \
		|| (rm -rf $@ && false)

$(ANDROID_HOME)/platform-tools: | $(ANDROID_HOME)/tools $(ANDROID_HOME)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) platform-tools

$(ANDROID_HOME)/platforms/%: | $(ANDROID_HOME)/tools $(ANDROID_HOME)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'platforms;' \
		|| (rm -rf $@ && false)

$(ANDROID_HOME)/emulator: | $(ANDROID_HOME)/tools $(ANDROID_HOME)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) emulator || (rm -rf $@ && false)

$(ANDROID_HOME)/system-images/%: | $(ANDROID_HOME)/tools $(ANDROID_HOME)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'system-images;$(subst /,;,$*)' || (rm -rf $@ && false)

$(BREW_HOME)/Cellar/adoptopenjdk:
	brew install adoptopenjdk@8

endif # android.mk
