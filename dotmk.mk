ifndef dotmk.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
dotmk.mk := $(dotmk)/dotmk.mk

SHELL := bash

.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := help

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

endif # dotmk.mk
