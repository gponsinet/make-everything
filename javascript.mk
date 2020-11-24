ifndef javascript.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
javascript.mk := $(dotmk)/javascript.mk

include $(dotmk)/config.mk
include $(dotmk)/volta.mk
ifndef yarn.mk
include $(dotmk)/npm.mk
endif

.PHONY: \
	install \
	install.javascript

install: install.javascript
install.javascript: install.volta
ifndef yarn.mk
install.javascript: install.npm
else
install.javascript: install.yarn
endif

.IGNORE \
.PHONY: \
	trash \
	trash.javascript

trash: trash.javascript
ifndef yarn.mk
trash.npm: trash.javascript
else
trash.yarn: trash.javascript
endif
trash.javascript:
	volta uninstall eslint-cli javascript-typescript-langserver

endif
