ifndef docker.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
docker.mk := $(dotmk)/docker.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk
include $(dotmk)/volta.mk

export DOCKER_LANGSERVER_PATH := $(VOLTA_HOME)/bin/docker-langserver

.PHONY: \
	install \
	install.docker

install: install.docker
install.docker: docker

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
trash.docker: ~docker

package.json: $(dotmk)/docker/package.json
.SpaceVim.d/init.toml: $(dotmk)/docker/.SpaceVim.d/init.toml

.PHONY: docker
docker: brew(docker) volta(dockerfile-language-server-nodejs)
	@true

.IGNORE \
.PHONY: ~docker
~docker: ~volta(dockerfile-language-server-nodejs)
	@true

.PHONY: docker(%)
docker(%):
	docker-compose build $*
	docker-compose up -d $*
	docker-compose logs $*

.IGNORE \
.PHONY: ~docker(%)
~docker(%):
	docker-compose down $*

endif # docker.mk
