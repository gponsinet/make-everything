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

read = \
	read \
		-p "$(1)$$([ -z "$(2)" ] || echo ' ($(2))'): " \
		read_var \
	&& [ -z "$$read_var" ] && echo $(2) || echo "$$read_var"

ask = $(or $($(strip $(1))/$(strip $(2))),$(strip $(eval \
	$(strip $(1))/$(strip $(2)) := \
		$(shell $(call read,$(strip $(1))/$(strip $(2)),$(strip $(3)))) \
	) $($(strip $(1))/$(strip $(2)))))

endif # global/helper.mk
