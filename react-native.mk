ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(react-native.mk))/yarn.mk

install: install.react-native
clean: clean.react-native

.PHONY: install.react-native
install.react-native: install.yarn
install.react-native: .rn

.IGNORE \
.PHONY: clean.react-native
clean.yarn: clean.react-native
clean.react-native:
	yarn remove --dev react-native
	rm -rf \
		.rn \
		.tmp-rn \
		.tmp-rn-remove-workspace-package.json \

.tmp-rn-remove-workspace-package.json:
	jq '.workspace.packages -= ["$*"]' package.json > $@

.tmp-rn-add-workspace-package.json: .tmp-rn-remove-workspace-package.json
	rm $<
	jq '.workspace.packages += ["$*"]' package.json > $@

.tmp-rn:
	mkdir -p $@

.rn: node_modules/react-native node_modules/react-native-cli \
	| .tmp-rn-add-workspace-package.json .tmp-rn
	mv .tmp-rn-add-workspace-package.json package.json
	cd .tmp-rn && echo y | yarn react-native init \
		`jq .name ../package.json | sed 's/"//g'`
	mv .tmp-rn/`jq .name package.json | sed 's/"//g'` .rn && rm -rf .tmp-rn

node_modules/react-native:
	yarn add --dev react-native@latest

endif # react-native.mk
