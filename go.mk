ifndef go.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
go.mk := $(dotmk)/go.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

export GOPATH := $(HOME)/.go
export GO111MODULE=auto
export PATH := $(GOPATH)/bin:$(PATH)

.PHONY: \
	install \
	install.go

install: install.go
install.go: $(BREW_HOME)/Cellar/go

.PHONY: $(GOPATH)/src/%
$(GOPATH)/src/%:
	go get -u $*

.IGNORE \
.PHONY: \
	trash \
	trash.go

trash: trash.go
trash.brew: trash.go
trash.go:
	rm -rf \
		$(GOPATH)/src/github.com/jstemmer/gotags \
		$(GOPATH)/src/github.com/sourcegraph/go-langserver \
		$(GOPATH)

.SpaceVim.d/init.toml: $(dotmk)/go/.SpaceVim.d/init.toml
.SpaceVim.d/init.toml: | \
	$(GOPATH)/src/github.com/jstemmer/gotags \
	$(GOPATH)/src/github.com/sourcegraph/go-langserver
.SpaceVim.d/coc-settings.json: $(dotmk)/go/.SpaceVim.d/coc-settings.json

endif # go.mk
