ifndef android.mk
android.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(android.mk))/global/config.mk
include $(dir $(android.mk))/global/system.mk
include $(dir $(android.mk))/global/helper.mk
include $(dir $(android.mk))/brew.mk

android.path := $(HOME)/.android

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
	$(android.path)/tools

.IGNORE \
.PHONY: clean.android
clean.android:
	rm -rf $(android.path)/tools

$(brew.path)/Cellar/adoptopenjdk:
	brew install adoptopenjdk@8

$(android.path)/tools: | $(android.path)/
	wget -O $@.zip $(android.tools.href)
	unzip -d $(android.path) $@.zip

$(android.path)/:
	mkdir -p $@

endif # android.mk
