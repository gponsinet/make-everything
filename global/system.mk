ifndef global/system.mk
global/system.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(global/system.mk))/config.mk

ifeq ($(OS),Windows_NT)
	global/system/windows := global/system/windows
else
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		global/system/linux := global/system/linux
	endif
	ifeq ($(UNAME_S),Darwin)
		global/system/darwin := global/system/darwin
	endif
endif

endif # global/system.mk
