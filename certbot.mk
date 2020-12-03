ifndef $(dotmk)/certbot.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
certbot.mk := $(dotmk)/certbot.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/brew.mk

.PHONY: certbot
.IGNORE: +certbot
+certbot -certbot: %: brew(%)
	@true

.PHONY: certbot(%)
certbot(%):
	make $(foreach _,$*,$@.%)

endif
