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
git.hooks.pre-commit: hide.git.secret
git.hooks.post-merge: reveal.git.secret
endif

endif # git-secret.mk
