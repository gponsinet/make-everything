ifndef javascript.mk
javascript.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(javascript.mk))/config.mk
include $(dir $(javascript.mk))/volta.mk
ifndef yarn.mk
include $(dir $(javascript.mk))/npm.mk
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

package.json: $(dir $(javascript.mk))/javascript/package.json
.SpaceVim.d: $(dir $(javascript.mk))/javascript/.SpaceVim.d/init.toml

endif
