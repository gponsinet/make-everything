ifndef eslint.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
eslint.mk := $(dotmk)/eslint.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk

.PHONY: \
	install \
	install.eslint

install: install.eslint
ifeq ($(CURDIR),$(HOME))
install.eslint:
	volta install eslint-cli@latest eslint_d@latest
else
install.eslint: package.json
endif

package.json: $(dotmk)/eslint/package.json

trash: trash.eslint
trash.volta: trash.eslint
trash.npm: trash.eslint
trash.eslint:
	rm .eslintrc.js

endif
