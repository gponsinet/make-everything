ifndef typescript.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
typescript.mk := $(dotmk)/typescript.mk

include $(dotmk)/config.mk
include $(dotmk)/volta.mk
include $(dotmk)/conflate.mk

TYPESCRIPT_VERSION := latest

.PHONY: \
	install \
	install.volta

install: install.typescript
install.typescript: install.volta
	volta install typescript@$(TYPESCRIPT_VERSION) typescript-language-server

.IGNORE \
.PHONY: \
	trash \
	trash.typescript

# trash: trash.typescript
# trash.volta: trash.typescript
trash.typescript:
	volta uninstall typescript typescript-language-server
ifneq ($(CURDIR),$(HOME))
	volta uninstall typescript@$(TYPESCRIPT_VERSION) typescript-language-server
endif

ifneq ($(CURDIR),$(HOME))
install.typescript: tsconfig.json
tsconfig.json:
	conflate -o $@ $^
endif

package.json: $(dotmk)/typescript/package.json
.SpaceVim.d/init.toml: $(dotmk)/typescript/.SpaceVim.d/init.toml

endif
