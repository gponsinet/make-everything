ifndef gopass.mk
gopass.mk := $(lastword $(MAKEFILE_LIST))

include $(dir $(gopass.mk))/config.mk
include $(dir $(gopass.mk))/helper.mk
include $(dir $(gopass.mk))/brew.mk
include $(dir $(gpg.mk))/gpg.mk

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
