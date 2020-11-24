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

$(GOPATH)/src/%: | install.go
	go get -u $*

.IGNORE \
.PHONY: \
	trash \
	trash.go

trash: trash.go
trash.brew: trash.go
trash.go:
	rm -rf $(GOPATH)

endif # go.mk
