PREREQUISITE += tiger.eps
CLEANFILES += tiger.eps

tiger.eps:
	$(download) tiger.eps https://raw.githubusercontent.com/ArtifexSoftware/ghostpdl/master/examples/tiger.eps
