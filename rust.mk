ifndef rust.mk
rust.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(rust.mk))/global/config.mk
include $(dir $(rust.mk))/global/helpers.mk
include $(dir $(rust.mk))/brew.mk

rust.root := $(patsubst %/,%,$(or $(dir $(shell \
	$(call find_up_first,Cargo.toml) \
)),$(PWD)))
rust.global := $(HOME)/.cargo
rust.global.bin := $(rust.global)/bin

export PATH := $(rust.global.bin):$(PATH)

.PHONY: \
	install \
	install.rust

install: install.rust
install.rust: \
	$(HOME)/.cargo/bin/rustup \
	$(rust.global.bin)/cross \
	$(rust.root)/Cargo.toml

.PHONY: \
	build \
	build.rust

build: build.rust
build.rust: target ?=
build.rust: verbose ?=
build.rust: install.rust
	cross build $(if $(target),--target=$(target)) $(if $(verbose),-vv)

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

$(HOME)/.cargo/bin/rustup: | $(brew.cellar)/curl
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

$(rust.root)/Cargo.toml: | $(HOME)/.cargo/bin/rustup
	cargo init

$(rust.global.bin)/%: $(HOME)/.cargo/bin/rustup
	cargo install %

endif # rust.mk
