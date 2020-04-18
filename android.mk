ifndef android.mk
android.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(android.mk))/global/config.mk
include $(dir $(android.mk))/global/system.mk
include $(dir $(android.mk))/global/helper.mk
include $(dir $(android.mk))/brew.mk

android.path := $(PWD)/.android

export ANDROID_HOME := $(android.path)
export PATH := $(android.path)/tools/bin:$(PATH)

android.tools.href :=
ifdef global/system/linux
android.tools.href := \
	https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
else ifdef global/system/darwin
android.tools.href := \
	https://dl.google.com/android/repository/commandlinetools-mac-6200805_latest.zip
else ifdef global/system/windows
android.tools.href := \
	https://dl.google.com/android/repository/commandlinetools-win-6200805_latest.zip
endif

.PHONY: install.android
install.android: \
	$(brew.path)/Cellar/wget \
	$(brew.path)/Cellar/unzip \
	$(brew.path)/Cellar/adoptopenjdk \
	$(android.path)

.PHONY: update.android
update.android: install.android
	sdkmanager --sdk_root=$(ANDROID_HOME) --update

.IGNORE \
.PHONY: clean.android
clean.android:
	rm -rf $(android.path)

$(android.path): | \
	$(android.path)/tools \
	$(android.path)/build-tools \
	$(android.path)/platform-tools \
	$(android.path)/platforms \
	$(android.path)/emulator

$(android.path)/tools: | $(android.path)/
	wget -O $@.zip $(android.tools.href)
	unzip -d $(android.path) $@.zip

$(android.path)/licenses: | $(android.path)/tools
	sdkmanager --sdk_root=$(ANDROID_HOME) --licenses || true

$(android.path)/build-tools: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'build-tools;$(call ask,android,build-tools/version,29.0.3)' \
		|| (rm -rf $@ && false)

$(android.path)/platform-tools: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) platform-tools

$(android.path)/platforms: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'platforms;$(call ask,android,platforms/version,android-29)' \
		|| (rm -rf $@ && false)

$(android.path)/emulator: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) emulator || (rm -rf $@ && false)

$(android.path)/:
	mkdir -p $@

$(brew.path)/Cellar/adoptopenjdk:
	brew install adoptopenjdk@8

endif # android.mk
