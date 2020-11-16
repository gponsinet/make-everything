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
install.babel: package.json

.IGNORE \
.PHONY: \
	trash \
	trash.babel

trash: trash.babel
trash.babel:

package.json: $(dir $(typescript.mk))/babel/package.json

endif
