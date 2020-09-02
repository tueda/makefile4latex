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

# The MAKEFILE4LATEX_REVISION variable controls the revision of Makefile for
# LaTeX to be downloaded. It can be set in the following places (in descending
# precedence):
# (1) command line,
# (2) configuration files: latex.mk, .latex.mk, ~/latex.mk, ~/.latex.mk,
# (3) environment variable,
# (4) the default value: "master".
ifneq ($(origin MAKEFILE4LATEX_REVISION),command line)
ifneq ($(wildcard ~/.latex.mk ~/latex.mk .latex.mk latex.mk),)
# Extract lines "MAKEFILE4LATEX_REVISION = ..." in configuration files and then
# evaluate the last one. The extraction should work unless the user writes
# tricky stuff (for example, continuation lines).
$(eval $(shell grep '^ *MAKEFILE4LATEX_REVISION *=' $(wildcard ~/.latex.mk ~/latex.mk .latex.mk latex.mk) | sed 's/^.*://' | tail -n 1))
endif
endif
# Define the default value, if undefined.
ifeq ($(MAKEFILE4LATEX_REVISION),)
MAKEFILE4LATEX_REVISION = master
endif

# Makefile to be downloaded/included.
_Makefile_URL = https://raw.githubusercontent.com/tueda/makefile4latex/$(MAKEFILE4LATEX_REVISION)/Makefile

# The MAKEFILE4LATEX_CACHE variable controls the cache location, which can be
# set via
# (1) command line,
# (2) environment variable,
# (3) the default cache location, which depends on the OS.
ifeq ($(MAKEFILE4LATEX_CACHE),)
_uname_s := $(shell uname -s)
ifeq ($(_uname_s),Darwin)
MAKEFILE4LATEX_CACHE = $(HOME)/Library/Caches/makefile4latex
else
MAKEFILE4LATEX_CACHE = $(HOME)/.cache/makefile4latex
endif
endif

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

# latest-raw-url: https://raw.githubusercontent.com/tueda/makefile4latex/master/get/Makefile
