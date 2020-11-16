ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(react-native.mk))/config.mk
include $(dir $(react-native.mk))/android.mk
ifndef yarn.mk
include $(dir $(react-native.mk))/npm.mk
endif

.PHONY: \
	install \
	install.react-native

install: install.react-native
install.react-native: node_modules
install.react-native.android: \
	install.react-native \
	install.android.tools \
	install.android.platform-tools \
	install.android.emulator

.IGNORE \
.PHONY: \
	trash \
	trash.react-native \
	trash.react-native.android

trash: trash.react-native
trash.react-native: clean.react-native

endif # react-native.mk
