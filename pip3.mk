ifndef pip3.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
pip3.mk := $(dotmk)/pip3.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

install install.pip3: pip3
trash trash.pip3: ~pip3

.PHONY: pip3
pip3: brew(python@3.9)

.IGNORE \
.PHONY: ~pip3
~pip3: ~brew(python@3.9)

.PHONY: pip3(%)
pip3(%):
	make $(foreach _,$*,pip3+$(_))

IGNORE \
.PHONY: ~pip3(%)
~pip3(%):
	make $(foreach _,$*,~pip3+$(_))

.PHONY: pip3+%
pip3+%:
	pip3 install --user --upgrade $*

.IGNORE \
.PHONY: ~pip3+%
~pip3+%:
	pip3 uninstall $*

endif
