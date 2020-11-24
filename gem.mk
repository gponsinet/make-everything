ifndef gem.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
gem.mk := $(dotmk)/gem.mk

gem.path := /home/linuxbrew/.linuxbrew/lib/ruby/gems
gem.bin := $(lastword $(shell find $(gem.path) -maxdepth 2 -type d -name bin))

include $(dotmk)/dotmk.mk
include $(dotmk)/ruby.mk

export PATH := $(gem.bin):$(PATH)

.PHONY: \
	install \
	install.gem

install: install.ruby
install.gem: install.ruby

endif # gem.mk
