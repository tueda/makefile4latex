# @file Makefile (get/Makefile)
#
# Makefile for typesetting LaTeX documents. Requires GNU Make 3.81 on Linux.
# See "make help". Actually, this file downloads the main Makefile into the
# cache and then includes it.
#
# This file is provided under the MIT License:
#
# MIT License
#
# Copyright (c) 2020 Takahiro Ueda
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# $(call _read_config,VARIABLE) reads the specified variable from the user
# configuration. The variable should be defined in the following places
# (in descending precedence):
#   (1) command line (e.g., make XX=YY),
#   (2) configuration files:
#     (a) latex.mk
#     (b) .latex.mk
#     (c) $(REAL_MAKEFILEDIR)/latex.mk
#     (d) $(REAL_MAKEFILEDIR)/.latex.mk
#     (e) ~/latex.mk
#     (f) ~/.latex.mk
#     where $(REAL_MAKEFILEDIR) is the directory that containing the "realpath"
#     of the current Makefile (which may be different from the current
#     directory).
#   (3) environment variable.
#
# First, this macro checks if the variable is already defined by "command line".
# If not, then the macro tries to extract lines that matches with "$1 = ..." in
# configuration files and then evaluate the last one. The extraction should work
# unless the user writes tricky stuff (for example, continuation lines).
_read_config = \
	$(eval $(strip \
		$(if $(findstring command,$(origin $1)),, \
			$(if $(_conf_file_list), \
				$(shell grep '^ *$1 *=' $(_conf_file_list) \
					| sed 's/^.*://' | tail -n 1) \
			) \
		) \
	))

_real_makefile_dir := \
	$(dir $(realpath $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))))

_conf_file_list := \
	$(wildcard \
		~/.latex.mk ~/latex.mk \
		$(_real_makefile_dir)/.latex.mk $(_real_makefile_dir)/latex.mk \
		.latex.mk latex.mk)

# The MAKEFILE4LATEX_REVISION variable controls the revision of Makefile for
# LaTeX to be downloaded.
$(call _read_config,MAKEFILE4LATEX_REVISION)
# The default value.
ifeq ($(MAKEFILE4LATEX_REVISION),)
override MAKEFILE4LATEX_REVISION = master
endif

# The MAKEFILE4LATEX_CACHE variable controls the cache location.
$(call _read_config,MAKEFILE4LATEX_CACHE)
# The default value depends on the OS.
ifeq ($(MAKEFILE4LATEX_CACHE),)
_uname_s := $(shell uname -s)
ifeq ($(_uname_s),Darwin)
override MAKEFILE4LATEX_CACHE = $(HOME)/Library/Caches/makefile4latex
else
override MAKEFILE4LATEX_CACHE = $(HOME)/.cache/makefile4latex
endif
endif

# Makefile to be included.
_Makefile_URL := https://raw.githubusercontent.com/tueda/makefile4latex/$(MAKEFILE4LATEX_REVISION)/Makefile

# The file path for the downloaded Makefile.
_cache_dir = $(MAKEFILE4LATEX_CACHE)/$(MAKEFILE4LATEX_REVISION)
_cached_Makefile := $(_cache_dir)/Makefile

include $(_cached_Makefile)

$(_cached_Makefile):
	@mkdir -p "$(_cache_dir)"
	@if command -v wget >/dev/null; then \
		wget -O "$(_cached_Makefile).$$PPID.tmp" "$(_Makefile_URL)" \
		&& mv "$(_cached_Makefile).$$PPID.tmp" "$(_cached_Makefile)"; \
	elif command -v curl >/dev/null; then \
		curl -L -o "$(_cached_Makefile).$$PPID.tmp" "$(_Makefile_URL)" \
		&& mv "$(_cached_Makefile).$$PPID.tmp" "$(_cached_Makefile)"; \
	else \
		echo 'error: wget or curl required to download makefile4latex' >&2; \
		exit 1; \
	fi

_show_cache_info:
	@echo "MAKEFILE4LATEX_REVISION = $(MAKEFILE4LATEX_REVISION)"
	@echo "MAKEFILE4LATEX_CACHE    = $(MAKEFILE4LATEX_CACHE)"
	@echo "        downloaded from : $(_Makefile_URL)"
	@echo "              cached to : $(_cached_Makefile)"

# latest-raw-url: https://raw.githubusercontent.com/tueda/makefile4latex/master/get/Makefile
