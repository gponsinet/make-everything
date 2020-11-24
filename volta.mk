ifndef volta.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
volta.mk := $(dotmk)/volta.mk

include $(dotmk)/dotmk.mk

export VOLTA_HOME ?= $(HOME)/.volta
export PATH := $(VOLTA_HOME)/bin:$(PATH)

volta := $(VOLTA_HOME)/bin/volta

.PHONY: \
	install \
	install.volta

install: install.volta
install.volta: $(volta)

$(volta):
	curl https://get.volta.sh | bash

.IGNORE \
.PHONY: 
trash: trash.volta
trash.volta:
	rm -rf $(VOLTA_HOME)

$(VOLTA_HOME)/bin/%:
	volta install $%

endif
