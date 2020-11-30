ifndef pyenv.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
pyenv.mk := $(dotmk)/pyenv.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

export PYENV_ROOT := $(HOME)/.pyenv

.PHONY: \
	install \
	install.pyenv

install: install.pyenv
install.pyenv: \
	$(BREW_CELLAR)/pyenv

.IGNORE \
.PHONY: \
	trash \
	trash.pyenv

trash: trash.pyenv
trash.pyenv:
	brew uninstall pyenv

endif
