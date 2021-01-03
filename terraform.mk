ifndef terraform.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
terraform.mk := $(dotmk)/terraform.mk

include $(dotmk)/brew.mk

.PHONY: \
	install \
	install.terraform

install: install.terraform
install.terraform: brew(hashicorp/tap terraform terraform-ls)

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
trash.terraform: ~brew(terraform terraform-ls)

.SpaceVim.d/coc-settings.json: %: $(dotmk)/terraform/%

endif # terraform.mk
