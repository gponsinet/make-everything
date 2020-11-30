ifndef curl.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
curl.mk := $(dotmk)/curl.mk

include $(dotmk)/dotmk.mk

install: curl
trash: ~curl

.PHONY: curl curl.% curl(%)
.IGNORE \
.PHONY: ~curl ~curl.% ~curl(%)

curl:
	which curl | grep -v 'not found' || (echo "Please install curl before continue" || @false) 

~curl:
	@true

curl(%) ~curl(%):
	make $(foreach _,$*,$@.$_)

curl.%:
	curl https://$*

~curl.%:
	@true

endif

