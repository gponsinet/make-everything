ifndef typescript.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
typescript.mk := $(dotmk)/typescript.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/conflate.mk

export TYPESCRIPT_VERSION ?= latest
ifeq ($(CURDIR),$(HOME))
 export TYPESCRIPT_SERVER_PATH ?= $(VOLTA_HOME)/bin/tsserver
else
 export TYPESCRIPT_SERVER_PATH ?= node_modules/.bin/tsserver
endif

.PHONY: \
	install \
	install.volta

install: install.typescript
install.typescript: install.volta
ifeq ($(CURDIR),$(HOME))
	volta install typescript@$(TYPESCRIPT_VERSION) typescript-language-server
else
install.typescript: package.json tsconfig.json
endif

.IGNORE \
.PHONY: \
	trash \
	trash.typescript

# trash: trash.typescript
# trash.volta: trash.typescript
trash.typescript:
ifeq ($(CURDIR),$(HOME))
	volta uninstall typescript@$(TYPESCRIPT_VERSION) typescript-language-server
else
	rm tsconfig.json
endif

ifneq ($(CURDIR),$(HOME))
install.typescript: tsconfig.json
tsconfig.json:
	conflate -expand -data tsconfig.json $(foreach %,-data %,$^) | sponge $@
endif

package.json: $(dotmk)/typescript/package.json
.SpaceVim.d/init.toml: $(dotmk)/typescript/.SpaceVim.d/init.toml

endif
