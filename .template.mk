ifndef .template.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
.template.mk := $(dotmk)/.template.mk

.gitignore: $(dotmk)/.template/.gitignore
package.json: $(dotmk)/.template/package.json
.SpaceVim.d/init.toml: $(dotmk)/.template/.SpaceVim.d/init.toml

endif
