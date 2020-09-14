ifndef gpg.mk
gpg.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(gpg.mk))/global/config.mk
include $(dir $(gpg.mk))/global/system.mk
include $(dir $(gpg.mk))/brew.mk

.PHONY: \
	install \
	install.gpg

install: install.gpg
install.gpg: \
	$(brew.cellar)/gnupg

.PHONY: \
	clean \
	clean.gpg

clean: clean.gpg
clean.gpg:

.PHONY: \
	trash \
	trash.gpg

trash:
trash.gpg:
	brew uninstall gnupg

endif # gpg.mk
