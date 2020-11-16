ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(react-native.mk))/config.mk
include $(dir $(react-native.mk))/system.mk
include $(dir $(react-native.mk))/helper.mk
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

.PHONY: \
	install \
	install.react-native \
	install.react-native.android

install: install.react-native
install.react-native: \
	.react-native/index.js \
	.react-native/node_modules
install.react-native.android: \
	install.react-native \
	install.android.tools \
	install.android.platform-tools \
	install.android.emulator

.IGNORE \
.PHONY: \
	clean \
	clean.react-native \
	clean.react-native.android

clean: clean.yarn
clean.yarn: clean.react-native
clean.react-native: clean.react-native.android
clean.react-native.android: clean.android

clean.react-native:
	rm -rf .react-native

.IGNORE \
.PHONY: \
	trash \
	trash.react-native \
	trash.react-native.android

trash: trash.react-native
trash.yarn: trash.react-native
trash.react-native: clean.react-native
trash.react-native.android: clean.react-native.android

trash.react-native:
	yarn remove react-native

.PHONY: \
	debug \
	debug.react-native \
	debug.react-native.android

debug: debug.react-native
debug.react-native: debug.react-native.android
debug.react-native.android: install.react-native.android

debug.react-native.android:
	cd .react-native && $(yarn.root)/node_modules/.bin/react-native run-android \
		--variant debug \
		--port '$(call ask,react-native,watch-port,8081)'

.PHONY: \
	release \
	release.android \
	release.react-native.android

release.react-native.android: install.react-native.android
	# todo

react-native/package := $(shell \
	jq .workspaces $(yarn.root)/package.json \
	| grep '$(shell \
			echo $(PWD) | sed "s|^$(yarn.root)\(.*\)|.\1/.react-native|" \
		)' \
)
ifndef react-native/package
# permit to add .react-native/ as workspace package
$(yarn.root)/package.json: $(PWD)/.react-native/package.json
$(PWD)/.react-native/package.json: $(PWD)/.react-native/
	touch $@
endif

.react-native/index.js: | \
		$(yarn.root)/package.json \
		$(yarn.root)/node_modules/.bin/react-native
	rm -rf $(dir $@)
	chmod +x $(yarn.root)/node_modules/.bin/react-native
	$(yarn.root)/node_modules/.bin/react-native init \
		'$(call ask,react-native,project-name,RNApp)' \
		--title '$(call ask,react-native,app-title,$(react-native/project-name))' \
		--directory '$(dir $@)' \
		--template '$(call ask,react-native,\
			template,react-native-template-typescript)'
	touch $@

$(yarn.root)/node_modules/.bin/react-native: | $(yarn.root)/yarn.lock
	yarn add react-native

.react-native/node_modules:
	ln -sf $(yarn.root)/node_modules $@

endif # react-native.mk
