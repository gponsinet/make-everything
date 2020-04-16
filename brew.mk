ifndef brew.mk
brew.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(brew.mk))/global/config.mk
include $(dir $(brew.mk))/global/system.mk

ifdef $(or $(global/system/linux), $(global/system/darwin))

ifdef global/system/linux
brew.path := /home/linuxbrew/.linuxbrew
else ifdef global/system/darwin
brew.path := /usr/local/homebrew
endif

.PHONY: install.brew
install.brew: $(brew.path)

.IGNORE \
.PHONY: clean.brew
clean.brew:
	ruby -e "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/uninstall)"

.IGNORE \
.PHONY: trash.brew
trash.brew: clean.brew

$(brew.path):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

$(brew.path)/Cellar/%:
	brew install $*

endif # global/system.mk
endif # brew.mk
