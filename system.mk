ifndef system.mk
system.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(system.mk))/config.mk

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
