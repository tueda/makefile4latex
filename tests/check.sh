#!/bin/sh
set -eu
if [ ! -x ./bats/bin/bats ]; then
  git -C .. submodule update --init tests/bats
fi
./bats/bin/bats "$@" *.bats
