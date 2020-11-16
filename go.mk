ifndef go.mk
go.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(go.mk))/config.mk
include $(dir $(go.mk))/brew.mk

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

.PHONY: \
	trash \
	trash.go

trash: trash.go
trash.brew: trash.go
trash.go:
	rm -rf $(GOPATH)

endif # go.mk
