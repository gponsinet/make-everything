ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/global/config.mk
include $(dir $(yarn.mk))/global/helper.mk
include $(dir $(yarn.mk))/brew.mk

yarn.global := $(HOME)/.config/yarn/global
yarn.global.mod := $(yarn.global)/node_modules
yarn.global.bin := $(yarn.global.mod)/.bin

yarn.root := $(patsubst %/,%,$(or $(dir $(shell \
	$(call find_up_last,package.json) \
)),$(PWD)))
yarn.packages = $(filter-out $(yarn.root), \
	$(PWD) \
	$(patsubst %/,%,$(dir $(shell \
		find $(yarn.root) -name package.json -not -path "*/node_modules/*" \
	))) \
)
yarn.mod := $(yarn.root)/node_modules
yarn.bin := $(yarn.mod)/.bin

yarn.package := .

export PATH := $(yarn.bin):$(yarn.global.bin):$(PATH)

.PHONY: \
	install \
	install.yarn \
	install.yarn.workspace

install: install.yarn

install.yarn: $(brew.cellar)/yarn
install.yarn.workspace: $(yarn.root)/yarn.lock
install.yarn.package: package.json

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
		$(shell find . -type f -name node_modules)

.IGNORE \
.PHONY: trash.yarn

trash:
trash.brew: trash.yarn
trash.yarn: clean.yarn
	[ "$(PWD)" != "$(yarn.root)" ] || brew uninstall yarn
	rm -rf $(shell find . -type f -name package.json)

$(yarn.root)/yarn.lock: \
	$(yarn.root)/.yarnrc.yml \
	$(yarn.root)/package.json
	yarn
	touch $@

package.json:
	npm init

$(yarn.root)/package.json: $(yarn.packages) \
	|	$(brew.cellar)/node \
		$(brew.cellar)/yarn \
		$(brew.cellar)/jq
	[ -e "$@" ] || npm init
	jq '.workspaces = []' $@ > $@-tmp
	jq '.private = true' $@-tmp > $@
	packages="$(patsubst $(yarn.root)/%,./%,$(yarn.packages))"; \
	for package in $$packages; do \
		jq ".workspaces -= [\"$$package\"]" $@ > $@-tmp; \
		jq ".workspaces += [\"$$package\"]" $@-tmp > $@; \
	done
	rm $@-tmp
	touch $@

$(yarn.root)/.yarnrc.yml:
	rm -f $@
	yarn set version berry
	echo 'nodeLinker: node-modules' >> $@
	yarn plugin import typescript

$(yarn.root)/node_modules/%:
	yarn add $*

$(yarn.global.mod)/%: | install.yarn
	yarn global add $*

endif # yarn.mk
