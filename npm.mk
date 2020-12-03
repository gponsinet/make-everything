ifndef npm.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
npm.mk := $(dotmk)/npm.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/node.mk

export NPM_VERSION ?= 7

npm := $(VOLTA_HOME)/bin/npm

.PHONY: \
	install \
	install.npm

install: install.npm
install.npm: install.volta
install.npm: install.node
ifneq ($(CURDIR),$(HOME))
install.npm: node_modules
endif
install.npm:
	volta install npm@$(NPM_VERSION)
ifneq ($(CURDIR),$(HOME))
	[ -f package.json ] || volta pin npm@$(NPM_VERSION)
endif

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
ifeq ($(CURDIR),$(HOME))
	volta uninstall npm
else
	volta uninstall npm@$(NPM_VERSION)
	volta unpin npm
endif
	rm -f package-lock.json

ifneq ($(CURDIR),$(HOME))
package.json:
	npm init
	volta pin node@$(NODE_VERSION)
	volta pin npm@$(NPM_VERSION)
	conflate -expand -data package.json $(foreach pre,$^,-data $(pre)) -format JSON | sponge $@

node_modules: package.json
	npm install
	touch $@

package.json: $(dotmk)/npm/package.json
endif

endif
