ifndef docker.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
docker.mk := $(dotmk)/docker.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
ifeq ($(CURDIR),$(HOME))
 include $(dotmk)/volta.mk
else
 include $(dotmk)/npm.mk
endif

ifeq ($(CURDIR),$(HOME))
 export DOCKER_LANGSERVER_PATH := $(VOLTA_HOME)/bin/docker-langserver
else
 export DOCKER_LANGSERVER_PATH := $(CURDIR)/node_modules/.bin/docker-langserver
endif

.PHONY: \
	install \
	install.docker

install: install.docker
install.docker: $(BREW_CELLAR)/docker
ifeq ($(CURDIR),$(HOME))
install.docker:
	volta install dockerfile-language-server-nodejs
else
install.docker: package.json
endif

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

package.json: $(dotmk)/docker/package.json
.SpaceVim.d/init.toml: $(dotmk)/docker/.SpaceVim.d/init.toml

endif # docker.mk
