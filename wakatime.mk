ifndef wakatime.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
wakatime.mk := $(dotmk)/wakatime.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/graphql.mk

install install.wakatime: wakatime
trash trash.wakatime: ~wakatime

.PHONY: wakatime +wakatime ~wakatime
wakatime +wakatime:
~wakatime:

.SpaceVim.d/init.toml \
.SpaceVim.d/coc-settings.json \
	: %: $(dotmk)/wakatime/%

endif # wakatime.mk
