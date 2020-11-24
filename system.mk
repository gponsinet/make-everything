ifndef system.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
system.mk := $(dotmk)/system.mk

include $(dotmk)/config.mk

ifdef OS
	ifeq ($(OS),Windows_NT)
		system/windows := system/windows
	endif
endif
ifndef OS
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		system/linux := system/linux
	endif
	ifeq ($(UNAME_S),Darwin)
		system/darwin := system/darwin
	endif
endif

endif # system.mk
