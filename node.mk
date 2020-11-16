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
	volta pin node@$(NODE_VERSION)

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
	volta uninstall node@$(NODE_VERSION)

endif
