ifndef nvim.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
nvim.mk := $(dotmk)/nvim.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
include $(dotmk)/gem.mk
include $(dotmk)/volta.mk
include $(dotmk)/node.mk
include $(dotmk)/pip3.mk
include $(dotmk)/conflate.mk

install: nvim
trash: ~nvim

.PHONY: nvim
nvim: \
	brew \
	gem \
	pip3 \
	volta \
	install.node \
	brew(neovim) \
	gem(neovim) \
	volta(neovim) \
	pip3(pynvim neovim) \

.IGNORE \
.PHONY: ~nvim
~nvim: \
	~brew(neovim) \
	~gem(neovim) \
	~volta(neovim) \
	~pip3(pynvim neovim)
~nvim:
	rm -rf $(HOME)/.config/coc

endif
