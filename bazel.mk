ifndef bazel.mk
bazel.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(bazel.mk))/config.mk
include $(dir $(bazel.mk))/brew.mk

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
