ifndef pass.mk
pass.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(pass.mk))/config.mk
include $(dir $(pass.mk))/brew.mk
include $(dir $(gpg.mk))/gpg.mk

.PHONY: \
	install \
	install.pass

install: install.pass
install.pass: \
	install.brew \
	$(brew.tap)/amar1729/formulae \
	$(brew.cellar)/pass \
	$(brew.cellar)/browserpass \

.IGNORE \
.PHONY: \
	trash \
	trash.pass
# trash: trash.pass
# trash.brew: trash.pass
trash.pass:
	brew uninstall pass browserpass 

endif
