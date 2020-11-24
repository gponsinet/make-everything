ifndef docker.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
docker.mk := $(dotmk)/docker.mk

include $(dotmk)/config.mk
include $(dotmk)/system.mk
include $(dotmk)/brew.mk

.PHONY: \
	install \
	install.docker

install: install.docker
install.docker:

.IGNORE \
.PHONY: \
	clean \
	clean.docker

clean: clean.docker
clean.docker:

.IGNORE \
.PHONY: \
	trash \
	trash.docker

trash: trash.docker
trash.docker:

endif # docker.mk
