ifndef dotmk.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
dotmk.mk := $(dotmk)/dotmk.mk

.SECONDEXPANSION:

SHELL := bash

.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

ifdef OS
	ifeq ($(OS),Windows_NT)
		windows := windows
		system := windows
	endif
endif
ifndef OS
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		linux := linux
		system := linux
	endif
	ifeq ($(UNAME_S),Darwin)
		darwin := darwin
		system := darwin
	endif
endif
# deprecated legacy:
system/$(system) := system/$(system)

ifeq (system,darwin)
endif

.PHONY: \
	darwin(%) darwin.% \
	!darwin(%) !darwin.% \

ifdef darwin
darwin(%) darwin.%: %
else
darwin(%) darwin.%:
endif
	@true

!darwin(%) !darwin.%: linux(%) windows(%)
	@true

.PHONY: \
	linux(%) linux.% \
	!linux(%) !linux.% \

ifdef linux
linux(%) linux.%: %
else
linux(%) linux.%: %
endif
	@true

!linux(%): windows(%) darwin(%)
	@true

.PHONY: \
	windows(%) windows.% \
	!windows(%) !windows.% \

ifdef windows
windows(%) windows.%: %
else
windows(%) windows.%:
endif
	@true

!windows(%) !windows.%: unix(%)
	@true

.PHONY: \
	unix(%) unix.% \
	!unix(%) !unix.% \

unix(%) unix.%: darwin(%) linux(%)
	@true
!unix(%) !unix.%: windows(%)
	@true

.PHONY: print(%) print.%
print(%) print.%:
	@echo $($*)

.PHONY: \
	add(%) add.% \
	+(%) +% \

add(%) add.% +(%) +%: darwin(+brew(%)) linux(+brew(%)) windows(+choco(%))
	@true

.PHONY: \
	del(%) del.% \
	-(%) -% \

del(%): unix(-brew(%)) windows(-choco(%))
	@true

endif # dotmk.mk
