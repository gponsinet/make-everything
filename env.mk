ifndef env.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
env.mk := $(dotmk)/env.mk

.PHONY: \
	export \
	export.env

export: export.env
export.env:
	@env | sed 's/^/export /' | sed "s/=/='/" | sed "s/$$/'/"

endif
