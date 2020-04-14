ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/global/rules.mk
include $(dir $(yarn.mk))/global/config.mk
include $(dir $(yarn.mk))/global/helper.mk
include $(dir $(yarn.mk))/brew.mk

yarn.path := $(or $(dir $(shell $(call find_up_last,package.json))),$(PWD))
yarn.packages := $(PWD)/ $(dir $(shell \
	find $(yarn.path) \
		-type f \
		-name package.json \
		-or -name node_modules \
		-or -name yarn.lock \
		-not -path "*/node_modules/*" \
))

install: install.yarn
clean: clean.yarn

.PHONY: install.yarn
install.yarn: install.brew
install.yarn: node_modules

.IGNORE \
.PHONY: clean.yarn
clean.brew: clean.yarn
clean.yarn:
	[ "$(PWD)" == "$(yarn.path)" ] && brew uninstall yarn || true
	rm -rf \
		yarn.lock \
		.yarn \
		.yarnrc.yml \
		.pnp.js \
		yarn-error.log \
		$(addsuffix package.json,$(yarn.packages)) \
		$(addsuffix node_modules,$(yarn.packages)) \

node_modules: $(yarn.path)/yarn.lock
	touch $@

%/node_modules: $(yarn.path)/yarn.lock
	touch $@

$(yarn.path)/.update-package.json: $(addsuffix package.json,$(yarn.packages))


$(yarn.path)/yarn.lock: \
		$(addsuffix package.json,$(yarn.packages)) \
		$(yarn.path)/.yarnrc.yml
	yarn
	touch $@

%/package.json: $(yarn.path)/package.json
	yarn init
	jq '.workspaces = []' $< > $<-tmp
	mv $<-tmp $<
	packages=$(patsubst $(yarn.path)%,./%,$(filter-out $(yarn.path),$(yarn.packages))); \
	for package in $$packages; do \
		jq ".workspaces -= [\"$$package\"]" $< > $<-tmp; \
		jq ".workspaces += [\"$$package\"]" $<-tmp > $<; \
		rm $<-tmp; \
	done

$(yarn.path)/package.json:
	yarn init
	jq ".private = true" $@ > $@-tmp
	mv $@-tmp $@


$(yarn.path)/.yarnrc.yml:
	echo 'nodeLinker: node-modules' > $@

endif # yarn.mk
