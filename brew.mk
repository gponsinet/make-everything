ifndef brew.mk
brew.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(brew.mk))/config.mk
include $(dir $(brew.mk))/system.mk

ifdef $(or $(system/linux), $(system/darwin))

ifdef system/linux
BREW_HOME := /home/linuxbrew/.linuxbrew
export PATH := $(BREW_HOME)/bin:$(PATH)
else ifdef system/darwin
BREW_HOME := /usr/local
endif
brew.cellar := $(BREW_HOME)/Cellar
brew.tap := $(BREW_HOME)/Homebrew/Library/Taps

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
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

$(BREW_HOME)/Cellar/%: options ?=
$(BREW_HOME)/Cellar/%: | $(BREW_HOME)
	brew install $* $(options)

ifdef system/darwin
$(brew.tap)/%: $(brew.tap)/homebrew-%
$(brew.tap)/homebrew-%: | $(BREW_HOME)
	brew tap $@
else
$(brew.tap)/%: | $(BREW_HOME)
	brew tap $(subst homebrew-,,$*)
endif

endif # system.mk
endif # brew.mk
