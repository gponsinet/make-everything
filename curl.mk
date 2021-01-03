ifndef curl.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
curl.mk := $(dotmk)/curl.mk

include $(dotmk)/dotmk.mk

install: curl
trash: ~curl

.PHONY: curl curl+% curl(%)
.IGNORE \
.PHONY: curl ~curl~% ~curl(%)

curl:
	which curl | grep -v 'not found' || (echo "Please install curl before continue" || @false)

~curl:
	@true

curl(%):
	make $(foreach _,$*,curl+$_)

~curl(%):
	make $(foreach _,$*,curl~$_)

curl+%:
	curl https://$*

curl~%:
	@true

endif

