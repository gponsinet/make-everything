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

.IGNORE \
.PHONY: \
	trash \
	trash.flow

trash:
trash.javascript: trash.flow
trash.flow:
	volta uninstall flow-bin


ifneq ($(CURDIR),$(HOME))
package.json: $(dotmk)/package.json
endif

.SpaceVim.d/init.toml: $(dotmk)/flow/.SpaceVim.d/custom.toml

endif
