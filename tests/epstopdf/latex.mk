PREREQUISITE += tiger.eps
CLEANFILES += tiger.eps

tiger.eps:
	$(download) tiger.eps http://mirrors.ctan.org/graphics/pstricks/base/doc/images/tiger.eps
