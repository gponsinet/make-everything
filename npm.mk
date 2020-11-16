ifndef npm.mk
npm.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(npm.mk))/config.mk
include $(dir $(npm.mk))/volta.mk
include $(dir $(npm.mk))/node.mk

export NPM_VERSION ?= latest

npm := $(VOLTA_HOME)/bin/npm

.PHONY: \
	install \
	install.npm

install: install.npm
install.npm: install.volta
install.npm: install.node
	volta install npm@$(NPM_VERSION)
	volta pin node@$(NPM_VERSION)

.IGNORE \
.PHONY: \
	clean \
	clean.npm

clean: clean.npm
clean.npm:
	npm cache clean

.IGNORE \
.PHONY: \
	trash \
	trash.npm

# trash: trash.npm
# trash.volta: trash.npm
trash.node: trash.npm
trash.npm:
	volta uninstall npm@$(NPM_VERSION)
	rm package-lock.json

endif
