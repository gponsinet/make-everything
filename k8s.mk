ifndef k8s.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
k8s.mk := $(dotmk)/k8s.mk

include $(dotmk)/brew.mk

.PHONY: \
	install \
	install.k8s

install: install.k8s
install.k8s: \
	$(BREW_HOME)/Cellar/kubernetes-cli \
	$(BREW_HOME)/Cellar/minikube

.IGNORE \
.PHONY: \
	clean \
	clean.k8s

clean: clean.k8s
clean.k8s:

.IGNORE \
.PHONY: \
	trash \
	trash.k8s

trash: trash.k8s
trash.k8s:
	brew uninstall kubernetes-cli minikube

endif # k8s.mk
