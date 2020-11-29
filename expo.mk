ifndef expo.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
expo.mk := $(dotmk)/expo.mk

.PHONY: \
	install \
	install.expo

install: install.expo
install.expo:
	volta install expo-cli

.IGNORE \
.PHONY: \
	trash \
	trash.expo

trash: trash.expo
trash.expo:
	volta uninstall expo-cli

endif
