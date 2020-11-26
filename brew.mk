ifndef brew.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
brew.mk := $(dotmk)/brew.mk

include $(dotmk)/dotmk.mk

ifdef $(or $(system/linux), $(system/darwin))

ifdef system/linux
 export BREW_HOME ?= /home/linuxbrew/.linuxbrew
else ifdef system/darwin
 export BREW_HOME ?= /usr/local
endif

export PATH := $(BREW_HOME)/bin:$(PATH)

BREW_CELLAR := $(BREW_HOME)/Cellar
BREW_TAP := $(BREW_HOME)/Homebrew/Library/Taps

.PHONY: \
	install \
	install.brew

install: install.brew
install.brew: $(BREW_HOME)

.IGNORE \
.PHONY: \
	clean \
	clean.brew

clean: clean.brew
clean.brew:

.IGNORE \
.PHONY: \
	trash \
	trash.brew

trash:
trash.brew: clean.brew
	sudo ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
	sudo rm -rf $(BREW_HOME)

$(BREW_HOME):
	[ -d "$@" ] || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

$(BREW_CELLAR)/%: options ?=
$(BREW_CELLAR)/%: | $(BREW_HOME)
	brew install --force $* $(options)
	brew link --overwrite $*

$(BREW_TAP)/%: | $(BREW_HOME)
	BREW_TAP $(subst homebrew-,,$*)

endif # system.mk
endif # brew.mk
