ifndef ruby.mk
ruby.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(ruby.mk))/global/config.mk

export PATH := $(HOME)/.rvm/bin:$(PATH)

.PHONY: \
	install \
	install.ruby

install: install.ruby
install.ruby: $(HOME)/.rvm/bin
install.ruby@%: install.ruby
	rvm install $*

.IGNORE \
.PHONY: \
	clean \
	clean.ruby

clean: clean.ruby
clean.ruby:

.IGNORE \
.PHONY: \
	trash \
	trash.ruby

trash: clean.ruby
trash.ruby:
	rm -rf ~/.rvm

$(HOME)/.rvm/bin:
	which gpg && gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB || true
	curl -sSL https://get.rvm.io | bash -s stable

endif # ruby.mk
