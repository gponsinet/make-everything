ifndef git.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
git.mk := $(dotmk)/git.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

.PHONY: install
install: install.git
install.git: .git .gitignore

.PHONY: trash
trash: trash.git
trash.git:
	rm -rf .git .gitignore

.git:
	git init

.gitignore: | $(BREW_HOME)/Cellar/moreutils
	touch $@
	cat $@ $^ | sort | uniq | sponge $@

endif
