ifndef brew.mk
brew.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(brew.mk))/global/config.mk
include $(dir $(brew.mk))/global/system.mk

ifdef $(or $(global/system/linux), $(global/system/darwin))

brew/deps := \
	yarn

.PHONY: brew/setup
ifdef global/system/linux
brew/setup := /home/linuxbrew/.linuxbrew/bin/brew
endif
ifdef global/system/darwin
brew/setup := /usr/local/homebrew/bin/brew
endif
$(brew/setup):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
brew/setup: $(brew/setup)

.IGNORE \
.PHONY: brew/trash
brew/trash:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

brew/install := $(patsubst %,brew/install/%,$(brew/deps))
ifdef global/system/linux
/home/linuxbrew/.linuxbrew/Cellar/%:
	brew install $*
$(brew/install): brew/install/%: /home/linuxbrew/.linuxbrew/Cellar/%
endif
ifdef global/system/darwin
/usr/local/homebrew/Cellar/%:
	brew install $*
$(brew/install): brew/install/%: /usr/local/homebrew/Cellar/%
endif
.PHONY: $(brew/install)

brew/uninstall := $(patsubst %,brew/uninstall/%,$(brew/deps))
.IGNORE \
.PHONY: $(brew/uninstall)
$(brew/uninstall): brew/uninstall/%:
	brew uninstall $*

endif # global/system.mk
endif # brew.mk
