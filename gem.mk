ifndef gem.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
gem.mk := $(dotmk)/gem.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/ruby.mk

.PHONY: \
	install \
	install.gem

install: install.gem
install.gem: install.ruby

.IGNORE \
.PHONY: \
	trash \
	trash.gem

trash: trash.ruby
trash.ruby: trash.gem

.PHONY: gem
gem: install.ruby

.IGNORE \
.PHONY: ~gem
trash.ruby: ~gem
~gem:
	@true

.PHONY: gem+%
gem+%:
	gem list -i "^$*$$" | grep true 1>/dev/null || gem install --force $*

.PHONY: gem(%)
gem(%):
	make $(foreach _,$*,gem+$(_))

.IGNORE \
.PHONY: gem+%
gem~%:
	gem list -i "^$*$$" | grep false || gem uninstall $*

.IGNORE \
.PHONY: ~gem(%)
~gem(%):
	make $(foreach _,$*,gem~$(_))

endif # gem.mk
