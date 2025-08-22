#!/bin/bash
set -euo pipefail

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
template_dir="$script_dir/gitignore"
root_dir=$(dirname "$script_dir")

cd "$root_dir"

temp_dir=$(mktemp -d './tmp.XXXXXX')
temp_dir=$(cd "$temp_dir" && pwd)
trap 'rm -rf "$temp_dir"' EXIT

cd "$temp_dir"

git clone https://github.com/github/gitignore.git

repo_dir=$(cd gitignore && pwd)

if ! git -C "$repo_dir" apply --verbose "$template_dir/TeX.gitignore.patch"; then
  echo "Falling back to 3-way merge..." >&2
  git -C "$repo_dir" apply --3way --verbose "$template_dir/TeX.gitignore.patch"
fi

cd "$temp_dir"

year=$(date +%Y)
commit_hash=$(git -C "$repo_dir" log -1 --format='%H' -- TeX.gitignore)
commit_date=$(git -C "$repo_dir" log -1 --format='%cd' --date=short -- TeX.gitignore)
tex_gitignore=$(cat "$repo_dir/TeX.gitignore")

export year
export commit_hash
export commit_date
export tex_gitignore

# shellcheck disable=SC2016
envsubst '$year $commit_hash $commit_date $tex_gitignore' <"$template_dir/gitignore.template" >temp_file

if ! diff -q temp_file "$root_dir/.gitignore" >/dev/null; then
  mv temp_file "$root_dir/.gitignore"
  echo ".gitignore has been updated." >&2
else
  echo ".gitignore is already up-to-date." >&2
fi
