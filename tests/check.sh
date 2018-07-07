#!/bin/bash
set -eu
set -o pipefail

check_dir() {
  (
    cd "$1"
    make clean
    make | tee make.out
  )

  [ $# -le 1 ] && return

  if grep 'Rerun' $1/*.log | grep -v 'Package: rerunfilecheck\|rerunfilecheck.sty'; then
    echo "FAIL: documents incomplete"
    exit 1;
  fi

  num=$(grep halt-on-error "$1/make.out" | wc -l)
  if [ $2 -ne $num ]; then
    echo "FAIL: wrong number of running LaTeX: $2 (must be $num)" >&2
    exit 1
  fi
}

check_dir basic_latex 5
