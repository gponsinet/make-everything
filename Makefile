include dotmk.mk

%.mk:
	[ -d $* ] || mkdir $*
	for file in $(shell find .template -type f | sed s,\^\.template/,,); do \
		[ -d $*/$$(dirname $$file) ] || mkdir $*/$$(dirname $$file); \
		if [ -f $*/$$file ]; then \
			[ ! -f $*/$$file.bkp ] || mv $*/$$file $*/$$file.bkp; \
			git merge-file $*/$$file .template/$$file $*/$$file.bkp; \
			rm -f $*/$$file.bkp; \
		else \
			cp .template/$$file $*/$$file; \
		fi; done
	[ -f $@ ] || (cp .template.mk $@ && sed -i.bkp s,\.template,$*,g $@ && rm $@.bkp)
