ifndef spacevim.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
spacevim.mk := $(dotmk)/spacevim.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
include $(dotmk)/nvim.mk
include $(dotmk)/conflate.mk

.PHONY: install install.spacevim
install install.spacevim: spacevim

.IGNORE .PHONY: trash trash.spacevim
trash trash.spacevim: ~spacevim

spacevim: \
	install.conflate \
	brew \
	nvim \
	brew(msgpack global moreutils) \
	volta(bash-language-server typescript) \
	$(HOME)/.SpaceVim \
	.SpaceVim.d/init.toml \
	.SpaceVim.d/autoload/myspacevim.vim \
	.SpaceVim.d/coc-settings.json

~brew: ~spacevim
~nvim: ~spacevim
~spacevim:
ifeq ($(CURDIR),$(HOME))
	curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall
	rm -rf ~/.SpaceVim
	rm -rf ~/.cache/SpaceVim
	rm -rf ~/.cache/vimfiles
endif
	rm -rf .SpaceVim.d

$(HOME)/.SpaceVim:
	curl -sLf https://spacevim.org/install.sh | bash

.SpaceVim.d/autoload/myspacevim.vim: $(dotmk)/spacevim/.SpaceVim.d/autoload/myspacevim.vim
	[ -d $(dir $@) ] || mkdir -p $(dir $@)
	cp $< $@

ifneq ($(CURDIR),$(HOME))
$(HOME)/.SpaceVim.d/init.toml:
	[ -d $(dir $@) ] || mkdir $(dir $@)
	[ -f $@ ] || touch $@
endif

$(CURDIR)/.SpaceVim.d/init.toml:
	[ -d $(dir $@) ] || mkdir $(dir $@)
	[ -f $@ ] || touch $@

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

ifneq ($(CURDIR),$(HOME))
$(HOME)/.SpaceVim.d/coc-settings.json:
	touch $@
endif

.SpaceVim.d/coc-settings.json:
	[ -f $@ ] || echo '{}' > $@
	conflate -data $@ --format JSON | grep -v "Could not unmarshal" || echo "{}" > $@
	conflate $(foreach _,$^,-data $_) -data $@ --format JSON | sponge $@
	conflate -data $@ --format JSON

.gitignore: $(dotmk)/spacevim/.gitignore

endif # spacevim.mk
