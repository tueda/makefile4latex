#!/bin/bash
set -eu
set -o pipefail

# abort <message>: aborts the program with the given message.
function abort {
  echo "error: $@" 1>&2
  exit 1
}

# Require the git command.
command -v git >/dev/null || abort "git not available"

# Check if the working repository is clean.
{
  [[ $(git diff --stat) == '' ]] && [[ $(git diff --stat HEAD) == '' ]]
} || abort "working directory is dirty"

# Extract the current version.
[ -f Makefile ] || abort "Makefile not found"
version=$(grep MAKEFILE4LATEX_VERSION Makefile | head -1 | sed 's/^[^=]*=//' || :)
[[ $version != '' ]] || abort "version not found"
version=$(echo $version)

# Checks if the current version ends with "-dev".
[[ $version == *-dev ]] || abort "current version $version doesn't end with -dev"

# Determine the next version.
if [[ $# == 0 ]]; then
  next_version=${version%-dev}
else
  next_version=$1
fi

# The next version should follow the semantic versioning.
a=( ${next_version//./ } )
[[ ${#a[@]} == 3 ]] || abort "next version $next_version should be semantic"

# Get the next dev-version by incrementing the patch number.
((a[2]++)) || :
next_dev_version="${a[0]}.${a[1]}.${a[2]}-dev"

# Print the versions and confirm if they are fine.
echo "current commit      : $(git rev-parse --short HEAD)"
echo "current dev-version : $version"
echo "next version        : $next_version"
echo "next dev-version    : $next_dev_version"
read -p 'ok? (y/N): ' yn
case "$yn" in
  [yY]*)
    ;;
  *)
    echo "aborted" 1>&2
    exit 1
    ;;
esac

# Check additional files.
[ -f README.md ] || abort "README.md not found"

# Make commits and a release tag.
# NOTE: the "-i" option of sed is a GNU extension.
sed -i "s/^MAKEFILE4LATEX_VERSION *= .*$/MAKEFILE4LATEX_VERSION = $next_version/" Makefile
sed -i 's|makefile4latex/v[^/]*/Makefile|makefile4latex/v'$next_version'/Makefile|' README.md
git commit -a -m "chore(version): prepare for release $next_version"
git tag "v$next_version"
sed -i "s/^MAKEFILE4LATEX_VERSION *= .*$/MAKEFILE4LATEX_VERSION = $next_dev_version/" Makefile
git commit -a -m "chore(version): new version commit $next_dev_version"

echo done
