ifndef node.mk
node.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(node.mk))/config.mk
include $(dir $(node.mk))/volta.mk

export NODE_VERSION ?= latest

node := $(VOLTA_HOME)/bin/node

.PHONY: \
	install \
	install.node

install: install.node
install.node: install.volta
	volta install node@$(NODE_VERSION)
ifneq ($(CURDIR),$(HOME))
	volta pin node@$(NODE_VERSION)
endif

ifneq ($(CURDIR),$(HOME))
install.node: package.json
endif

.IGNORE \
.PHONY: \
	clean \
	clean.node

clean: clean.node
clean.node:

.IGNORE \
.PHONY: \
	trash \
	trash.node

# trash: trash.node
# trash.volta: trash.node
trash.node:
ifeq ($(CURDIR),$(HOME))
	volta uninstall node
else
	volta uninstall node@$(NODE_VERSION)
	volta unpin node
endif

endif
