ifndef eslint.mk
eslint.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(eslint.mk))/config.mk

endif
