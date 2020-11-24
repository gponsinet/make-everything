ifndef dotenv.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
dotenv.mk := $(dotmk)/dotenv.mk

$(shell cat .env | sed 's,\$$[^{],$$$$,g' | sed 's,\(#\),\\\1,g' | sed 's,^,export ,' | sed 's,=, ?= ,' | sed 's,SHELL ?=,SHELL :=,' > .env.mk)
include .env.mk

endif
