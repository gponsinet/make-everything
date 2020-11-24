ifndef mariadb.mk
dotmk ?= $(patsubst %/,%,$(dir $(lastword $(MAKEFILE_LIST))))
mariadb.mk := $(dotmk)/mariadb.mk

include $(dotmk)/dotmk.mk
include $(dotmk)/helper.mk
include $(dotmk)/brew.mk

.PHONY: \
	install \
	install.mariadb

install: install.mariadb
install.mariadb: $(BREW_HOME)/Cellar/mariadb .mariadb

.IGNORE \
.PHONY: \
	clean \
	clean.mariadb

clean: clean.mariadb
clean.mariadb:

.IGNORE \
.PHONY: \
	trash \
	trash.mariadb

trash: trash.mariadb
trash.mariadb:
	rm -rf .mariadb
	brew uninstall mariadb

.PHONY: \
	start \
	start.mariadb

start: start.mariadb
start.mariadb: install.mariadb
	mariadbd &

.PHONY: \
	stop \
	stop.mariadb

stop: stop.mariadb
stop.mariadb:
	pkill mariadbd

.PHONY: \
	exec \
	exec.mariadb

exec: exec.mariadb
exec.mariadb:
	sudo $(shell which mariadb) \
		-u $(call ask,mariadb,username,root) \
		$(call ask,mariadb,database,)

.PHONY: \
	backup \
	backup.mariadb

backup: backup.mariadb
backup.mariadb:
	$(MAKE) .mariadb/backup/$(call ask,mariadb,date,$(shell date '+%Y-%m-%d'))/$(call ask,mariadb,database,).sql

.PHONY: \
	restore \
	restore.mariadb

restore: restore.mariadb
restore.mariadb: \
	date = $(call select,mariadb,database,$(shell ls .mariadb/backup)) \
	database = $(call select,mariadb,database,$(shell ls .mariadb/backup/$(mariadb/date)))
restore.mariadb: login.mariadb .mariadb/backup
	sudo $(shell which mariadb) -u $(call ask,mariadb,username,root) $(database) \
		< .mariadb/backup/$(date)/$(database).sql

.mariadb:
	mkdir -p $@

.mariadb/backup: .mariadb
	mkdir -p $@

.mariadb/backup/%.sql: .mariadb/backup
	[ -e "$(dir $@)" ] || mkdir $(dir $@)
	mariadb-dump $(basename $(*F)) > $@

endif # mariadb.mk
