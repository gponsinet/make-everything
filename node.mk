ifndef node.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
node.mk := $(dotmk)/node.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/conflate.mk

export NODE_VERSION ?= latest
ifeq ($(CURDIR),$(HOME))
 export PATH := $(CURDIR)/node_modules/.bin:$(PATH)
endif

.PHONY: \
	install \
	install.node

install: install.node
install.node: install.conflate
install.node: install.volta
	volta install node@$(NODE_VERSION)
ifneq ($(CURDIR),$(HOME))
	[ ! -f package.json ] || volta pin node@$(NODE_VERSION)
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
	[ ! -f package.json ] || volta unpin node
endif

.gitignore \
: %: $(dotmk)/%

endif
