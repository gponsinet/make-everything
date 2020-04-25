ifndef buf.mk
buf.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(buf.mk))/global/config.mk
include $(dir $(buf.mk))/global/helper.mk
include $(dir $(buf.mk))/brew.mk

buf.path := $(or $(dir $(shell $(call find_up_first,buf.yaml))), $(PWD))

.PHONY: \
	install \
	install.buf

install: install.buf
install.buf: \
	$(brew.tap)/bufbuild/homebrew-buf \
	$(brew.cellar)/buf \
	$(buf.path)/.buf/googleapis \
	$(buf.path)/.buf/hack \
	$(buf.path)/buf.yaml

define buf/buf.yaml
> build:
>   roots:
>     - .buf/googleapis
>     - .buf/hack
> lint:
>   use:
>     - BASIC
>     - FILE_LOWER_SNAKE_CASE
>   except:
>     - ENUM_NO_ALLOW_ALIAS
>     - IMPORT_NO_PUBLIC
>     - PACKAGE_AFFINITY
>     - PACKAGE_DIRECTORY_MATCH
>     - PACKAGE_SAME_DIRECTORY
> breaking:
>   use:
>     - WIRE_JSON
endef

$(buf.path)/.buf/hack:
	ln -s .. $@

.ONESHELL: $(buf.path)/buf.yaml
$(buf.path)/buf.yaml:
	echo '$(buf/buf.yaml)' | sed 's/> //g' > $@

$(buf.path)/.buf/:
	mkdir -p $@

$(buf.path)/.buf/googleapis: $(buf.path)/.buf/
	rm -rf $@
	mkdir -p $@ && cd $@ \
		&& git init \
		&& git remote add origin https://github.com/googleapis/googleapis \
	  && git fetch --depth 1 origin d4aa417ed2bba89c2d216900282bddfdafef6128 \
		&& git checkout FETCH_HEAD

.PHONY: \
	clean \
	clean.buf

clean: clean.buf
clean.brew: clean.buf
clean.buf:
	rm -rf .buf

.PHONY: \
	trash \
	trash.buf

trash: trash.buf
trash.brew: trash.buf
trash.buf:
	rm -rf buf.yml
	brew uninstall buf
	brew untap bufbuild/buf

.PHONY: \
	check \
	check.buf \
	check.buf.build \
	check.buf.lint \
	check.buf.breaking

check: check.buf
check.buf: \
	check.buf.build \
	check.buf.lint \
	check.buf.breaking
check.buf.build: install.buf
	buf image build -o /dev/null
check.buf.lint: install.buf
	buf check lint
check.buf.breaking: install.buf
	buf check breaking --against-input '$(call ask,buf.breaking,againt-input,.git\#branch=master)'

.PHONY: \
	build \
	build.buf

build: build.buf
build.buf: install.buf

.PHONY: \
	lint \
	lint.buf

lint: lint.buf
lint.buf: install.buf

endif # buf.mk
