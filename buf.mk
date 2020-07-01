ifndef buf.mk
buf.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(buf.mk))/global/config.mk
include $(dir $(buf.mk))/global/helper.mk
include $(dir $(buf.mk))/brew.mk

buf.root := $(patsubst %/,%,$(or $(dir $(shell \
	$(call find_up_first,.mk) \
)),$(PWD)))
buf.path :=  $(buf.root)/.buf

.PHONY: \
	install \
	install.buf

install: install.buf
install.buf: \
	$(brew.tap)/bufbuild/homebrew-buf \
	$(brew.cellar)/buf \
	$(brew.cellar)/coreutils \
	$(buf.path)/googleapis \
	$(buf.path)/root \
	$(buf.root)/buf.yaml

$(buf.path)/:
	mkdir -p $@
	touch $@

$(buf.path)/root: | $(buf.path)/
	rm -f $@ && ln -sf .. $@

$(buf.root)/buf.yaml: | $(buf.path)/
	echo 'build:' > $@
	echo '  roots:' >> $@
	echo '    - .buf/googleapis' >> $@
	echo '    - .buf/root' >> $@
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

$(buf.path)/googleapis: $(buf.path)/googleapis/.git | $(buf.path)/
$(buf.path)/googleapis/.git: path := $(shell realpath --relative-to=$(buf.root) $(buf.path)/googleapis)
$(buf.path)/googleapis/.git:
	git submodule add https://github.com/googleapis/googleapis $(path)
		--branch d4aa417ed2bba89c2d216900282bddfdafef6128 \
		2>/dev/null \
		|| git submodule update --init --recursive $(path)

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
