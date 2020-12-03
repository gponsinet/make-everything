ifndef dotenv.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
dotenv.mk := $(dotmk)/dotenv.mk

ifndef dotmk.mk
else
	$(warning "dotenv.mk should be included before all others files")
endif

$(shell \
	cat .env \
	| xargs -L1 echo \
	| grep -v '^#' \
	| sed 's,\$$[^{],$$$$,g' \
	| sed 's,\(#\),\\\1,g' \
	| sed 's,^,export ,' \
	| sed 's,=, ?= ,' \
	| sed 's,SHELL ?=,SHELL :=,' \
	> .env.mk 2>/dev/null \
)

.gitignore: $(dotmk)/dotenv/.gitignore

# include at end because it override MAKEFILE_LIST
-include .env.mk

endif
