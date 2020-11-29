ifndef react-native.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
react-native.mk := $(dotmk)/react-native.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/android.mk
include $(dotmk)/javascript.mk

export REACT_NATIVE_VERSION ?= latest

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
