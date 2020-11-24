ifndef gopass.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
gopass.mk := $(dotmk)/gopass.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/helper.mk
include $(dotmk)/brew.mk
include $(dotmk)/gpg.mk

.PHONY: \
	install \
	install.gopass

install: install.gopass
install.gopass: \
	install.brew \
	$(brew.cellar)/gopass \
	$(brew.tap)/amar1729/homebrew-formulae \
	$(brew.cellar)/browserpass \
	/usr/local/opt/browserpass/lib/browserpass/hosts/chromium/com.github.browserpass.native.json \
	/usr/local/opt/browserpass/lib/browserpass/hosts/firefox/com.github.browserpass.native.json \

/usr/local/opt/browserpass/lib/browserpass/hosts/%/com.github.browserpass.native.json:
	PREFIX='/usr/local/opt/browserpass' make hosts-$*-user -f /usr/local/opt/browserpass/lib/browserpass/Makefile


.IGNORE \
.PHONY: \
	trash \
	trash.gopass
# trash: trash.gopass
# trash.brew: trash.gopass
trash.gopass:
	brew uninstall gopass browserpass 

endif
