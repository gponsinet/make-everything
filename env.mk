ifndef env.mk
env.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

.PHONY: \
	export \
	export.env

export: export.env
export.env:
	@env | sed 's/^/export /' | sed "s/=/='/" | sed "s/$$/'/"

endif
