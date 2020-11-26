include dotmk.mk

%.mk:
	for file in $$(find .template -type f | sed s,\^\.template/,,); do \
		[ -d $* ] || mkdir -p $$(dirname $$file); \
		if [ -f $*/$$file ]; then \
			mv $*/$$file $*/$$file.bkp; \
			git merge-file $*/$$file .template/$$file $*/$$file; \
		else \
			cp .template/$$file $*/$$file; \
		fi; done
	[ -f $@ ] || (cp .template.mk $@ && sed -i.bkp s,\.template,$*,g $@ && rm $@.bkp)
