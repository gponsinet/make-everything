ifndef protoc.mk
protoc.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(protoc.mk))/global/config.mk
include $(dir $(protoc.mk))/global/helper.mk
include $(dir $(protoc.mk))/brew.mk
include $(dir $(protoc.mk))/go.mk
include $(dir $(protoc.mk))/buf.mk
include $(dir $(protoc.mk))/yarn.mk

.PHONY: \
	install \
	install.protoc \
	install.protoc.json \
	install.protoc.hbs

install: install.protoc
install.protoc: \
	install.buf \
	$(brew.cellar)/protobuf \
	$(brew.cellar)/python-yq \
	$(brew.cellar)/coreutils
install.protoc.json: \
	install.protoc \
	$(go.src)/sourcegraph.com/sourcegraph/prototools/cmd/protoc-gen-json
install.protoc.hbs: \
	install.protoc \
	$(brew.cellar)/yarn \
	$(yarn.global.mod)/protoc-gen-hbs

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

protoc/input_dir ?= $(PWD)
protoc/input_files ?= $(shell find $(buf.root) -type f -name '*.proto' -not -path '*/.buf/*')
protoc/proto-paths ?= \
	$(buf.root) \
	$(addprefix $(buf.root)/,$(shell yq '.build.roots | .[]' $(buf.root)/buf.yaml | sed 's/"//g'))

protoc/output_dir ?= $(buf.root)

protoc.json/output_dir ?= $(protoc/output_dir)
protoc.json/output_files ?= \
	$(patsubst \
		$(protoc/input_dir)/%.proto,\
		$(protoc.json/output_dir)/%.pb.json,\
		$(filter-out $(buf.root)/.buf/%,$(protoc/input_files))\
	)

protoc.hbs/template_dir ?= ./templates
protoc.hbs/template_files ?= $(shell find . $(protoc.hbs/template_dir) -type f -name '*.hbs')
protoc.hbs/output_dir ?= $(protoc/output_dir)
protoc.hbs/output_files ?= $(protoc.hbs/template_dir)/.generated

gen:
gen.protoc: \
	gen.protoc.json
gen.protoc.json: install.protoc.json $(protoc.json/output_files)

$(protoc.json/output_files): $(protoc.json/output_dir)/%.pb.json: $(protoc/input_dir)/%.proto
	protoc \
		$(foreach proto-path,$(protoc/proto-paths),-I$(proto-path)) \
		--json_out="out=$@:$(protoc/output_dir)" $<

gen.protoc.hbs: install.protoc.hbs $(protoc.hbs/output_files)
$(protoc.hbs/output_files): $(protoc.hbs/template_files) $(protoc/input_files)
	protoc \
		$(foreach proto-path,$(protoc/proto-paths),-I$(proto-path)) \
		--hbs_out="$(protoc.hbs/template_dir):$(protoc.hbs/output_dir)" \
		$(protoc/input_files)

endif # protoc.mk
