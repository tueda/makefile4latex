# Check if the repository is dirty.
check-dirty:
	@git status
	@[ -z "$$(git status --porcelain)" ]

# Install pre-commit hooks.
install:
	@pre-commit install
	@pre-commit install --hook-type commit-msg

# For CI.
ci-test:
	MAKE_COLORS=always MAKEFLAGS='' ./tests/check.sh -T
	$(MAKE) check-dirty

ci-test-builddir:
	MAKE_COLORS=always MAKEFLAGS='BUILDDIR=.build' ./tests/check.sh -T
	$(MAKE) check-dirty

ci-test-dev:
	MAKE_COLORS=always MAKEFLAGS='DEV=1' ./tests/check.sh -T
	$(MAKE) check-dirty

ci-test-dev-builddir:
	MAKE_COLORS=always MAKEFLAGS='DEV=1 BUILDDIR=.build' ./tests/check.sh -T
	$(MAKE) check-dirty
