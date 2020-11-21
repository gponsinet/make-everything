ifndef babel.mk
babel.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(babel.mk))/config.mk
ifndef yarn.mk
include $(dir $(babel.mk))/npm.mk
endif

.PHONY: \
	install \
	install.node

install: install.babel
install.babel:

.IGNORE \
.PHONY: \
	trash \
	trash.babel

trash: trash.babel
trash.babel:


ifneq ($(CURDIR),$(HOME))
package.json: $(dir $(babel.mk))/babel/package.json
endif

.SpaceVim.d/init.toml: $(dir $(babel.mk))/babel/.SpaceVim.d/init.toml

endif
