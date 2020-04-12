ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(react-native.mk))/global/config.mk
include $(dir $(react-native.mk))/brew.mk
include $(dir $(react-native.mk))/yarn.mk

.PHONY: react-native/setup
react-native/setup := .rn
.DELETE_ON_ERROR: $(react-native/setup)
$(react-native/setup): $(brew/install)/jq $(yarn/add/dev)/react-native-cli
	$(MAKE) yarn/workspace/add/.rn
	echo y | yarn react-native init \
		--template typescript \
		`jq .name package.json | sed 's/"//g'`
	mv `jq .name package.json | sed 's/"//g'` .rn
react-native/setup: $(react-native/setup)

.PHONY: react-native/upgrade
react-native/upgrade: $(react-native/setup)
	yarn react-native upgrade

.PHONY: react-native/trash
react-native/trash := \
	$(yarn/remove)/react-native-cli \
	yarn/workspace/remove/.rn
.IGNORE: react-native/trash $(react-native/trash)
react-native/trash: $(react-native/trash)
	rm -rf $(react-native/setup)
yarn/trash: react-native/trash

endif # react-native.mk
