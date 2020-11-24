ifndef gpg.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
gpg.mk := $(dotmk)/gpg.mk

include $(dotmk)/dotmk.mk

include $(dotmk)/brew.mk

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
