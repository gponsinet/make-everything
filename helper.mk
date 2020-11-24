ifndef helper.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
helper.mk := $(dotmk)/helper.mk

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
	&& [ -z "$$read_var" ] && echo '$(2)' || echo "$$read_var"

ask = $(or $($(strip $(1))/$(strip $(2))),$(strip \
	$(eval $(strip $(1))/$(strip $(2)) := \
		$(shell $(call read,$(strip $(1))/$(strip $(2)),$(strip $(3))))) \
	$($(strip $(1))/$(strip $(2)))))

select = $(or $($(strip $(1))/$(strip $(2))),$(strip \
	$(eval $(strip $(1))/$(strip $(2)) := \
		$(shell \
			select select_var in $(3); \
			do \
				echo $$select_var; \
				break; \
			done \
		)) \
	$($(strip $(1))/$(strip $(2)))))

json_merge = jq -s ".[0] * .[1]" $(1) $(2) > $(1)-merged && mv $(1)-merged $(1)

endif # helper.mk
