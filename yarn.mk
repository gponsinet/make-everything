ifndef yarn.mk
yarn.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(yarn.mk))/global/config.mk
include $(dir $(yarn.mk))/global/system.mk
include $(dir $(yarn.mk))/brew.mk

.PHONY: yarn/setup
package.json: $(brew/install)/yarn $(brew/install)/jq
	yarn init
	yarn set version berry
	echo 'nodeLinker: node-modules' > .yarnrc.yml
	jq '.workspace = { packages: [] }' package.json > package-update.json
	mv package-update.json package.json
yarn.lock: package.json
	yarn
	touch $@
yarn/setup := yarn.lock
yarn/setup: $(yarn/setup)

.IGNORE: brew/uninstall/yarn
.IGNORE \
.PHONY: yarn/trash
yarn/trash: brew/uninstall/yarn
	rm -rf \
		yarn.lock \
		package.json \
		.yarn \
		.yarnrc.yml \
		node_modules \
		yarn-error.log \
		.pnp.js

.PHONY: yarn/add/%
yarn/add := node_modules
$(yarn/add)/%: $(yarn/setup)
	yarn add $*
yarn/add/%:
	$(MAKE) $@

.PHONY: yarn/add/dev/%
yarn/add/dev := node_modules
$(yarn/add/dev)/%: $(yarn/setup)
	yarn add -D $*
	touch $@
yarn/add/dev/%:
	$(MAKE) $@

.PHONY: yarn/add/peer/%
yarn/add/peer := node_modules
$(yarn/add/peer)/%: $(yarn/setup)
	yarn add -P $*
yarn/add/peer/%:
	$(MAKE) $@

.PHONY: yarn/remove/%
yarn/remove := yarn/remove
yarn/remove/%:
	yarn remove $* || true

.PHONY: yarn/workspace/add/%
yarn/workspace/add := $(yarn/workspace/add)
yarn/workspace/add/%: $(yarn/setup)
	jq '.workspace.packages -= ["$*"]' package.json > package-update.json
	mv package-update.json package.json
	jq '.workspace.packages += ["$*"]' package.json > package-update.json
	mv package-update.json package.json

.PHONY: yarn/workspace/remove/%
yarn/workspace/remove := $(yarn/workspace/remove)
yarn/workspace/remove/%:
	jq '.workspace.packages -= ["$*"]' package.json > package-update.json
	mv package-update.json package.json

endif # yarn.mk
