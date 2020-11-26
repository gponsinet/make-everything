ifndef javascript.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
javascript.mk := $(dotmk)/javascript.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/eslint.mk

.PHONY: \
	install \
	install.javascript

install: install.javascript
install.javascript: install.volta
install.javascript: install.eslint
ifeq ($(CURDIR),$(HOME))
install.javascript:
	volta install javascript-typescript-langserver
else
install.javascript: package.json
endif

.IGNORE \
.PHONY: \
	trash \
	trash.javascript

trash: trash.javascript
trash.eslint: trash.javascript
ifeq ($(CURDIR),$(HOME))
trash.javascript:
	volta uninstall javascript-typescript-langserver
endif

.SpaceVim.d/init.toml: $(dotmk)/javascript/.SpaceVim.d/init.toml

endif
