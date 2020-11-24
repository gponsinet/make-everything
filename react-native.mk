ifndef react-native.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
react-native.mk := $(dotmk)/react-native.mk

include $(dotmk)/config.mk
include $(dotmk)/android.mk
ifndef yarn.mk
include $(dotmk)/npm.mk
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
