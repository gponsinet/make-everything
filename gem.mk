ifndef gem.mk
gem.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

gem.path := /home/linuxbrew/.linuxbrew/lib/ruby/gems
gem.bin := $(lastword $(shell find $(gem.path) -maxdepth 2 -type d -name bin))

include $(dir $(gem.mk))/config.mk
include $(dir $(gem.mk))/ruby.mk

export PATH := $(gem.bin):$(PATH)

.PHONY: \
	install \
	install.gem

install: install.ruby
install.gem: install.ruby

endif # gem.mk
