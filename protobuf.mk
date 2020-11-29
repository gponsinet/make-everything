ifndef protobuf.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
protobuf.mk := $(dotmk)/protobuf.mk

include $(dotmk)/dotmk.mk

.PHONY: \
	install \
	install.protobuf

install: install.protobuf
install.protobuf: 

.PHONY: \
	trash \
	trash.protobuf

trash: trash.protobuf
trash.protobuf:

endif
