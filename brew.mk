ifndef brew.mk
brew.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(brew.mk))/global/config.mk
include $(dir $(brew.mk))/global/system.mk

ifdef $(or $(global/system/linux), $(global/system/darwin))

ifdef global/system/linux
brew/path := /home/linuxbrew/.linuxbrew
else ifdef global/system/darwin
brew/path := /usr/local/homebrew
endif

.PHONY: brew/setup
brew/setup := $(brew/path)/bin/brew
$(brew/setup):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew/setup: $(brew/setup)

.IGNORE \
.PHONY: brew/trash
brew/trash:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

.PHONY: brew/install/%
brew/install := $(brew/path)/Cellar
$(brew/install)/%: $(brew/setup)
	brew install $*
	touch $(brew/path)/Cellar/*
brew/install/%:
	$(MAKE) $(brew/install)/$*

.IGNORE: brew/uninstall/%
.PHONY: brew/uninstall/%
brew/uninstall/%:
	brew uninstall $*

endif # global/system.mk
endif # brew.mk
