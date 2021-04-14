ifndef volta.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
volta.mk := $(dotmk)/volta.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/curl.mk

export VOLTA_HOME ?= $(HOME)/.volta
export PATH := $(VOLTA_HOME)/bin:$(PATH)

install install.volta: volta
trash trash.volta: ~volta

.PHONY: volta
volta: curl $(VOLTA_HOME)/bin/volta

.IGNORE \
.PHONY: ~volta
~volta:
	rm -rf $(VOLTA_HOME)

$(VOLTA_HOME)/bin/volta:
	curl https://get.volta.sh | bash

.PHONY: volta+%
volta+%:
	$(eval 1 := $(subst +,/,$*))
	volta list --format plain $1 | grep '^package $1' || volta install $1

.PHONY: volta(%)
volta(%):
	make $(foreach _,$*,volta+$_)

.IGNORE \
.PHONY: volta~%
volta~%:
	volta uninstall neovim || true

.IGNORE \
.PHONY: ~volta(%)
~volta(%):
	make $(foreach _,$*,volta~$_)

# deprecated
$(VOLTA_HOME)/bin/%:
	volta install $*

endif
