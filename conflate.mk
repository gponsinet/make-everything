ifndef conflate.mk
conflate.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(conflate.mk))/config.mk
include $(dir $(conflate.mk))/go.mk

.PHONY: \
	install \
	install.conflate

install: install.conflate
install.conflate: $(GOPATH)/bin/conflate

$(GOPATH)/bin/conflate:
	$(GOPATH)/src/github.com/miracl/conflate/...

.IGNORE: \
	trash \
	trash.conflate

# trash: trash.conflate
# trash.go: trash.conflate
trash.conflate:
	go clean -i github.com/miracl/conflate
	rm -rf $(GOPATH)/src/github.com/miracl/conflate/...

endif
