ifndef git.secret.mk
git-secret.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(git-secret))

.PHONY: \
	install \
	install.git.secret

install: install.git.secret
install.git.secret:

.PHONY: \
	hide \
	hide.git.secret

hide: hide.git.secret
hide.git.secret:

.PHONY: \
	reveal \
	reveal.git.secret

reveal: reveal.git.secret
reveal.git.secret:

ifdef git-hooks.mk
git.hooks.pre-commit: git.secret.hide
git.hooks.post-merge: git.secret.reveal
endif

endif # git-secret.mk
