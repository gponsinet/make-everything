ifndef ruby.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
ruby.mk := $(dotmk)/ruby.mk

include $(dotmk)/config.mk
include $(dotmk)/brew.mk

.PHONY: \
	install \
	install.ruby

install: install.ruby
install.ruby: $(BREW_HOME)/Cellar/ruby

endif # ruby.mk
