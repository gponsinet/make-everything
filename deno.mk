ifndef deno.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
deno.mk := $(dotmk)/deno.mk

export PATH := $(HOME)/.deno/bin:$(PATH)

include $(dotmk)/dotmk.mk

install install.deno: deno
trash trash.deno: ~deno

.PHONY: install.deno deno
.IGNORE .PHONY: trash.deno ~deno

deno: brew brew(deno) volta volta(typescript typescript-deno-plugin)
~deno: brew(deno) ~volta(typescript-deno-plugin)

.SpaceVim.d/coc-settings.json: $(dotmk)/deno/.SpaceVim.d/coc-settings.json

endif
