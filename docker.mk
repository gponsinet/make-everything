ifndef docker.mk
docker.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(docker.mk))/config.mk
include $(dir $(docker.mk))/system.mk
include $(dir $(docker.mk))/brew.mk

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
