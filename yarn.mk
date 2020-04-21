ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/global/config.mk
include $(dir $(yarn.mk))/global/helper.mk
include $(dir $(yarn.mk))/brew.mk

yarn.path := $(patsubst %/,%,$(or $(dir $(shell \
	$(call find_up_last,package.json) \
)),$(PWD)))
yarn.packages = $(filter-out $(yarn.path), \
	$(PWD) \
	$(patsubst %/,%,$(dir $(shell \
		find $(yarn.path) -name package.json -not -path "*/node_modules/*" \
	))) \
)

.PHONY: \
	install \
	install.yarn

install: install.yarn

install.yarn: install.brew
install.yarn: $(yarn.path)/yarn.lock

.IGNORE \
.PHONY: \
	clean \
	clean.yarn

clean: clean.brew
clean.brew: clean.yarn
clean.yarn:
	rm -rf \
		yarn.lock \
		.yarn \
		.yarnrc.yml \
		.pnp.js \
		yarn-error.log \
		package.json-tmp \
		node_modules \
		$(shell find . -type f -name package.json-tmp) \
		$(shell find . -type f -name node_modules) \

.IGNORE \
.PHONY: trash.yarn

trash: trash.brew
trash.brew: trash.yarn
trash.yarn: clean.yarn
	[ "$(PWD)" != "$(yarn.path)" ] || brew uninstall yarn
	rm -rf $(shell find . -type f -name package.json)

$(yarn.path)/yarn.lock: \
		$(yarn.path)/package.json \
		$(addsuffix /package.json,$(yarn.packages)) \
		| \
		$(yarn.path)/.yarnrc.yml
	yarn
	touch $@

package.json: $(yarn.path)/package.json
	touch $@

$(yarn.path)/package.json: | \
		$(brew.path)/Cellar/node \
		$(brew.path)/Cellar/yarn \
		$(brew.path)/Cellar/jq \
		$(addsuffix /package.json,$(yarn.packages))
	[ -e "$@" ] || yarn init
	jq '.workspaces = []' $@ > $@-tmp
	jq '.private = true' $@-tmp > $@
	rm $@-tmp
	packages="$(patsubst $(yarn.path)/%,./%,$(yarn.packages))"; \
	for package in $$packages; do \
		jq ".workspaces -= [\"$$package\"]" $@ > $@-tmp; \
		jq ".workspaces += [\"$$package\"]" $@-tmp > $@; \
		rm $@-tmp; \
	done
	touch $@

$(yarn.path)/%/package.json: | $(yarn.path)/%/
	[ -e "$@" ] || \
		jq -n '.name = "$(call ask,yarn,$*/package-name,$(shell basename $(PWD)))"' \
			> $@
	touch $@

$(yarn.path)/%/:
	mkdir -p $@

$(yarn.path)/.yarnrc.yml:
	rm -f $@
	yarn set version berry
	echo 'nodeLinker: node-modules' >> $@

$(yarn.path)/node_modules/%:
	yarn add $*

endif # yarn.mk
