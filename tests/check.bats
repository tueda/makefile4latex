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

  if grep 'Rerun' $1/*.log | grep -v 'Package: rerunfilecheck\|rerunfilecheck.sty'; then
    echo "FAIL: documents incomplete" >&2
    exit 1
  fi

  [ $# -le 1 ] && exit

  num=$(grep halt-on-error "$1/make.out" | wc -l)
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

@test "latex" {
  test_dir latex 5
}

@test "bibtex" {
  WITH_LONG_NAME=doc.tex test_dir bibtex 6
}

@test "makeindex" {
  WITH_LONG_NAME=doc.tex test_dir makeindex 4
}

@test "makeglossaries" {
  WITH_LONG_NAME=doc.tex test_dir makeglossaries 4
}

@test "axohelp" {
  if command -v axohelp >/dev/null; then :; else
    skip "axohelp not available"
  fi
  WITH_LONG_NAME=doc.tex test_dir axohelp 4
}

@test "sortref" {
  if command -v sortref >/dev/null; then :; else
    skip "sortref not available"
  fi
  test_dir sortref 3
}

@test "tikz-external" {
  test_dir tikz-external 1
}

@test "platex_dvips" {
  if command -v platex >/dev/null; then :; else
    skip "platex not available"
  fi
  if command -v dvips >/dev/null; then :; else
    skip "dvips not available"
  fi
  if command -v convbkmk >/dev/null; then :; else
    skip "convbkmk not available"
  fi
  if command -v ps2pdf >/dev/null; then :; else
    skip "ps2pdf not available"
  fi
  test_dir platex_dvips 2
}

@test "platex_dvipdfmx" {
  if command -v platex >/dev/null; then :; else
    skip "platex not available"
  fi
  if command -v dvipdfmx >/dev/null; then :; else
    skip "dvipdfmx not available"
  fi
  test_dir platex_dvipdfmx 1
}

@test "dist" {
  MAKE_ARGS='dist' test_dir bibtex
  check_tarball bibtex/doc.tar.gz 2
  MAKE_ARGS='dist' test_dir makeindex
  check_tarball makeindex/doc.tar.gz 2
  MAKE_ARGS='dist' test_dir makeglossaries
  check_tarball makeglossaries/doc.tar.gz 3
}

@test "latexdiff1" {
  if command -v latexdiff >/dev/null; then :; else
    skip "latexdiff not available"
  fi
  if command -v latexpand >/dev/null; then :; else
    skip "latexpand not available"
  fi
  MAKE_ARGS='DIFF=HEAD' test_dir latexdiff 3
}

@test "latexdiff2" {
  if command -v latexdiff >/dev/null; then :; else
    skip "latexdiff not available"
  fi
  if command -v latexpand >/dev/null; then :; else
    skip "latexpand not available"
  fi
  MAKE_ARGS='DIFF=HEAD' test_dir latexdiff 3
  MAKE_ARGS='DIFF=44aaae0' NO_CLEAN=1 test_dir latexdiff 2
  MAKE_ARGS='DIFF=44aaae0..HEAD' NO_CLEAN=1 test_dir latexdiff 1
}

@test "get" {
  MAKEFILE4LATEX_CACHE=_cache test_dir get 5
}

teardown() {
  find . -name make.out -exec rm {} \;
  find . -name '*-very-long-*' -exec rm {} \;
}
