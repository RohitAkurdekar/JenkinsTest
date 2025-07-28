#!/bin/bash
set -e

ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
VERSION_VAR="VERSION"
DRY_RUN=false
PRECOMMIT=false
NEW_VERSION=""

color_yellow='\033[1;33m'
color_green='\033[1;32m'
color_reset='\033[0m'

function usage() {
  printf "Usage: $0 [--dry-run] [--pre-commit] \n"
  exit 1
}

function log_info() {
  printf "${color_yellow}[update-version]${color_reset} $1 \n"
}

function log_success() {
  printf "${color_green}[updated]${color_reset} $1 \n"
}

function find_makefiles() {
  find "$ROOT_DIR" -type f -name "Makefile" ! -path "*/.build_native/*"
}

function get_current_version() {
  grep -oP "$VERSION_VAR\s*:=\s*\K[0-9.]+" "$1"
}

# Usage: bump_version "1.0.0"  -> prints "1.0.1"
function bump_version() {
  local old="$1"
  local major minor patch

  IFS='.' read -r major minor patch <<< "$old"

  if [[ -z "$major" || -z "$minor" || -z "$patch" ]]; then
    echo "Invalid version format. Use MAJOR.MINOR.PATCH" >&2
    return 1
  fi

  patch=$((patch + 1))
  echo "${major}.${minor}.${patch}"
}

function update_versions() {
  for file in $(find_makefiles); do
    current=$(get_current_version "$file" || echo "0.0")
    new_version=$(bump_version "$current")
    sed -i "s/\($VERSION_VAR\s*:=\s*\).*/\1$new_version/" "$file"
    log_success "${file#$ROOT_DIR/}: $current → $new_version"
    if $PRECOMMIT; then
      git add "$file"
    fi
  done
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --pre-commit) PRECOMMIT=true ;;
    *) usage ;;
  esac
  shift
done

if $DRY_RUN; then
  for file in $(find_makefiles); do
    cur=$(get_current_version "$file")
    new=$(bump_version "$cur")
    printf "${file#$ROOT_DIR/}: $cur → $new \n"
  done
else
  update_versions
fi
