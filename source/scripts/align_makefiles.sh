#!/bin/bash

# --------------------------------------------------------------------------------------------
# @file   align_makefiles.sh
# @brief  Align Makefile variable assignments for better readability.
# @usage  source/scripts/align_makefiles.sh [--pre-commit|--dry-run]
# @note   This script formats Makefile variable assignments to align them for better readability.
#        It can be run as a pre-commit hook or manually.
# @options
#         --pre-commit  Only format Makefiles that are staged for commit.
#         --dry-run     Perform a dry run without making changes.
# @example
#         source/scripts/align_makefiles.sh --pre-commit
#         source/scripts/align_makefiles.sh --dry-run
# @requires git, awk, sed, grep, find
# @author  Rohit Akurdekar
# --------------------------------------------------------------------------------------------

set -e

# ────────────────
# Color Definitions
# ────────────────
COLOR_RESET="\033[0m"
COLOR_RED="\033[0;31m"
COLOR_GREEN="\033[0;32m"
COLOR_YELLOW="\033[1;33m"
COLOR_CYAN="\033[1;36m"
COLOR_BLUE="\033[0;34m"
# ────────────────

# Get Git root directory
ROOT_DIR="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Find all Makefiles under source/
find_makefiles() {
    mode="all"
    [ "$1" = "--pre-commit" ] && mode="git"
    [ "$1" = "--dry-run" ] && mode="dry"

    if [ "$mode" = "git" ]; then
        printf "${COLOR_YELLOW}Updating Makefiles from Git staged changes only...${NC}\n">&2
        git diff --cached --name-only | grep -E '(^|/)Makefile$'
    else
        printf "${COLOR_YELLOW}Scanning all Makefiles under source/...${NC}\n">&2
        find "$ROOT_DIR/source" -type f \( -iname makefile -o -iname '*.mk' \)
    fi
    echo "files found"
}

printf "${COLOR_YELLOW}[STAGE]${COLOR_GREEN} Scanning for staged Makefile changes... ${COLOR_RESET} \n"

# Find staged Makefiles
files=$(find_makefiles "$1")

# If no files found, exit early
if [ -z "$files" ]; then
    printf "${COLOR_GREEN}[INFO]${COLOR_RESET} No Makefile changes staged.\n"
    exit 0
fi

if [ -z "$files" ]; then
    printf "${COLOR_GREEN}[INFO]${COLOR_RESET} No Makefile changes staged.\n"
    exit 0
fi

for file in $files; do

    rel_out="${file#$ROOT_DIR/}"
    printf "${COLOR_YELLOW}[STAGE]${COLOR_RESET} Formatting changed lines in %s...\n" "$rel_out"

    # Get changed lines
    mapfile -t lines < <(git diff --cached -U0 -- "$file" | grep '^@@' | \
        sed -E 's/^@@ -[0-9,]+ \+([0-9]+)(,([0-9]+))? @@.*/\1 \3/' | \
        awk '{ start=$1; len=($2=="")?1:$2; for(i=0;i<len;i++) print start+i }')

    [ ${#lines[@]} -eq 0 ] && continue

    cp "$file" "$file.bak"

    awk -v changed_lines="$(IFS=,; echo "${lines[*]}")" '
    BEGIN {
        split(changed_lines, clist, ",");
        for (i in clist) changed[clist[i]] = 1;
    }

    /^[A-Z0-9_]+[ \t]*[:+]?=/ {
        if (changed[FNR]) {
            match($0, /^([A-Z0-9_]+)[ \t]*([:+]?=)[ \t]*(.*)$/, parts)
            vars[FNR] = parts[1]
            ops[FNR]  = parts[2]
            vals[FNR] = parts[3]
            lines[FNR] = 1
            if (length(parts[1]) > maxlen) maxlen = length(parts[1])
            next
        }
    }

    { orig[FNR] = $0 }

    END {
        for (i = 1; i <= FNR; ++i) {
            if (lines[i]) {
                printf "%-*s %s %s\n", maxlen, vars[i], ops[i], vals[i]
            } else {
                print orig[i]
            }
        }
    }
    ' "$file.bak" > "$file"

    rm "$file.bak"
    git add "$file"

    printf "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} %s formatted and staged.\n" "$rel_out"
done

printf "${COLOR_GREEN}[SUCCESS]${COLOR_RESET} Makefile formatting complete.\n"

# If running as a pre-commit hook, exit with success
if [ "$1" = "--pre-commit" ]; then
    printf "${COLOR_CYAN}[INFO]${COLOR_RESET} Pre-commit hook completed successfully.\n"
    exit 0
fi