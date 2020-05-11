ifndef git-hooks.mk
git-hooks.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(git-hooks.mk))/global/config.mk
include $(dir $(git-hooks.mk))/global/helper.mk

git.hooks := \
	.git/hooks/applypatch-msg \
	.git/hooks/commit-msg \
	.git/hooks/post-applypatch \
	.git/hooks/post-checkout \
	.git/hooks/post-commit \
	.git/hooks/post-merge \
	.git/hooks/post-receive \
	.git/hooks/post-rewrite \
	.git/hooks/post-update \
	.git/hooks/pre-applypatch \
	.git/hooks/pre-auto-gc \
	.git/hooks/pre-commit \
	.git/hooks/pre-push \
	.git/hooks/pre-rebase \
	.git/hooks/pre-receive \
	.git/hooks/prepare-commit-msg \
	.git/hooks/update

.PHONY: \
	install \
	install.git.hooks

install: install.git.hooks
install.git.hooks: $(git.hooks)

.git/hooks: $(git-hooks.mk)
	mkdir -p $@
	touch $@

.git/hooks/%: .git/hooks $(git-hooks.mk)
	echo "#!/usr/bin/env bash" > $@
	echo "make git.hooks.$*" >> $@
	chmod +x $@

.IGNORE \
.PHONY: \
	clean \
	clean.git.hooks

clean: clean.git.hooks
clean.git.hooks:

.IGNORE \
.PHONY: \
	trash \
	trahs.git.hooks

trash:
trash.git.hooks:
	rm $(git.hooks)
	.git/hooks/applypatch-msg \

.PHONY: \
	git.hooks.commit-msg \
	git.hooks.post-applypatch \
	git.hooks.post-checkout \
	git.hooks.post-commit \
	git.hooks.post-merge \
	git.hooks.post-receive \
	git.hooks.post-rewrite \
	git.hooks.post-update \
	git.hooks.pre-applypatch \
	git.hooks.pre-auto-gc \
	git.hooks.pre-commit \
	git.hooks.pre-push \
	git.hooks.pre-rebase \
	git.hooks.pre-receive \
	git.hooks.prepare-commit-msg \
	git.hooks.update

git.hooks.commit-msg \
git.hooks.post-applypatch \
git.hooks.post-checkout \
git.hooks.post-commit \
git.hooks.post-merge \
git.hooks.post-receive \
git.hooks.post-rewrite \
git.hooks.post-update \
git.hooks.pre-applypatch \
git.hooks.pre-auto-gc \
git.hooks.pre-commit \
git.hooks.pre-push \
git.hooks.pre-rebase \
git.hooks.pre-receive \
git.hooks.prepare-commit-msg \
git.hooks.update \
: git.hooks.%: .git/hooks/%


endif # git-hooks.mk
