TESTS = echo check.sh foo
TESTS_OPT = hello world

foo:
	@[ "$1" = "hello world" ]
