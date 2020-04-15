ifndef react-native.mk
react-native.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

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
install.react-native: .react-native

.IGNORE \
.PHONY: clean.react-native
clean.yarn: clean.react-native
clean.react-native:
	yarn remove react-native
	rm -rf .react-native

react-native/app-title ?= \
	$(shell $(call read,react-native/app-title,$(shell jq .name package.json|sed 's/"//g')))
react-native/template ?= \
	$(shell $(call read,react-native/template,react-native-template-typescript))

.react-native: | .react-native/package.json node_modules/.bin/react-native
	chmod +x node_modules/.bin/react-native
	rm -rf .react-native
	./node_modules/.bin/react-native init \
		'RN' \
		--title '$(react-native/app-title)' \
		--directory '$@' \
		--template '$(react-native/template)'
	jq '.name = "@mk/react-native"' .react-native/package.json \
		> .react-native/package.json-tmp
	mv .react-native/package.json-tmp .react-native/package.json
	yarn

.react-native/package.json:
	mkdir -p $(dir $@)
	jq -n '.name = "@mk/react-native"' > $@

node_modules/.bin/react-native: $(yarn.path)/yarn.lock
	yarn add --dev react-native

endif # react-native.mk
