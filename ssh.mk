ifndef ssh.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
ssh.mk := $(dotmk)/ssh.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

.PHONY: \
	install \
	install.ssh

install: install.ssh
install.ssh: \
	$(BREW_HOME)/Cellar/openssh

.PHONY: \
	clean \
	clean.ssh

clean: clean.ssh
clean.ssh:

.PHONY: \
	trash \
	trash.ssh

trash:
trash.ssh:
	brew uninstall openssh

endif # ssh.mk
