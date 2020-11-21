ifndef spacevim.mk
spacevim.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(spacevim.mk))/config.mk
include $(dir $(spacevim.mk))/brew.mk
include $(dir $(spacevim.mk))/conflate.mk

.PHONY: \
	install \
	install.spacevim

install: install.spacevim
install.spacevim: install.conflate
install.spacevim: \
	$(BREW_HOME)/Cellar/neovim \
	$(BREW_HOME)/Cellar/msgpack \
	$(BREW_HOME)/Cellar/python \
	$(BREW_HOME)/Cellar/global \
	$(HOME)/.SpaceVim \
	.SpaceVim.d/init.toml \
# 	$(yarn.global.mod)/import-js \
# 	$(yarn.global.mod)/javascript-typescript-langserver \
# 	$(yarn.global.mod)/typescript \
# 	$(yarn.global.mod)/javascript-typescript-langserver \
# 	$(yarn.global.mod)/typescript-language-server 

$(HOME)/.SpaceVim:
	curl -sLf https://spacevim.org/install.sh | bash

ifneq ($(CURDIR),$(HOME))
.SpaceVim.d/init.toml: $(HOME)/.SpaceVim/init.toml
endif

.SpaceVim.d/init.toml:
	# conflate -o $@ $^

.IGNORE \
.PHONY: \
	clean \
	clean.spacevim

clean: clean.spacevim
clean.spacevim:

.IGNORE \
.PHONY: \
	trash \
	trash.spacevim

trash: trash.spacevim
trash.spacevim:
	curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall
	rm -rf ~/.SpaceVim
	rm -rf ~/.cache/SpaceVim
	rm -rf ~/.cache/vimfiles
trash.spacevim.gtags:

endif # spacevim.mk
