TESTS = echo check.sh foo
TESTS_OPT = hello world
TESTS_PARAMS = apple banana

foo:
	@[ "$1" = "hello world apple" ] || [ "$1" = "hello world banana" ]
