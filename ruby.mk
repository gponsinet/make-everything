ifndef ruby.mk
ruby.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(ruby.mk))/config.mk
include $(dir $(ruby.mk))/brew.mk

.PHONY: \
	install \
	install.ruby

install: install.ruby
install.ruby: $(BREW_HOME)/Cellar/ruby

endif # ruby.mk
