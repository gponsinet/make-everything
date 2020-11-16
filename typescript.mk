ifndef typescript.mk
typescript.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(typescript.mk))/config.mk
include $(dir $(typescript.mk))/volta.mk

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
	volta uninstall typescript@$(TYPESCRIPT_VERSION) typescript-language-server

package.json: $(dir $(typescript.mk))/typescript/package.json
.SpaceVim.d: $(dir $(typescript.mk))/typescript/.SpaceVim.d/init.toml

endif
