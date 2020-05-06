ifndef pbhbs.mk
pbhbs.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(pbhbs.mk))/global/config.mk
include $(dir $(pbhbs.mk))/yarn.mk

.PHONY: \
	install \
	install.pbhbs

install: install.pbhbs
install.pbhbs: install.yarn \
	$(yarn.root)/node_modules/pbhbs \
	$(yarn.root)/node_modules/@protocolbuffers/protobuf \
	$(yarn.root)/node_modules/@googleapis/googleapis

.IGNORE \
.PHONY: \
	clean \
	clean.pbhbs

clean: clean.pbhbs
clean.yarn: clean.pbhbs
clean.pbhbs:
	yarn remove pbhbs
	rm -rf $(yarn.root)/node_modules @protocolbuffers $(yarn.root)/@googleapis

.IGNORE \
.PHONY: \
	trash \
	trash.pbhbs

trash: trash.pbhbs
trash.yarn: trash.pbhbs
trash.pbhbs:

.PHONY: \
	gen \
	gen.pbhbs

gen: gen.pbhbs
gen.pbhbs: \
proto-paths = $(subst $(shell echo ","), ,$(call ask,pbhbs,proto-paths,.))
gen.pbhbs:
	pbhbs \
		-p $(yarn.root)/node_modules/@protocolbuffers/protobuf/src \
		-p $(yarn.root)/node_modules/@googleapis/googleapis \
		$(foreach proto-path,$(proto-paths),-p $(proto-path)) \
		--template-dir $(call ask,pbhbs,template-dir,./template) \
		--output-dir $(call ask,pbhbs,output-dir,.) \
		$(shell find $(proto-paths) -type f -name '*.proto')

$(yarn.root)/node_modules/pbhbs:
	yarn add pbhbs@latest

$(yarn.root)/node_modules/@protocolbuffers/protobuf:
	mkdir $(dir $@)
	git clone --depth 1 https://github.com/protocolbuffers/protobuf --branch v3.11.4 $@

$(yarn.root)/node_modules/@googleapis/googleapis:
	mkdir $(dir $@)
	git clone --depth 1 https://github.com/googleapis/googleapis --branch common-protos-1_3_1 $@

endif # pbhbs.mk
