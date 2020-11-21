ifndef flow.mk
flow.mk := $(lastword $(MAKEFILE_LIST))

include $(DOTMK_HOME)/config.mk
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
package.json: $(dir $(flow.mk))/package.json
endif

.SpaceVim.d/init.toml: $(dir $(flow.mk))/flow/.SpaceVim.d/init.toml

endif
