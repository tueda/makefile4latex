#!/bin/bash
set -euo pipefail

cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ ! -x ./bats/bin/bats ]; then
  git -C .. submodule update --init tests/bats
fi

./bats/bin/bats "$@" ./*.bats
