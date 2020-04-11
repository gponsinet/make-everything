ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/global/config.mk
include $(dir $(yarn.mk))/global/system.mk
include $(dir $(yarn.mk))/brew.mk

.PHONY: yarn/setup
package.json:
	yarn init
.yarn: package.json
	yarn set version berry
	yarn
.yarnrc.yml: .yarn
	echo 'nodeLinker: node-modules' > $@
yarn.lock: .yarnrc.yml $(shell find . -type d -name package.json -not -path '*/node_module/*')
	yarn
yarn/setup := \
	package.json \
	.yarn \
	.yarnrc.yml \
	yarn.lock
yarn/setup: brew/install/yarn $(yarn/setup)

.IGNORE \
.PHONY: yarn/trash
yarn/trash: brew/uninstall/yarn
	rm -rf $(yarn/setup)

.PHONY: yarn/add/%
yarn/add/%: yarn/setup
	yarn add $*

.PHONY: yarn/remove/%
yarn/remove/%:
yarn/remove/%:
	yarn remove $*

endif # yarn.mk
