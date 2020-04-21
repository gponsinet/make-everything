ifndef android.mk
android.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(android.mk))/global/config.mk
include $(dir $(android.mk))/global/system.mk
include $(dir $(android.mk))/global/helper.mk
include $(dir $(android.mk))/brew.mk

android.path :=
android.tools.href :=
ifdef global/system/linux
android.path := $(HOME)/.android
android.tools.href := \
	https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip
else ifdef global/system/darwin
android.path := $(HOME)/Library/Android/sdk
android.tools.href := \
	https://dl.google.com/android/repository/commandlinetools-mac-6200805_latest.zip
else ifdef global/system/windows
android.tools.href := \
	https://dl.google.com/android/repository/commandlinetools-win-6200805_latest.zip
endif

export ANDROID_HOME := $(android.path)
export PATH := $(android.path)/tools/bin:$(PATH)

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
	$(brew.path)/Cellar/wget \
	$(brew.path)/Cellar/unzip \
	$(brew.path)/Cellar/adoptopenjdk \
	install.android.tools \
	install.android.build-tools \
	install.android.platform-tools \
	install.android.platforms \
	install.android.emulator

install.android.tools: \
	$(android.path)/tools

install.android.build-tools: \
	version = $(call ask,android,build-tools,29.0.3)
install.android.build-tools:
	$(MAKE) $(android.path)/build-tools/$(version)

install.android.platform-tools:
	$(MAKE) $(android.path)/platform-tools

install.android.platform: \
	version = $(call ask,android,platform,android-29)
install.android.platform:
	$(MAKE) $(android.path)/platforms/$(version)

install.android.emulator: create.android.emulator

install.android.system-image: \
	system-image = \
		$(call ask,android,system-image,android-29;default;x86)
install.android.system-image:
	$(MAKE) $(android.path)/system-images/$(subst ;,/,$(system-image))

.PHONY: \
	create.android.emulator

create.android.emulator: \
	name = $(call ask,android.emulator,name,default)
create.android.emulator: \
		$(android.path)/emulator install.android.system-image
	avdmanager create avd \
		-n $(name) \
		-k "system-images;$(android/system-image)" \

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
	rm -rf $(android.path)

$(android.path):
	mkdir -p $@

$(android.path)/tools: | $(android.path)
	wget -O $@.zip $(android.tools.href)
	unzip -d $(android.path) $@.zip

$(android.path)/licenses: | $(android.path)/tools
	sdkmanager --sdk_root=$(ANDROID_HOME) --licenses || true

$(android.path)/build-tools/%: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'build-tools;$*' \
		|| (rm -rf $@ && false)

$(android.path)/platform-tools: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) platform-tools

$(android.path)/platforms/%: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'platforms;' \
		|| (rm -rf $@ && false)

$(android.path)/emulator: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) emulator || (rm -rf $@ && false)

$(android.path)/system-images/%: | $(android.path)/tools $(android.path)/licenses
	sdkmanager --sdk_root=$(ANDROID_HOME) 'system-images;$(subst /,;,$*)' || (rm -rf $@ && false)

$(brew.path)/Cellar/adoptopenjdk:
	brew install adoptopenjdk@8

endif # android.mk
