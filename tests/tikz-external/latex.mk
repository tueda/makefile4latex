LATEX_OPT += -shell-escape

PREREQUISITE += tikzcache

MOSTLYCLEANDIRS += tikzcache

tikzcache:
	@mkdir -p tikzcache
	@$(if $(BUILDDIR),mkdir -p $(BUILDDIR)/tikzcache)
