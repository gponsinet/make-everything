ifndef spacevim.mk
spacevim.mk := $(abspace $(MAKEFILE_LIST))

.PHONY: \
	install \
	install.spacevim

install: install.spacevim
install.spacevim: $(HOME)/.SpaceVim

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


endif # spacevim.mk
