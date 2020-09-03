#!/bin/bash
set -eu
set -o pipefail

cd $(cd $(dirname $BASH_SOURCE); pwd)

if [ ! -x ./bats/bin/bats ]; then
  git -C .. submodule update --init tests/bats
fi

./bats/bin/bats "$@" *.bats
