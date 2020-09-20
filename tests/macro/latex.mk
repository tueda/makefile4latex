tests = $(shell $(MAKE) -pq _FORCE | sed -n '/^test_/p' | sed 's/:.*//')

all-test:
	@for test in $(tests); do \
		echo "Testing $$test..."; \
		$(MAKE) --silent clean; \
		$(MAKE) --always-make --no-print-directory $$test || exit 1; \
	done

test_is_texlive:
	$(if $(is_texlive),:,false)
