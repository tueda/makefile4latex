#!/bin/bash
#
# Make a release tag.
#
# Usage:
#   make-release.sh
#   make-release.sh NEW-VERSION
#   make-release.sh NEW-VERSION NEW-DEV-VERSION

set -euo pipefail

# Trap ERR to print the stack trace when a command fails.
# See: https://gist.github.com/ahendrix/7030300
function _errexit() {
  local err=$?
  set +o xtrace
  local code="${1:-1}"
  echo "Error in ${BASH_SOURCE[1]}:${BASH_LINENO[0]}: '${BASH_COMMAND}' exited with status $err" >&2
  # Print out the stack trace described by $FUNCNAME
  if [ ${#FUNCNAME[@]} -gt 2 ]; then
    echo 'Traceback:' >&2
    for ((i=1;i<${#FUNCNAME[@]}-1;i++)); do
      echo "  [$i]: at ${BASH_SOURCE[$i+1]}:${BASH_LINENO[$i]} in function ${FUNCNAME[$i]}" >&2
    done
  fi
  echo "Exiting with status ${code}" >&2
  exit "${code}"
}
trap '_errexit' ERR
set -o errtrace

##

# Tag prefix.
v='v'

# pre_version_message <current_version_number> <version_number> <dev_version_number>:
# a hook function to print some message before bumping the version number.
function pre_version_message() {
  echo 'Please make sure that CHANGELOG.md is up-to-date.'
  echo 'You can use the output of the following command:'
  echo
  echo "  git-chglog --next-tag $v$2"
  echo
}

# get_current_version: prints the current version.
function get_current_version() {
  # Extract the current version number from the Makefile.
  local main_file
  main_file=Makefile
  [[ -f $main_file ]] || abort "$main_file not found"
  grep MAKEFILE4LATEX_VERSION $main_file | head -1 | sed 's/.*= *//' || :
}

# get_next_version <current_version_number>: prints the next version.
function get_next_version() {
  # Remove the "-dev" suffix from the current version number.
  [[ $1 == *-dev ]] || abort "current version doesn't end with -dev: $1"
  echo "${1%-dev}"
}

# get_next_dev_version <current_version_number> <next_version_number>: prints the next dev-version.
function get_next_dev_version() {
  # Increase the patch number and add the "-dev" suffix.
  local next_version_xyz a
  next_version_xyz=${1%-*}  # remove any suffix
  IFS=. read -r -a a <<<"$next_version_xyz"
  [[ ${#a[@]} == 3 ]] || abort "next version should be semantic: $next_version"
  ((a[2]++)) || :
  echo "${a[0]}.${a[1]}.${a[2]}-dev"
}

# version_bump <version_number>: a hook function to bump the version for documents.
function version_bump() {
  dev_version_bump "$1"
  sed -i 's|makefile4latex/v[^/]*/Makefile|makefile4latex/v'"$next_version"'/Makefile|' README.md
  # Check if the files are changed.
  [[ $(numstat Makefile) == '1,1' ]]
  [[ $(numstat README.md) == '2,2' ]]
}

# dev_version_bump <dev_version_number>: a hook function to bump the version for code.
function dev_version_bump() {
  sed -i "s/^MAKEFILE4LATEX_VERSION *= .*$/MAKEFILE4LATEX_VERSION = $1/" Makefile
  # Check if the file is changed.
  [[ $(numstat Makefile) == '1,1' ]]
}

##

# abort <message>: aborts the program with the given message.
function abort {
  echo "error: $*" 1>&2
  exit 1
}

# isclean: checks if the working repository is clean (untracked files are ignored).
function isclean() {
  [[ $(git diff --stat) == '' ]] && [[ $(git diff --stat HEAD) == '' ]]
}

# numstat <file>: prints number of added and deleted lines for the file (e.g., "0,0").
function numstat() {
  local stat
  stat=$(git diff --numstat "$1")
  if [[ $stat =~ ([0-9]+)[[:blank:]]+([0-9]+) ]]; then
    echo "${BASH_REMATCH[1]},${BASH_REMATCH[2]}"
  else
    echo 0,0
  fi
}

# Require the git command.
command -v git >/dev/null || abort 'git not available'

# Stop if the working directory is dirty.
isclean || abort 'working directory is dirty'

# Ensure that we are in the project root.
cd "$(git rev-parse --show-toplevel)"

# Determine the current version.
current_version=$(get_current_version)
[[ $current_version != '' ]] || abort 'current version not determined'

# Determine the next version.
if [[ $# == 0 ]]; then
  next_version=$(get_next_version "$current_version")
  [[ $next_version != '' ]] || abort 'next version not determined'
else
  next_version=$1
fi

# Determine the next dev-version.
if [[ $# -lt 2 ]]; then
  next_dev_version=$(get_next_dev_version "$current_version" "$next_version")
  [[ $next_dev_version != '' ]] || abort 'next dev-version not determined'
else
  next_dev_version=$2
fi

# Print the versions and confirm if they are fine.
pre_version_message "$current_version" "$next_version" "$next_dev_version"
echo 'This script will bump the version number.'
echo "  current commit      : $(git rev-parse --short HEAD)"
echo "  current version     : $current_version"
echo "  next version        : $next_version"
echo "  next dev-version    : $next_dev_version"
while :; do
  read -r -p 'ok? (y/N): ' yn
  case "$yn" in
    [yY]*)
      break
      ;;
    [nN]*)
      echo 'Aborted' >&2
      exit 1
      ;;
    *)
      ;;
  esac
done

# Bump the version.
version_bump "$next_version"
git commit -a -m "chore(release): bump version to $next_version"
git tag "$v$next_version"
dev_version_bump "$next_dev_version"
git commit -a -m "chore: bump version to $next_dev_version"

# Completed. Show some information.
echo "A release tag $v$next_version was successfully created."
echo "The current development version is now $next_dev_version"
echo "To push it to the origin:"
echo "  git push origin $v$next_version"
