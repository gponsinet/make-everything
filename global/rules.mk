ifndef global/rules.mk
global/rules.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

.PHONY: \
	install \
	clean

endif # global/rules.mk
