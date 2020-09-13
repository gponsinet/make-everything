ifndef brew.mk
brew.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(brew.mk))/global/config.mk
include $(dir $(brew.mk))/global/system.mk

ifdef $(or $(global/system/linux), $(global/system/darwin))

ifdef global/system/linux
brew.path := /home/linuxbrew/.linuxbrew
else ifdef global/system/darwin
brew.path := /usr/local
endif
brew.cellar := $(brew.path)/Cellar
brew.tap := $(brew.path)/Homebrew/Library/Taps

.PHONY: \
	install \
	install.brew

install: install.brew
install.brew: $(brew.path)

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
	sudo rm -rf $(brew.path)

$(brew.path):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

$(brew.cellar)/%: options ?=
$(brew.cellar)/%: | $(brew.path)
	brew install $* $(options)

ifdef global/system/darwin
$(brew.tap)/%: $(brew.tap)/homebrew-%
$(brew.tap)/homebrew-%: | $(brew.path)
	brew tap $@
else
$(brew.tap)/%: | $(brew.path)
	brew tap $(subst homebrew-,,$*)
endif

endif # global/system.mk
endif # brew.mk
