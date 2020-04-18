ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(react-native.mk))/global/config.mk
include $(dir $(react-native.mk))/global/helper.mk
include $(dir $(react-native.mk))/yarn.mk

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
install.react-native: .react-native/package.json .react-native/node_modules
ifdef android.mk
install.react-native: $(android.path)/tools $(android.path)/platform-tools
endif

.IGNORE \
.PHONY: clean.react-native
clean.yarn: clean.react-native
ifdef android.mk
clean.react-native: clean.android
endif
clean.react-native:
	yarn remove react-native
	rm -rf .react-native

.IGNORE \
.PHONY: trash.react-native
trash.yarn: trash.react-native
trash.react-native: clean.react-native
	rm -rf .react-native

.PHONY: bundle.react-native.watch
bundle.react-native: \
		install.react-native

.PHONY: \
	debug.react-native.android \
	debug.react-native.ios

debug.react-native.android: install.react-native
	cd .react-native && $(yarn.path)/node_modules/.bin/react-native run-android \
		--variant debug \
		--port '$(call ask,react-native,watch-port,8081)'

debug.react-native.ios: install.react-native
	cd .react-native && $(yarn.path)/node_modules/.bin/react-native run-ios \
		--port '$(call ask,react-native,watch-port,8081)' \
		--verbose

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
