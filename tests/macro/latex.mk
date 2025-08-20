TESTS = _run_testsuite

CLEANFILES += 1.tmp

test_is_texlive:
	$(call assert_true,$(is_texlive))

test_rule_exists:
	$(call assert_true, $(call rule_exists,foo-rule))
	$(call assert_true, $(call rule_exists,bar-rule))
	$(call assert_false,$(call rule_exists,baz-rule))

foo-rule: _FORCE
	:

bar-rule: _FORCE

test_color_enabled:
	$(call assert_success,$(MAKE) COLOR=always check_color_enabled)
	$(call assert_fail,   $(MAKE) COLOR=never  check_color_enabled)
	# for compatibility with previous versions
	$(call assert_success,MAKE_COLORS=always $(MAKE) check_color_enabled)
	$(call assert_fail,   MAKE_COLORS=none   $(MAKE) check_color_enabled)

check_color_enabled:
	$(color_enabled)

test_ensure_build_dir:
	$(call assert_success,$(ensure_build_dir))
	$(if $(BUILDDIR),[ -d $(BUILDDIR) ])

test_mv_target:
	$(ensure_build_dir)
	touch $(build_prefix)1.tmp
	$(call assert_success,$(call mv_target,1.tmp))
	$(call assert_fail,   $(call mv_target,2.tmp))
	$(call assert_success,$(call mv_target,3.tmp,false))

test_uppercase:
	$(call assert_eq,$(call uppercase,abcxyzABCXYZ0189  !"#%&*+-./x:;<=>?@x[]^_`x{|}~x  y),ABCXYZABCXYZ0189  !"#%&*+-./X:;<=>?@X[]^_`X{|}~X  Y)

test_lowercase:
	$(call assert_eq,$(call lowercase,abcxyzABCXYZ0189  !"#%&*+-./X:;<=>?@X[]^_`X{|}~X  Y),abcxyzabcxyz0189  !"#%&*+-./x:;<=>?@x[]^_`x{|}~x  y)

test_sanitize:
	$(call assert_eq,$(call sanitize,abcxyzABCXYZ0189  !"#%&*+-./x:;<=>?@x[]^_`x{|}~x  y),abcxyzABCXYZ0189____________x_______x_____x____x__y)

test_to_bool:
	$(call assert_eq,$(call to_bool,true),true)
	$(call assert_eq,$(call to_bool,false),false)
	$(call assert_eq,$(call to_bool,True),true)
	$(call assert_eq,$(call to_bool,False),false)
	$(call assert_eq,$(call to_bool,TRUE),true)
	$(call assert_eq,$(call to_bool,FALSE),false)
	$(call assert_eq,$(call to_bool,T),true)
	$(call assert_eq,$(call to_bool,F),false)
	$(call assert_eq,$(call to_bool,yes),true)
	$(call assert_eq,$(call to_bool,no),false)
	$(call assert_eq,$(call to_bool,Yes),true)
	$(call assert_eq,$(call to_bool,No),false)
	$(call assert_eq,$(call to_bool,YES),true)
	$(call assert_eq,$(call to_bool,NO),false)
	$(call assert_eq,$(call to_bool,on),true)
	$(call assert_eq,$(call to_bool,off),false)
	$(call assert_eq,$(call to_bool,On),true)
	$(call assert_eq,$(call to_bool,Off),false)
	$(call assert_eq,$(call to_bool,ON),true)
	$(call assert_eq,$(call to_bool,OFF),false)
	$(call assert_eq,$(call to_bool,1),true)
	$(call assert_eq,$(call to_bool,0),false)
	$(call assert_eq,$(call to_bool,),false)
	$(call assert_eq,$(call to_bool,,true),true)
	$(call assert_eq,$(call to_bool,,1),true)
	$(call assert_fail,$(MAKE) check_to_bool_2)

check_to_bool_2:
	echo $(call to_bool,2)
