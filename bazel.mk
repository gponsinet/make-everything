ifndef bazel.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
bazel.mk := $(dotmk)/bazel.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

bazel := $(BREW_HOME)/Cellar/bazel

.PHONY: \
	install \
	install.bazel

install: install.bazel
install.bazel: $(BREW_HOME)/Cellar/bazel

.IGNORE \
.PHONY: \
	clean \
	clean.bazel

clean: clean.bazel
clean.bazel:

.IGNORE \
.PHONY: \
	trash \
	trash.bazel

trash:
trash.bazel:
	brew uninstall bazel

endif
