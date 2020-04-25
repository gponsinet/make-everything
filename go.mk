ifndef go.mk
go.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(go.mk))/global/config.mk
include $(dir $(go.mk))/global/helper.mk
include $(dir $(go.mk))/brew.mk

go.path := $(HOME)/.go
go.src := $(go.path)/src
go.bin := $(go.path)/bin

export GOPATH := $(go.path)
export GO111MODULE=auto
export PATH := $(go.bin):$(PATH)

.PHONY: \
	install \
	install.go

install: install.go
install.go: $(brew.cellar)/go

$(go.src)/%:
	go get -u $*

endif # go.mk
