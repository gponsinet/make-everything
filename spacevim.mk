ifndef spacevim.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
spacevim.mk := $(dotmk)/spacevim.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
include $(dotmk)/conflate.mk

.PHONY: \
	install \
	install.spacevim

install: install.spacevim
install.spacevim: install.conflate
install.spacevim: \
	$(BREW_HOME)/Cellar/neovim \
	$(BREW_HOME)/Cellar/msgpack \
	$(BREW_HOME)/Cellar/python@3.9 \
	$(BREW_HOME)/Cellar/global \
	$(HOME)/.SpaceVim \
	$(HOME)/.SpaceVim.d/init.toml \
	.SpaceVim.d/init.toml \
# 	$(yarn.global.mod)/import-js \
# 	$(yarn.global.mod)/javascript-typescript-langserver \
# 	$(yarn.global.mod)/typescript \
# 	$(yarn.global.mod)/javascript-typescript-langserver \
# 	$(yarn.global.mod)/typescript-language-server 

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

$(HOME)/.SpaceVim:
	curl -sLf https://spacevim.org/install.sh | bash

$(HOME)/.SpaceVim.d/init.toml:
	mkdir -p $(dir $@)
	touch $@

.SpaceVim.d/init.toml:
	conflate -o $@ $^ $(HOME)/.SpaceVim.d/init.toml

endif # spacevim.mk
