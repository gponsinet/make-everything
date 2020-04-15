ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/global/config.mk
include $(dir $(yarn.mk))/global/helper.mk
include $(dir $(yarn.mk))/brew.mk

yarn.path := $(patsubst %/,%,$(or $(dir $(shell $(call find_up_last,package.json))),$(PWD)))
yarn.packages = $(filter-out $(yarn.path), $(PWD) $(patsubst %/,%,$(dir $(shell \
	find $(yarn.path) -name package.json -not -path "*/node_modules/*" \
))))

.PHONY: install.yarn
install.yarn: install.brew
install.yarn: $(brew.path)/Cellar/yarn node_modules

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
		node_modules \
		$(addsuffix /package.json,$(yarn.packages)) \
		$(addsuffix /node_modules,$(yarn.packages)) \

node_modules: $(PWD)/node_modules
	touch $@

package.json: $(PWD)/package.json

$(PWD)/node_modules: $(yarn.path)/yarn.lock
	mkdir -p $@
	touch $@

%/package.json:
	[ -e "$@" ] || (mkdir -p $(dir $@) && cd $(dir $@) && yarn init)

yarn.lock: $(PWD)/yarn.lock

$(yarn.path)/yarn.lock: \
		$(yarn.path)/package.json \
		$(yarn.path)/.yarnrc.yml \
		$(addsuffix /package.json,$(yarn.packages))
	yarn
	touch $@

$(yarn.path)/package.json: $(brew.path)/Cellar/yarn
	[ -e "$@" ] || yarn init
	jq '.workspaces = []' $@ > $@-tmp
	jq '.private = true' $@ > $@-tmp
	mv $@-tmp $@
	packages=$(patsubst $(yarn.path)/%,./%,$(yarn.packages)); \
	for package in $$packages; do \
		jq ".workspaces -= [\"$$package\"]" $@ > $@-tmp; \
		jq ".workspaces += [\"$$package\"]" $@ > $@-tmp; \
		mv $@-tmp $@; \
	done

$(yarn.path)/.yarnrc.yml:
	rm -f $@
	yarn set version berry
	echo 'nodeLinker: node-modules' >> $@

node_modules/%: node_modules
	yarn add $*

endif # yarn.mk
