ifndef dotenv.mk
dotenv.mk := $(lastword $(MAKEFILE_LIST))

$(shell cat .env | sed 's,\$$[^{],$$$$,g' | sed 's,\(#\),\\\1,g' | sed 's,^,export ,' | sed 's,=, ?= ,' | sed 's,SHELL ?=,SHELL :=,' > .env.mk)
include .env.mk

endif
