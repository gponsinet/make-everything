ifndef gopass.mk
gopass.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(gopass.mk))/config.mk
include $(dir $(gopass.mk))/brew.mk
include $(dir $(gpg.mk))/gpg.mk

.PHONY: \
	install \
	install.gopass

install: install.gopass
install.gopass: \
	install.brew \
	$(brew.cellar)/gopass \
	$(brew.tap)/amar1729/formulae \
	$(brew.cellar)/browserpass \

.IGNORE \
.PHONY: \
	trash \
	trash.gopass
# trash: trash.gopass
# trash.brew: trash.gopass
trash.gopass:
	brew uninstall gopass browserpass 

endif
