ifndef flow.mk
flow.mk := $(lastword $(MAKEFILE_LIST))

include $(DOTMK_HOME)/config.mk
include $(DOTMK_HOME)/javascript.mk

.PHONY: \
	install \
	install.javascript

install: install.flow
install.flow: install.javascript
install.flow: package.json
package.json: $(dir $(flow.mk))/package.json

.IGNORE \
.PHONY: \
	trash \
	trash.flow

trash:
trash.javascript: trash.flow
trash.flow:
	volta uninstall flow-bin

package.json: $(dir $(flow.mk))/flow/package.json
.SpaceVim.d: $(dir $(flow.mk))/flow/.SpaceVim.d/init.toml

endif
