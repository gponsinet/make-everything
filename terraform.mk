ifndef terraform.mk
terraform.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(terraform.mk))/brew.mk

.PHONY: \
	install \
	install.terraform

install: install.terraform
install.terraform: \
	$(brew.path)/Cellar/terraform

.IGNORE \
.PHONY: \
 clean \
 clean.terraform

clean: clean.terraform
clean.terraform:

.IGNORE \
.PHONY: \
	trash \
	trash.terraform

trash: trash.terraform
trash.terraform:
	brew uninstall terraform

endif # terraform.mk
