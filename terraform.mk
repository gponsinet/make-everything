ifndef terraform.mk
terraform.mk := $(abspath $(lastword $(MAKEFILE_LIST)))

include $(dir $(terraform.mk))/brew.mk

.PHONY: install.terraform
install.terraform: \
	$(brew.path)/Cellar/terraform

endif # terraform.mk
