ifndef global/config.mk
global/config.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(global/config.mk))/print.mk

SHELL := bash
.ONESHELL:

.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules
.DEFAULT_GOAL := help

endif # config.mk
