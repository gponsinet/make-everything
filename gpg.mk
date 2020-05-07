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
	clean.gnupg

clean: clean.gnupg
clean.gnupg:

.PHONY: \
	trash \
	trash.gnupg

trash:
trash.gnupg:
	brew uninstall gnupg

endif # gpg.mk
