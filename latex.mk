check-dirty:
	@git status
	@[ -z "$$(git status --porcelain)" ]
