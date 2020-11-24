ifndef eslint.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
eslint.mk := $(dotmk)/eslint.mk

include $(dotmk)/config.mk

endif
