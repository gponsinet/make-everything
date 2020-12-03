ifndef yarn.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
yarn.mk := $(dotmk)/yarn.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/node.mk

export YARN_VERSION ?= latest

yarn := $(VOLTA_HOME)/bin/yarn

.PHONY: \
	install \
	install.yarn

install: install.yarn
install.yarn: install.volta
install.yarn: install.node
ifneq ($(CURDIR),$(HOME))
install.yarn: node_modules
endif
install.yarn:
	volta install yarn@$(YARN_VERSION)
ifneq ($(CURDIR),$(HOME))
	[ -f package.json ] || volta pin yarn@$(YARN_VERSION)
endif

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
trash.yarn:
ifeq ($(CURDIR),$(HOME))
	volta uninstall yarn
else
	volta uninstall yarn@$(YARN_VERSION)
	volta unpin yarn
endif
	rm yarn.lock

ifneq ($(CURDIR),$(HOME))
package.json:
	npm init
	volta pin node@$(NODE_VERSION)
	volta pin yarn@$(YARN_VERSION)
	# conflate -expand -data package.json $(foreach pre,$^,-data $(pre)) -format JSON | sponge $@

node_modules: package.json
	yarn
	touch $@

package.json: $(dotmk)/yarn/package.json
endif

endif # yarn.mk
