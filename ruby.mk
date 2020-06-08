ifndef ruby.mk
ruby.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(ruby.mk))/global/config.mk
include $(dir $(ruby.mk))/brew.mk

.PHONY: \
	install \
	install.ruby

install: install.ruby
install.ruby: $(brew.cellar)/ruby

endif # ruby.mk
