ifndef gpg.mk
gpg.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(gpg.mk))/config.mk
include $(dir $(gpg.mk))/system.mk
include $(dir $(gpg.mk))/brew.mk

.PHONY: \
	install \
	install.gpg

install: install.gpg
install.gpg: \
	$(BREW_HOME)/Cellar/gnupg

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
