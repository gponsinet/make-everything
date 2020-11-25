ifndef javascript.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
javascript.mk := $(dotmk)/javascript.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/npm.mk
include $(dotmk)/yarn.mk

.PHONY: \
	install \
	install.javascript

install: install.javascript
install.javascript: install.volta
install.javascript: install.npm
install.javascript: install.yarn
install.javascript:
	volta install javascript-typescript-langserver

.IGNORE \
.PHONY: \
	trash \
	trash.javascript

trash: trash.javascript
trash.npm: trash.javascript
trash.yarn: trash.javascript
trash.javascript:
	volta uninstall javascript-typescript-langserver

endif
