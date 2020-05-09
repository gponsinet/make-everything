ifndef bazel.mk
bazel.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(bazel.mk))/global/config.mk
include $(dir $(bazel.mk))/brew.mk

.PHONY: \
	install \
	install.bazel

install: install.bazel
install.bazel: $(brew.cellar)/bazel

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
