#!/bin/bash

# --------------------------------------------------------------------------------------------
# @file: fix_makefile_indentation.sh
# @brief: Fix indentation in Makefiles or *.mk files to use tabs instead of spaces
# @usage: ./fix_makefile_indentation.sh <file1.mk> [file2.mk ...]
# @description: This script processes each provided Makefile or *.mk file, ensuring that indentation uses tabs for rules and commands, while preserving comments and other lines.
# @note: This script is intended to be run in a Unix-like environment with bash and awk available.
# @note: It is recommended to back up your Makefiles before running this script, as it modifies files in place.
# @author: Rohit Akurdekar
# --------------------------------------------------------------------------------------------

set -e

# Fix indentation in a specific Makefile or *.mk file
fix_makefile() {
    local file="$1"
    if [[ ! -f "$file" ]]; then
        echo "[ERROR] File not found: $file"
        return 1
    fi

    echo "[INFO] Fixing indentation in: $file"

    awk '
    BEGIN { in_rule = 0 }
    /^[^#[:space:]].*:/ {
        in_rule = 1
        print $0
        next
    }
    /^[^[:space:]]/ {
        in_rule = 0
        print $0
        next
    }
    /^[[:space:]]+[^#]/ {
        if (in_rule) {
            sub(/^[[:space:]]+/, "\t")
        }
        print $0
        next
    }
    {
        print $0
    }' "$file" > "$file.tmp" && mv "$file.tmp" "$file"
}

# Check input arguments
if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 <file1.mk> [file2.mk ...]"
    exit 1
fi

# Loop over all provided file paths
for file in "$@"; do
    fix_makefile "$file"
done

echo "[SUCCESS] Indentation fix complete for all provided files."
