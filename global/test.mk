ifndef global/test.mk
global/test.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

endif # global/test.mk
