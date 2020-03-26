#!/bin/bash
set -eu
set -o pipefail

# Create a self-extracting Makefile.
# Usage: compress.sh [--gzip|--bzip2|--xz] <input-file> <output-file>

compress=gzip
uncompress=gunzip

for opt in "$@"; do
  case "$opt" in
    -z|--gzip|--gunzip)
      compress=gzip
      uncompress=gunzip
      shift
      ;;
    -j|--bzip2|--bunzip2)
      compress=bzip2
      uncompress=bunzip2
      shift
      ;;
    -J|--xz|--unxz)
      compress=xz
      uncompress=unxz
      shift
      ;;
    -)
      shift
      break
      ;;
    -*)
      echo "error: unrecognized option: $opt">&2
      exit 1
      ;;
  esac
done

IN=$1
OUT=$2

# Extract the "header" part of Makefile from stdin.
header() {
  sed '/^endef$/q'
}

# Extract the "rest" part of Makefile from stdin.
rest() {
  sed '1,/^endef$/d'
}

remove_comments() {
  awk '{if (sub(/\\$/,"")) printf "%s ", $0; else print $0}' \
    | sed 's/^#.*$//' \
    | sed 's/ \s\s*/ /g' \
    | sed 's/^\t\s\s*/\t/' \
    | sed '/^$/d'
}

comment_out() {
  sed 's/^/# /'
}

# Print the self-extracting shell script code.
print_self_extracting() {
  cat << END

ifeq (\$(wildcard .Makefile.core),)
\$(shell cat \$(MAKEFILE_LIST) | sed '1,/^include/d' | sed 's/^# //' | base64 -d | $uncompress >.Makefile.core)
endif
include .Makefile.core

END
}

{
  cat "$IN" | header
  print_self_extracting
  cat "$IN" | rest | remove_comments | $compress -c -9 | base64 | comment_out
} >"$OUT"
