MAKE_ARGS=
NO_CLEAN=
WITH_LONG_NAME=

# test_dir <directory>
# test_dir <directory> <number of runs>
test_dir() {(
  set -eu
  set -o pipefail

  (
    cd "$1"
    if [ -n "$WITH_LONG_NAME" ]; then
      longsuffix=-very-long-abcd-efgh-ijkl-mnop-qrst-uvwx-yzab-cdef-ghij-klmn-opqr-stuv-wxyz-1234-5678-9012-3456-7890
      longname=${WITH_LONG_NAME%.*}$longsuffix.${WITH_LONG_NAME##*.}
      if [ ! -f "$longname" ]; then
        ln -s "$WITH_LONG_NAME" "$longname"
      fi
    fi
    [ -n "$NO_CLEAN" ] || make clean
    make $MAKE_ARGS | tee make.out
  )

  if grep 'Rerun\|Please rerun LaTeX' $1/*.log $1/*/*.log $1/.build/*.log | grep -v 'Package: rerunfilecheck\|rerunfilecheck.sty'; then
    echo "FAIL: documents incomplete" >&2
    exit 1
  fi

  [ $# -le 1 ] && exit

  if grep -q halt-on-error "$1/make.out"; then
    num=$(grep halt-on-error "$1/make.out" | wc -l)
  else
    num=0
  fi
  if [ $2 -ne $num ]; then
    echo "FAIL: wrong number of running LaTeX: $num (must be $2)" >&2
    exit 1
  fi

  rm "$1/make.out"
)}

# check_tarball <file> <number of files>
check_tarball() {(
  set -eu
  set -o pipefail

  num=$(tar tf "$1" | wc -l)
  if [ $2 -ne $num ]; then
    echo "FAIL: wrong number of files in archive $1: $num (must be $2)" >&2
    exit 1
  fi
)}

# require_executable <file>
require_executable() {
  if command -v $1 >/dev/null; then :; else
    skip "$1 not available"
  fi
}

# require_package <file>
require_package() {
  require_executable kpsewhich
  if kpsewhich $1 >/dev/null; then :; else
    skip "$1 not available"
  fi
}

@test "latex" {
  test_dir latex 5
}

@test "bibtex" {
  WITH_LONG_NAME=doc.tex test_dir bibtex 6
  touch bibtex/ref.bib
  NO_CLEAN=1 test_dir bibtex 0
  NO_CLEAN=1 test_dir bibtex 0
}

@test "biblatex" {
  if command -v biber >/dev/null; then :; else
    skip "biber not available"
  fi
  if command -v kpsewhich >/dev/null; then :; else
    skip "kpsewhich not available"
  fi
  if kpsewhich biblatex.sty >/dev/null; then :; else
    skip "biblatex.sty not available"
  fi
  WITH_LONG_NAME=doc1.tex test_dir biblatex 15
}

@test "makeindex" {
  WITH_LONG_NAME=doc.tex test_dir makeindex 4
}

@test "makeglossaries" {
  WITH_LONG_NAME=doc.tex test_dir makeglossaries 4
}

@test "bib2gls" {
  require_package glossaries-extra.sty
  require_executable bib2gls
  WITH_LONG_NAME=doc.tex test_dir bib2gls 4
}

@test "axohelp" {
  require_package axodraw2.sty
  require_executable axohelp
  WITH_LONG_NAME=doc.tex test_dir axohelp 4
}

@test "sortref" {
  require_executable sortref
  test_dir sortref 3
}

@test "revtex4-1" {
  require_package revtex4-1.cls
  test_dir revtex4-1 3
}

@test "tikz-external" {
  require_package tikz.sty
  test_dir tikz-external 1
}

@test "lualatex" {
  require_executable lualatex
  test_dir lualatex 1
}

@test "platex_dvips" {
  require_executable platex
  require_executable dvips
  require_executable convbkmk
  require_executable ps2pdf
  test_dir platex_dvips 2
}

@test "platex_dvipdfmx" {
  require_executable platex
  require_executable dvipdfmx
  test_dir platex_dvipdfmx 1
}

@test "epstopdf" {
  require_executable epstopdf
  test_dir epstopdf 1
}

@test "dist" {
  MAKE_ARGS='dist' test_dir bibtex
  check_tarball bibtex/doc.tar.gz 2
  MAKE_ARGS='dist' test_dir makeindex
  check_tarball makeindex/doc.tar.gz 2
  MAKE_ARGS='dist' test_dir makeglossaries
  check_tarball makeglossaries/doc.tar.gz 3
}

@test "dist_biblatex" {
  if command -v biber >/dev/null; then :; else
    skip "biber not available"
  fi
  if command -v kpsewhich >/dev/null; then :; else
    skip "kpsewhich not available"
  fi
  if kpsewhich biblatex.sty >/dev/null; then :; else
    skip "biblatex.sty not available"
  fi
  MAKE_ARGS='dist' test_dir biblatex
  check_tarball biblatex/doc1.tar.gz 2
  check_tarball biblatex/doc2.tar.gz 2
  check_tarball biblatex/doc3.tar.gz 2
  check_tarball biblatex/doc4.tar.gz 4
}

@test "latexdiff1" {
  require_executable latexdiff
  require_executable latexpand
  MAKE_ARGS='DIFF=HEAD' test_dir latexdiff 3
}

@test "latexdiff2" {
  require_executable latexdiff
  require_executable latexpand
  MAKE_ARGS='DIFF=HEAD' test_dir latexdiff 3
  MAKE_ARGS='DIFF=44aaae0' NO_CLEAN=1 test_dir latexdiff 2
  MAKE_ARGS='DIFF=44aaae0..HEAD' NO_CLEAN=1 test_dir latexdiff 1
}

@test "macro" {
  make -C macro check
}

@test "check" {
  make -C check/tests_opt check
  make -C check/tests_opt_params check
  make -C check/variable_opt check
}

@test "pretty" {
  require_executable diff
  require_executable latexindent
  make -C pretty check
}

@test "get" {
  MAKEFILE4LATEX_CACHE=_cache test_dir get 5
}

teardown() {
  find . -name make.out -exec rm {} \;
  find . -name '*-very-long-*' -exec rm {} \;
}
