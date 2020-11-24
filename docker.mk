ifndef docker.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
docker.mk := $(dotmk)/docker.mk

include $(dotmk)/dotmk.mk

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

.SpaceVim.d/init.toml: $(dotmk)/docker/.SpaceVim.d/custom.toml

endif # docker.mk
