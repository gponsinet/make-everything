ifndef volta.mk
volta.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(volta.mk))/config.mk

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
