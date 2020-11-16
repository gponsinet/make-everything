ifndef config.mk
config.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(config.mk))/system.mk

SHELL := bash

.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := help

endif # config.mk
