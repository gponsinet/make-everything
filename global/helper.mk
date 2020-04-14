ifndef global/helper.mk
global/helper.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

find_up = \
	while true; \
	do \
		[ -e "$$PWD/$(1)" ] && echo "$$PWD/$(1)" || true; \
		[ "$$PWD" == "/" ] && break; \
		cd ..; \
	done

find_up_first = $(call find_up,$(1)) | head -1
find_up_last = $(call find_up,$(1)) | tail -1

endif # global/helper.mk
