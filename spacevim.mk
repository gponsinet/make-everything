ifndef spacevim.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
spacevim.mk := $(dotmk)/spacevim.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
include $(dotmk)/node.mk
include $(dotmk)/conflate.mk

.PHONY: \
	install \
	install.spacevim

install: install.spacevim
install.spacevim: \
	install.conflate \
	$(BREW_HOME)/Cellar/neovim \
	$(BREW_HOME)/Cellar/msgpack \
	$(BREW_HOME)/Cellar/python@3.9 \
	$(BREW_HOME)/Cellar/global \
	$(BREW_HOME)/Cellar/moreutils \
	$(HOME)/.SpaceVim \
	.SpaceVim.d/init.toml
install.spacevim:
install.spacevim:
	(which bash-language-server | grep -v 'not found') || volta install bash-language-server

.IGNORE \
.PHONY: \
	trash \
	trash.spacevim

trash: trash.spacevim
trash.spacevim:
ifeq ($(CURDIR),$(HOME))
	curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall
	rm -rf ~/.SpaceVim
	rm -rf ~/.cache/SpaceVim
	rm -rf ~/.cache/vimfiles
endif
	rm -rf .SpaceVim.d

$(HOME)/.SpaceVim:
	curl -sLf https://spacevim.org/install.sh | bash

ifneq ($(CURDIR),$(HOME))
$(HOME)/.SpaceVim.d/init.toml:
	[ -e $@ ] || (mkdir $(dir $@) && touch $@)
endif

$(CURDIR)/.SpaceVim.d/init.toml:
	[ -e $@ ] || (mkdir $(dir $@) && touch $@)

.SpaceVim.d/init.toml:
	$(eval %/.SpaceVim.d/.init.yml := \
		$(foreach pre,$^,$(patsubst $(dir $(pre))%.toml,$(dir $(pre)).%.yml,$(pre))))
	make $(%/.SpaceVim.d/.init.yml)
	conflate \
		$(patsubst %,-data %,$(%/.SpaceVim.d/.init.yml)) \
		-format TOML \
		| sed 's,merge = 0.0,merge = 0,' \
		| sponge $@

%/.SpaceVim.d/.init.yml: %/.SpaceVim.d/init.toml
	conflate -expand -data $^ -format YAML > $@

# Default DotMK config
.SpaceVim.d/init.toml: $(dotmk)/spacevim/.SpaceVim.d/init.toml 
# Add custom global config for user in projects
ifneq ($(CURDIR),$(HOME))
.SpaceVim.d/init.toml: $(HOME)/.SpaceVim.d/init.toml
endif
# Override default config if init.toml was already present
.SpaceVim.d/init.toml: $(CURDIR)/.SpaceVim.d/init.toml

.gitignore: $(dotmk)/spacevim/.gitignore

endif # spacevim.mk
