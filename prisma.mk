ifndef prisma.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
prisma.mk := $(dotmk)/prisma.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/volta.mk
include $(dotmk)/graphql.mk

install install.prisma: prisma
trash trash.prisma: ~prisma

.PHONY: prisma +prisma ~prisma
prisma +prisma: volta(prisma @prisma+language-server)
~prisma: ~volta(prisma @prisma+language-server)

.SpaceVim.d/init.toml \
.SpaceVim.d/coc-settings.json \
	: %: $(dotmk)/prisma/%

endif # prisma.mk
