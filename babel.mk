ifndef babel.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
babel.mk := $(dotmk)/babel.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/javascript.mk

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
package.json: $(dotmk)/babel/package.json
endif

.SpaceVim.d/init.toml: $(dotmk)/babel/.SpaceVim.d/custom.toml

endif
