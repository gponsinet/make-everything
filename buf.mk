ifndef buf.mk
buf.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(buf.mk))/global/config.mk
include $(dir $(buf.mk))/global/helper.mk
include $(dir $(buf.mk))/brew.mk

buf.root := $(or $(patsubst %/,%,$(dir $(shell $(call find_up_first,.buf)))), $(PWD))
buf.path :=  $(PWD)/.buf

test:
	echo $(buf.root)
	echo $(buf.path)

.PHONY: \
	install \
	install.buf

install: install.buf
install.buf: \
	$(brew.tap)/bufbuild/homebrew-buf \
	$(brew.cellar)/buf \
	$(buf.path)/googleapis \
	$(buf.path)/hack \
	$(buf.path)/buf.yaml

$(buf.path)/:
	([ ! -e "$(buf.path)" ] && [ "$(PWD)" == "$(buf.root)" ] && mkdir -p $@) \
		|| ln -sf $(buf.root)/.buf $(buf.path)

$(buf.path)/hack: $(buf.path)/
	rm $@ && ln -sf .. $@

$(buf.path)/buf.yaml:
	echo 'build:' > $@
	echo '  roots:' >> $@
	echo '    - .buf/googleapis' >> $@
	echo '    - .buf/hack' >> $@
	echo 'lint:' >> $@
	echo '  use:' >> $@
	echo '    - BASIC' >> $@
	echo '    - FILE_LOWER_SNAKE_CASE' >> $@
	echo '  except:' >> $@
	echo '    - ENUM_NO_ALLOW_ALIAS' >> $@
	echo '    - IMPORT_NO_PUBLIC' >> $@
	echo '    - PACKAGE_AFFINITY' >> $@
	echo '    - PACKAGE_DIRECTORY_MATCH' >> $@
	echo '    - PACKAGE_SAME_DIRECTORY' >> $@
	echo 'breaking:' >> $@
	echo '  use:' >> $@
	echo '    - WIRE_JSON' >> $@

$(buf.path)/googleapis: $(buf.path)/
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
	cd $(buf.root) && buf image build -o /dev/null
check.buf.lint: install.buf
	cd $(buf.root) && buf check lint
check.buf.breaking: install.buf
	cd $(buf.root) && buf check breaking --against-input '$(call ask,buf.breaking,againt-input,.git\#branch=master)'

.PHONY: \
	build \
	build.buf \

build: build.buf
build.buf: \
	# TODO

.PHONY: \
	lint \
	lint.buf

lint: lint.buf
lint.buf: install.buf
	# TODO

endif # buf.mk
