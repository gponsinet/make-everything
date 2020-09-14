ifndef ssh.mk
ssh.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(ssh.mk))/global/config.mk
include $(dir $(ssh.mk))/brew.mk

.PHONY: \
	install \
	install.ssh

install: install.ssh
install.ssh: \
	$(brew.cellar)/openssh

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
