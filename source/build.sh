#!/bin/bash

# --------------------------------------------------------------------------------------------
# @file: build.sh
# @brief: This script builds all applications and libraries in the source directory.
# @description: It compiles each module and installs the binaries and libraries to the output directory
# @usage: ./build.sh
# @note: This script is intended to be run from the source directory.
# @note: It requires a Makefile in each application and library directory.
# @note: The output directory will be created with a timestamp.
# @requires bash, make
# @author: Rohit Akurdekar
# --------------------------------------------------------------------------------------------

set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT_DIR="$ROOT_DIR/source"
BUILD_ROOT="$ROOT_DIR/build"
OUTPUT_DIR="$BUILD_ROOT/output-$(date +%Y%m%d_%H%M%S)"
BIN_DIR="$OUTPUT_DIR/usr/bin"
LIB_DIR="$OUTPUT_DIR/usr/lib"
VERSION_FILE="$OUTPUT_DIR/version.txt"


color_yellow='\033[1;33m'
color_green='\033[1;32m'
color_reset='\033[0m'

rm -rf ${BUILD_ROOT}/*

mkdir -p "$BIN_DIR" "$LIB_DIR"
rel_out="${OUTPUT_DIR#$ROOT_DIR/}"
printf "${color_yellow}Starting build: ${color_green}$rel_out${color_reset} \n"
echo "Build Timestamp: $(date)\n" > "$VERSION_FILE"

build_module() {
    local module_dir="$1"
    local type="$2"  # "bin" or "lib"
    local dest_dir="$3"

    # Relative paths (trim $ROOT_DIR/)
    local rel_module="${module_dir#$ROOT_DIR/}"
    local rel_dest="${dest_dir#$ROOT_DIR/}"

    printf "\n${color_yellow}Building====>${color_reset} $rel_module -> $rel_dest\n"

    if [ -f "$module_dir/Makefile" ]; then
        make -C "$module_dir" --no-print-directory clean
        make -C "$module_dir" --no-print-directory
        make -C "$module_dir" --no-print-directory DEST="$dest_dir" install

        local module_name
        module_name="$(basename "$module_dir")"

        local version_file="$dest_dir/version.txt"
        local version="unknown"
        [ -f "$version_file" ] && version="$(cat "$version_file")"

        printf "${type^}/${module_name}: $version\n" >> "$VERSION_FILE"
    fi
    printf "${color_yellow}Done. ${color_reset}\n"
}

# Build Libraries (go to usr/lib)
for lib in "$ROOT_DIR/Libraries"/*; do
    [ -d "$lib" ] && build_module "$lib" "lib" "$LIB_DIR"
done

# Build Applications (go to usr/bin)
for app in "$ROOT_DIR/Applications"/*; do
    [ -d "$app" ] && build_module "$app" "bin" "$BIN_DIR"
done

# Final tarball
cd "$BUILD_ROOT"
tar -czf "$BUILD_ROOT/output-$(date +%Y%m%d).tar.gz" "$(basename "$OUTPUT_DIR")"

printf "${color_yellow}Build complete. Output:${color_reset} output-$(date +%Y%m%d).tar.gz\n"

