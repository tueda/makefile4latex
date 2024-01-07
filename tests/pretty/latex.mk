TESTS = test-latexindent
CLEANFILES += doc.tex

test-latexindent:
	cp doc.tex.in doc.tex
	$(MAKE) pretty
	diff doc.tex doc.tex.out
