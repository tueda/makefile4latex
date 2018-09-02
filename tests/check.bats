MAKE_ARGS=

test_dir() {(
  set -eu
  set -o pipefail

  (
    cd "$1"
    make clean
    make $MAKE_ARGS | tee make.out
  )

  if grep 'Rerun' $1/*.log | grep -v 'Package: rerunfilecheck\|rerunfilecheck.sty'; then
    echo "FAIL: documents incomplete"
    exit 1
  fi

  [ $# -le 1 ] && return

  num=$(grep halt-on-error "$1/make.out" | wc -l)
  if [ $2 -ne $num ]; then
    echo "FAIL: wrong number of running LaTeX: $num (must be $2)" >&2
    exit 1
  fi

  rm "$1/make.out"
)}

@test "latex" {
  test_dir latex 5
}

@test "bibtex" {
  test_dir bibtex 3
}

@test "makeindex" {
  test_dir makeindex 2
}

@test "makeglossaries" {
  test_dir makeglossaries 2
}

@test "axohelp" {
  test_dir axohelp 2
}

@test "platex_dvipdfmx" {
  test_dir platex_dvipdfmx 1
}

@test "latexdiff" {
  MAKE_ARGS='DIFF=HEAD' test_dir latexdiff 3
}
