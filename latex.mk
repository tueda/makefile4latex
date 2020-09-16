# Check if the repository is dirty.
check-dirty:
	@git status
	@[ -z "$$(git status --porcelain)" ]

# Install pre-commit hooks.
install:
	@pre-commit install
	@pre-commit install --hook-type commit-msg
