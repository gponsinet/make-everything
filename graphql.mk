ifndef graphql.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
graphql.mk := $(dotmk)/graphql.mk

include $(dotmk)/dotmk.mk

.PHONY: \
	install \
	install.graphql

install: install.graphql
install.graphql:

.IGNORE \
.PHONY: \
	trash \
	trash.graphql

trash: trash.graphql
trash.brew: trash.graphql
trash.graphql:

.SpaceVim.d/init.toml \
.SpaceVim.d/coc-settings.json \
	: %: $(dotmk)/graphql/%

endif # graphql.mk
