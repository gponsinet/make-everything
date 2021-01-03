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
BREW_BIN := $(BREW_HOME)/bin

.PHONY: install.brew
install: install.brew
install.brew: brew

.IGNORE \
.PHONY: \
	trash \
	trash.brew

trash:
trash.brew: ~brew

.PHONY: brew brew/% brew(%)
.IGNORE \
.PHONY: brew ~~brew/% ~brew(%)

.PHONY: brew
brew: $(BREW_HOME)
	@true

.PHONY: brew(%)
brew(%):
	make $(foreach _,$*,brew/$_)

.PHONY: brew/%
brew/%:
	(echo $* | grep '/' && make $(BREW_TAP)/$*) || make $(BREW_CELLAR)/$*

.IGNORE .PHONY: ~brew
~brew:
	sudo ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"
	sudo rm -rf $(BREW_HOME)

.IGNORE .PHONY: ~brew(%)
~brew(%):
	make $(foreach _,$*,~brew/$_)

.IGNORE .PHONY: ~brew/%
~brew/%:
	(echo $* | grep '/' && brew untap $*) || brew uninstall $*

$(BREW_HOME):
	[ -d "$@" ] || /bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

$(BREW_CELLAR)/%: options ?=
$(BREW_CELLAR)/%: | $(BREW_HOME)
	brew install --force $* $(options)
	brew link --overwrite $*

$(BREW_TAP)/%: | $(BREW_HOME)
	brew tap $(subst homebrew-,,$*)

$(BREW_BIN)/%: $(BREW_CELLAR)/%
	@true

endif # system.mk
endif # brew.mk
