ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/config.mk
include $(dir $(yarn.mk))/volta.mk
include $(dir $(yarn.mk))/node.mk

export YARN_VERSION ?= latest

yarn := $(VOLTA_HOME)/bin/yarn

.PHONY: \
	install \
	install.yarn

install: install.yarn
install.yarn: install.volta
	volta install yarn@$(YARN_VERSION)
	volta pin yarn@$(YARN_VERSION)

.IGNORE \
.PHONY: \
	clean \
	clean.yarn

clean: clean.yarn
clean.yarn:
	yarn cache clean

.IGNORE \
.PHONY: \
	trash \
	trash.yarn

# trash: trash.yarn
# trash.volta: trash.yarn
trash.node: trash.yarn
trash.npm:
	volta uninstall yarn@$(NPM_VERSION)
	rm yarn.lock

endif # yarn.mk
