#!/bin/bash
set -eu
set -o pipefail

check_dir() {
  (
    cd "$1"
    make MAKE_COLORS=always clean
    make MAKE_COLORS=always | tee make.out
  )

  if grep 'Rerun' $1/*.log | grep -v 'Package: rerunfilecheck\|rerunfilecheck.sty'; then
    echo "FAIL: documents incomplete"
    exit 1
  fi

  [ $# -le 1 ] && return

  num=$(grep halt-on-error "$1/make.out" | wc -l)
  if [ $2 -ne $num ]; then
    echo "FAIL: wrong number of running LaTeX: $2 (must be $num)" >&2
    exit 1
  fi

  rm "$1/make.out"
}

check_dir latex 5
check_dir bibtex 3
