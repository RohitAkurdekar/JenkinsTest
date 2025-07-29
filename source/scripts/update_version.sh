#!/bin/sh

# Color definitions
RED='\033[0;31m'
GRN='\033[0;32m'
YEL='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get Git root
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
SOURCE_DIR="$REPO_ROOT/source"

# Find all Makefiles under source/
find_makefiles() {
    find "$ROOT_DIR/source" -type f -name Makefile
}

# Extract version from version.txt near Makefile
get_version() {
    cat $1 | grep -E '^[[:space:]]*VERSION[[:space:]]*:?=' | sed -E 's/^[[:space:]]*VERSION[[:space:]]*:?=[[:space:]]*//'
}

# Update version in Makefile
update_makefile() {
    local makefile="$1"
    local version="$2"
    if [ -z "$version" ]; then return; fi

    # Replace VERSION := ... line
    sed -i "s/^VERSION := .*/VERSION := $version/" "$makefile"
}

# Dry-run print
dry_run_info() {
    local makefile="$1"
    local version="$2"
    if [ -z "$version" ]; then return; fi
    rel_out="${makefile#$ROOT_DIR/}"
    printf "${YEL}[DRY RUN]${NC} Would update %s to version ${GRN}%s${NC}\n" "$rel_out" "$version"
}

# Main function
main() {
    mode="all"

    [ "$1" = "--pre-commit" ] && mode="git"
    [ "$1" = "--dry-run" ] && mode="dry"

    if [ "$mode" = "git" ]; then
        printf "${YEL}Updating Makefiles from Git staged changes only...${NC}\n"
        files=$(git diff --cached --name-only | grep -E '(^|/)Makefile$')
    else
        printf "${YEL}Scanning all Makefiles under source/...${NC}\n"
        files=$(find_makefiles)
    fi

    for makefile in $files; do
        version=$(get_version "$makefile")

        if [ -z "$version" ]; then
            printf "${RED}Skipping: No version found for ${makefile}${NC}\n"
            continue
        fi

        if [ "$mode" = "dry" ]; then
            dry_run_info "$makefile" "$version"
        else
            rel_out="${makefile#$ROOT_DIR/}"
            printf "${GRN}Updating ${rel_out} -> VERSION := ${version}${NC}\n"
            update_makefile "$makefile" "$version"
        fi
    done
}

main "$@"
