ifndef protoc.mk
protoc.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(protoc.mk))/global/config.mk
include $(dir $(protoc.mk))/global/helper.mk
include $(dir $(protoc.mk))/brew.mk
include $(dir $(protoc.mk))/go.mk
include $(dir $(protoc.mk))/buf.mk

.PHONY: \
	install \
	install.protoc

install: install.protoc
install.protoc: \
	install.buf \
	$(brew.cellar)/protobuf \
	$(brew.cellar)/python-yq \
	$(brew.cellar)/coreutils
install.protoc.json: \
	install.protoc \
	$(go.src)/sourcegraph.com/sourcegraph/prototools/cmd/protoc-gen-json

.PHONY: \
	clean \
	clean.protoc

clean: clean.protoc
clean.go: clean.protoc
clean.buf: clean.protoc
clean.protoc: clean.protoc.json
clean.protoc.json:
	rm -f $(protoc.json/output_files)

.PHONY: \
	trash \
	trash.protoc

trash: trash.protoc
trash.go: trash.protoc
trash.buf: trash.protoc
trash.protoc:
	brew uninstall protoc

.PHONY: \
	gen \
	gen.protoc \
	gen.protoc.json


protoc/input_dir ?= $(shell realpath --relative-to=$(PWD) $(buf.root))
protoc/input_files ?= $(shell find $(protoc/input_dir) -type f -name '*.proto')
protoc/proto-paths ?= \
	$(protoc/input_dir) $(addprefix $(buf.root)/,$(shell yq '.build.roots | .[]' $(buf.root)/buf.yaml | sed 's/"//g'))

protoc.json/output_dir ?= $(protoc/input_dir)
protoc.json/output_files := \
	$(patsubst \
		$(protoc/input_dir)/%.proto,\
		$(protoc.json/output_dir)/%.pb.json,\
		$(filter-out $(protoc/input_dir)/.buf/%,$(protoc/input_files))\
	)

gen: gen.protoc
gen.protoc: \
	gen.protoc.json
gen.protoc.json: install.protoc.json $(protoc.json/output_files)

$(protoc.json/output_files): $(protoc.json/output_dir)/%.pb.json: $(protoc/input_dir)/%.proto
	protoc \
		$(foreach proto-path,$(protoc/proto-paths),-I$(proto-path)) \
		--json_out="out=$@:." $<

endif # protoc.mk
