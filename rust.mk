ifndef rust.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
rust.mk := $(dotmk)/rust.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

export CARGO_HOME := $(HOME)/.caro

CARGO_HOME := $(HOME)/.cargo

export PATH := $(CARGO_HOME)/bin:$(PATH)

.PHONY: \
	install \
	install.rust

install: install.rust
install.rust: \
	$(CARGO_HOME)/bin/rustup \
	$(CARGO_HOME)/bin/cross
	#	$(CARGO_HOME)/bin/racer
	rustup component add rls rust-analysis rust-src

# .PHONY: \
# 	build \
# 	build.rust
#
# build: build.rust
# build.rust: target ?=
# build.rust: verbose ?=
# build.rust: install.rust
# 	cross build $(if $(target),--target=$(target)) $(if $(verbose),-vv)

.IGNORE \
.PHONY: \
	clean \
	clean.rust

clean: clean.rust
clean.rust:
	cross clean

.IGNORE \
.PHONY: \
	trash \
	trash.rust

trash: trash.rust
trash.rust: clean.rust
	rustup self uninstall

$(CARGO_HOME)/bin/rustup: | $(BREW_HOME)/Cellar/curl
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

ifneq ($(CURDIR),$(HOME))
install.rust: Cargo.toml
Cargo.toml: | $(HOME)/.cargo/bin/rustup
	cargo init
endif

$(CARGO_HOME)/bin/%: $(HOME)/.cargo/bin/rustup
	cargo install $*

.SpaceVim.d/init.toml \
.SpaceVim.d/coc-settings.json \
	: %: $(dotmk)/rust/%

# $(CARGO_HOME)/bin/racer:
# 	rustup toolchain add nightly
# 	cargo +nightly install racer

endif # rust.mk
