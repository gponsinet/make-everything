ifndef spacevim.mk
spacevim.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(spacevim.mk))/global/config.mk
include $(dir $(spacevim.mk))/brew.mk
include $(dir $(spacevim.mk))/yarn.mk

.PHONY: \
	install \
	install.spacevim \
	install.spacevim.gtags \
	install.spacevim.js \

install: install.spacevim
install.spacevim: \
	$(brew.cellar)/neovim \
	$(HOME)/.SpaceVim
install.spacevim.gtags: \
	install.spacevim \
	$(brew.cellar)/global
install.spacevim.js: \
	install.spacevim.gtags \
	$(yarn.global.mod)/import-js \
	$(yarn.global.mod)/javascript-typescript-langserver
install.spacevim.ts: \
	install.spacevim \
	$(yarn.global.mod)/typescript \
	$(yarn.global.mod)/javascript-typescript-langserver \
	$(yarn.global.mod)/typescript-language-server \

$(HOME)/.SpaceVim:
	curl -sLf https://spacevim.org/install.sh | bash

.PHONY: \
	update \
	update.spacevim

update: update.spacevim
update.spacevim:
	curl -sLf https://spacevim.org/install.sh | bash

.IGNORE \
.PHONY: \
	clean \
	clean.spacevim \
	clean.spacevim.js

clean: clean.spacevim
clean.spacevim:
clean.spacevim.gtags:
clean.spacevim.js:
clean.spacevim.ts:

.IGNORE \
.PHONY: \
	trash \
	trash.spacevim \
	trash.spacevim.js

trash: trash.spacevim
trash.spacevim: trash.spacevim.gtags trash.spacevim.js
	curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall
	rm -rf ~/.SpaceVim
	rm -rf ~/.cache/SpaceVim
	rm -rf ~/.cache/vimfiles/repos
trash.spacevim.gtags:
trash.spacevim.js:
	yarn global remove javascript-typescript-langserver
trash.spacevim.ts:
	yarn global remove javascript-typescript-langserver

endif # spacevim.mk
