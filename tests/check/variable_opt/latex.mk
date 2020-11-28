TESTS = foo
TESTS_OPT = $1-$2
TESTS_PARAMS = apple

foo:
	@[ "$1" = "foo-apple apple" ]
