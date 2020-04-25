ifndef protoc.mk
protoc.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(protoc.mk))/global/config.mk
include $(dir $(protoc.mk))/global/helper.mk
include $(dir $(protoc.mk))/brew.mk
include $(dir $(protoc.mk))/go.mk

.PHONY: \
	install \
	install.protoc

install: install.protoc
install.protoc: $(brew.cellar)/protobuf
install.protoc.json: \
	install.protoc \
	$(go.src)/sourcegraph.com/sourcegraph/prototools/cmd/protoc-gen-json

.PHONY: \
	clean \
	clean.protoc

clean: clean.protoc
clean.protoc:
	# TODO

.PHONY: \
	trash \
	trash.protoc

trash: trash.protoc
trash.protoc:
	brew uninstall protoc

.PHONY: \
	gen \
	gen.protoc \
	gen.protoc.json

gen: gen.protoc
gen.protoc: \
	gen.protoc.json
gen.protoc.json: install.protoc.json
	# TODO

endif # protoc.mk
