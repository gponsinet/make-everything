ifndef flow.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
flow.mk := $(dotmk)/flow.mk

include $(DOTMK_HOME)/dotmk.mk
include $(DOTMK_HOME)/javascript.mk

.PHONY: \
	install \
	install.javascript

install: install.flow
install.flow: install.javascript
ifeq ($(CURDIR),$(HOME))
install.flow:
	volta install flow-bin
else
install.flow: package.json
endif

.IGNORE \
.PHONY: \
	trash \
	trash.flow

trash:
trash.javascript: trash.flow
trash.flow:
	volta uninstall flow-bin

package.json: $(dotmk)/flow/package.json
.SpaceVim.d/init.toml: $(dotmk)/flow/.SpaceVim.d/init.toml

endif
