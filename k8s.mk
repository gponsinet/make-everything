ifndef k8s.mk
k8s.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(k8s.mk))/brew.mk

.PHONY: \
	install \
	install.k8s

install: install.k8s
install.k8s: \
	$(brew.path)/Cellar/kubernetes-cli \
	$(brew.path)/Cellar/minikube

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
