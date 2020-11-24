all-test:
	@$(run_testsuite)

CLEANFILES += 1.tmp

test_is_texlive:
	$(if $(is_texlive),:,false)

test_rule_exists:
	$(if $(call rule_exists,foo-rule),:,false)
	$(if $(call rule_exists,bar-rule),:,false)
	$(if $(call rule_exists,baz-rule),false,:)

foo-rule: _FORCE
	:

bar-rule: _FORCE

test_ensure_build_dir:
	$(ensure_build_dir)
	$(if $(BUILDDIR),[ -d $(BUILDDIR) ])

test_mv_target:
	$(if $(BUILDDIR),mkdir -p $(BUILDDIR))
	touch $(build_prefix)1.tmp
	$(call mv_target,1.tmp)
	if { $(call mv_target,2.tmp); }; then false; else :; fi
	$(call mv_target,3.tmp,false)
