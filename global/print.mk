ifndef global/print.mk
global/print.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

.PHONY: global/print/%
global/print/%:
	@echo $($*)

endif
