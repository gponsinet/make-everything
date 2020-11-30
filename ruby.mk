ifndef ruby.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
ruby.mk := $(dotmk)/ruby.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

export PATH := /usr/local/opt/ruby/bin:$(PATH)
export LDFLAGS += -L/usr/local/opt/ruby/lib
export CPPFLAGS += -I/usr/local/opt/ruby/include
export PKG_CONFIG_PATH := /usr/local/opt/ruby/lib/pkgconfig

.PHONY: \
	install \
	install.ruby

install: install.ruby
install.ruby: install.brew
install.ruby: $(BREW_HOME)/Cellar/ruby

.IGNORE \
.PHONY: \
	trash \
	trash.ruby

trash: trash.ruby
trash.ruby:
	brew uninstall ruby

endif # ruby.mk
