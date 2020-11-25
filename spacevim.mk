ifndef spacevim.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
spacevim.mk := $(dotmk)/spacevim.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
include $(dotmk)/node.mk
include $(dotmk)/conflate.mk
include $(dotmk)/yarn.mk

.PHONY: \
	install \
	install.spacevim

install: install.spacevim
install.spacevim: \
	install.conflate \
	install.yarn \
	$(BREW_HOME)/Cellar/neovim \
	$(BREW_HOME)/Cellar/msgpack \
	$(BREW_HOME)/Cellar/python@3.9 \
	$(BREW_HOME)/Cellar/global \
	$(BREW_HOME)/Cellar/moreutils \
	$(HOME)/.SpaceVim \
	.SpaceVim.d/init.toml \
# 	$(yarn.global.mod)/import-js \
# 	$(yarn.global.mod)/javascript-typescript-langserver \
# 	$(yarn.global.mod)/typescript \
# 	$(yarn.global.mod)/javascript-typescript-langserver \
# 	$(yarn.global.mod)/typescript-language-server 
install.spacevim:
install.spacevim:
	(which bash-language-server | grep -v 'not found') || volta install bash-language-server

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

$(HOME)/.SpaceVim.d/custom.toml:
	mkdir -p $(dir $@)
	touch $@

.SpaceVim.d/init.toml: 
	$(eval %/.SpaceVim.d/.custom.yml := \
		$(foreach pre,$^,$(patsubst $(dir $(pre))%.toml,$(dir $(pre)).%.yml,$(pre))))
	make $(%/.SpaceVim.d/.custom.yml) 
	conflate \
		$(patsubst %,-data %,$(%/.SpaceVim.d/.custom.yml)) \
		-data .SpaceVim.d/.custom.yml \
		-format TOML \
		| sponge $@

%/.SpaceVim.d/.custom.yml: %/.SpaceVim.d/custom.toml
	conflate -data $^ -format YAML > $@ 

.SpaceVim.d/init.toml: $(dotmk)/spacevim/.SpaceVim.d/custom.toml 
.SpaceVim.d/init.toml: $(HOME)/.SpaceVim.d/custom.toml

endif # spacevim.mk
