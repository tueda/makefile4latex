tests = $(shell $(MAKE) -pq _FORCE | sed -n '/^test_/p' | sed 's/:.*//')

all-test:
	@for test in $(tests); do \
		echo "Testing $$test..."; \
		$(MAKE) --silent clean; \
		$(MAKE) --always-make --no-print-directory $$test || exit 1; \
	done

CLEANFILES += 1.tmp

test_ensure_build_dir:
	$(ensure_build_dir)
	$(if $(BUILDDIR),[ -d $(BUILDDIR) ])

test_is_texlive:
	$(if $(is_texlive),:,false)

test_mv_target:
	$(if $(BUILDDIR),mkdir -p $(BUILDDIR))
	touch $(build_prefix)1.tmp
	$(call mv_target,1.tmp)
	if { $(call mv_target,2.tmp); }; then false; else :; fi
	$(call mv_target,3.tmp,false)
