ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(react-native.mk))/global/config.mk
include $(dir $(react-native.mk))/global/system.mk
include $(dir $(react-native.mk))/global/helper.mk
include $(dir $(react-native.mk))/yarn.mk
include $(dir $(react-native.mk))/android.mk

react-native/files := $(addprefix .react-native, \
	android \
	app.json \
	App.tsx \
	babel.config.js \
	.buckconfig \
	.eslintrc.js \
	.gitattributes \
	.gitignore \
	index.js \
	ios \
	metro.config.js \
	.prettierrc.js \
	__tests__ \
	tsconfig.json \
	.watchmanconfig \
)

.PHONY: install.react-native
install.react-native: \
	.react-native/package.json \
	.react-native/node_modules \

.PHONY: install.react-native.android
install.react-native.android: \
	install.react-native \
	install.android.tools \
	install.android.platform-tools \
	install.android.emulator

ifdef global/system/darwin
install.react-native.ios: \
		install.react-native
endif

.IGNORE \
.PHONY: clean.react-native
clean.yarn: clean.react-native
clean.react-native: clean.android
clean.react-native:
	yarn remove react-native
	rm -rf .react-native

.IGNORE \
.PHONY: trash.react-native
trash.yarn: trash.react-native
trash.react-native: clean.react-native
	rm -rf .react-native


.PHONY: debug.react-native.android
debug.react-native.android: install.react-native.android
	cd .react-native && $(yarn.path)/node_modules/.bin/react-native run-android \
		--variant debug \
		--port '$(call ask,react-native,watch-port,8081)'

.PHONY: release.react-native.android
release.react-native.android: install.react-native.android
	# todo

ifdef global/system/darwin
.PHONY: debug.react-native.ios
debug.react-native.ios: install.react-native.ios
	cd .react-native && $(yarn.path)/node_modules/.bin/react-native run-ios \
		--port '$(call ask,react-native,watch-port,8081)' \
		--verbose

.PHONY: release.react-native.ios
release.react-native.ios: install.react-native.ios
	# todo
endif

react-native/package := $(shell \
	jq .workspaces $(yarn.path)/package.json \
	| grep '$(shell \
			echo $(PWD) | sed "s|^$(yarn.path)\(.*\)|.\1/.react-native|" \
		)' \
)
ifndef react-native/package
# permit to add .react-native/ as workspace package
$(yarn.path)/package.json: $(PWD)/.react-native/package.json
$(PWD)/.react-native/package.json: $(PWD)/.react-native/
	touch $@
endif

.react-native/package.json: | \
		$(yarn.path)/package.json \
		$(yarn.path)/node_modules/.bin/react-native
	rm -rf $(dir $@)
	chmod +x $(yarn.path)/node_modules/.bin/react-native
	$(yarn.path)/node_modules/.bin/react-native init \
		'$(call ask,react-native,project-name,RNApp)' \
		--title '$(call ask,react-native,app-title,$(react-native/project-name))' \
		--directory '$(dir $@)' \
		--template '$(call ask,react-native,\
			template,react-native-template-typescript)'
	touch $@

$(yarn.path)/node_modules/.bin/react-native: | $(yarn.path)/yarn.lock
	yarn add react-native

.react-native/node_modules:
	ln -sf $(yarn.path)/node_modules $@

endif # react-native.mk
