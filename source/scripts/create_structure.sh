#!/bin/bash

# ------------------------------------------------------------------------
# @file: create_structure.sh
# @brief: Script to create directory structure for applications, libraries
#   , third-party libraries, and microservices.
# @description: This script creates the necessary directories and Makefiles
#   for building applications, libraries, and microservices.
# @note: This script is intended to be run from the source directory.
# @note: It will create the following structure:
# source/
# ├── Applications
# ├── Libraries
# ├── ThirdPartyLibs
# ├── Microservices
# ├── CommonMakefile.mk
# ├── Build.sh
# └── README.md
# Ensure the script is run from the source directory
#
# @author: Rohit Akurdekar
# ------------------------------------------------------------------------

# Check if a parameter is provided
if [ -z "$1" ]; then
    printf "${color_yellow}Usage:${color_reset} $0 <applications|libraries|thirdparty|microservices|ALL>\n"
    exit 1
fi

# Color codes for output
color_red='\033[1;31m'
color_blue='\033[1;34m'
color_yellow='\033[1;33m'
color_green='\033[1;32m'
color_reset='\033[0m'
BOLD="\e[1m"

# Get absolute path to Git repo root
REPO_ROOT=$(git rev-parse --show-toplevel)
SOURCE_DIR="$REPO_ROOT/source"


# Add content to CommonMakefile.mk
generate_common_makefile() {
    cat > ${SOURCE_DIR}/CommonMakefile.mk <<EOL
### Root: source/CommonMakefile.mk ###
SHELL := /bin/bash
ARCH ?= native
# Common build settings
CXX := g++
CXXFLAGS += -std=c++17 -Wall -Wextra -fPIC
LDFLAGS :=

# Root Directory (one level above source)
ROOT_DIR := \$(shell git rev-parse --show-toplevel)
SOURCE_DIR := \$(ROOT_DIR)/source
LIBRARIES_DIR := \$(SOURCE_DIR)/Libraries
THIRD_PARTY_DIR := \$(SOURCE_DIR)/ThirdPartyLibs

# Output directories
BUILD_DIR := .build_\$(ARCH)
SRC_DIR := src
INC_DIR := include

# Color codes
COLOR_RED := \\033[1;31m
COLOR_GREEN := \\033[1;32m
COLOR_YELLOW := \\033[1;33m
COLOR_BLUE := \\033[1;34m
COLOR_RESET := \\033[0m

# Tools
MKDIR_P := mkdir -p
RM := rm -rf

EOL
}

escape_sed() {
    printf '%s' "$1" | sed -e 's/[&/\]/\\&/g'
}

# Update Makefile content to handle installation paths
add_makefile_content() {
    local sed_expr=""
    local tmp_makefile_path="$SOURCE_DIR/scripts/makefile.template"

    # Set default values for all known placeholders to empty string
    declare -A placeholders=( [dir_path]="" [binary_name]="" [install_path]="" [shared]="" )

    # Parse key=value pairs
    for pair in "$@"; do
        local key="${pair%%=*}"
        local value="${pair#*=}"
        if [[ -v placeholders[$key] ]]; then
            placeholders[$key]="$value"
        else
            printf "${color_red}Unknown key: ${key}${color_reset}\n"
            exit 1
        fi
    done

    # Build sed expression
    for key in "${!placeholders[@]}"; do
        if [[ $key == "dir_path" ]]; then
            rel_out="${placeholders[$key]#"$SOURCE_DIR/"}"
            sed_expr+="s|{{${key}}}|${rel_out}|g;"
        else
            sed_expr+="s|{{${key}}}|${placeholders[$key]}|g;"
        fi
    done

    # Use dir_path from placeholders array
    local file_path="${placeholders[dir_path]}/Makefile"
    cp "$tmp_makefile_path" "$file_path" || exit 1
    sed -i "$sed_expr" "$file_path"
    ${SOURCE_DIR}/scripts/fix_makefile_indentation.sh "$file_path"
}

# Create the main source directories if they don't exist ""
create_applications() {
    read -p $"Enter the ${BOLD}number${color_reset} of application directories: " app_count
    for ((i = 1; i <= app_count; i++)); do
        read -p $"Enter ${BOLD}name${color_reset} for application directory $i: " app_name
        local app_path="${SOURCE_DIR}/Applications/$app_name"
        mkdir -p "$app_path/src/apis"
        mkdir -p "$app_path/include"
        mkdir -p "$app_path/.build/output"
        touch "$app_path/README.md"
        add_makefile_content dir_path="$app_path" binary_name="$app_name" install_path="usr/bin"
    done
}

# Create library directories
create_libraries() {
    read -p $"Enter the ${BOLD}number${color_reset} of library directories: " lib_count
    for ((i = 1; i <= lib_count; i++)); do
        read -p $"Enter ${BOLD}name${color_reset} for library directory $i: " lib_name
        local lib_path="${SOURCE_DIR}/Libraries/lib$lib_name"
        mkdir -p "$lib_path/src"
        mkdir -p "$lib_path/include"
        mkdir -p "$lib_path/.build/output"
        touch "$lib_path/README.md"
        add_makefile_content dir_path="$lib_path" binary_name="lib$lib_name.so" install_path="usr/lib" shared="-shared"
    done
}

# Create third-party library directories
create_thirdparty() {
    read -p $"Enter the ${BOLD}number${color_reset} of third-party directories: " tp_count
    for ((i = 1; i <= tp_count; i++)); do
        read -p $"Enter ${BOLD}name${color_reset} for third-party directory $i: " tp_name
        local tp_path="${SOURCE_DIR}/ThirdPartyLibs/$tp_name"
        mkdir -p "$tp_path/src"
        mkdir -p "$tp_path/includes"
        mkdir -p "$tp_path/libs"
        touch "$tp_path/README.md"
    done
}

# Create microservices and extension modules directories
create_microservices() {
    read -p $"Enter the ${BOLD}number${color_reset} of plugin directories: " plugin_count
    for ((i = 1; i <= plugin_count; i++)); do
        read -p $"Enter ${BOLD}name${color_reset} for plugin directory $i: " plugin_name
        local plugin_path="${SOURCE_DIR}/Microservices/plugins/$plugin_name"
        mkdir -p "$plugin_path/src"
        mkdir -p "$plugin_path/include"
        mkdir -p "$plugin_path/.build"
        touch "$plugin_path/README.md"
        add_makefile_content dir_path="$plugin_path" binary_name="$plugin_name.so" install_path="usr/lib/$plugin_name"
    done

    read -p $"Enter the ${BOLD}number${color_reset} of extension module directories: " extmod_count
    for ((i = 1; i <= extmod_count; i++)); do
        read -p $"Enter ${BOLD}name${color_reset} for extension module directory $i: " mod_name
        local mod_path="${SOURCE_DIR}/Microservices/extModule/mod-$mod_name-akext"
        mkdir -p "$mod_path/src"
        mkdir -p "$mod_path/include"
        mkdir -p "$mod_path/.build"
        touch "$mod_path/README.md"
        add_makefile_content dir_path="$mod_path" binary_name="mod-$mod_name-akext.so" install_path="usr/lib/mod-$mod_name-akext"
    done
}

# Function to generate the Build.sh script
generate_build_script() {
    cat > ${SOURCE_DIR}/build.sh <<EOL
    #!/bin/bash
    ### Build.sh for source directory ###
    # This script builds all applications and libraries in the source directory
    # It compiles each module and installs the binaries and libraries to the output directory

    set -e

    ROOT_DIR="\$(cd "\$(dirname "\${BASH_SOURCE[0]}")/.." && pwd)"
    ROOT_DIR="\$ROOT_DIR/source"
    BUILD_ROOT="\$ROOT_DIR/build"
    OUTPUT_DIR="\$BUILD_ROOT/output-\$(date +%Y%m%d_%H%M%S)"
    BIN_DIR="\$OUTPUT_DIR/usr/bin"
    LIB_DIR="\$OUTPUT_DIR/usr/lib"
    VERSION_FILE="\$OUTPUT_DIR/version.txt"


    color_yellow='\033[1;33m'
    color_green='\033[1;32m'
    color_reset='\033[0m'

    rm -rf \${BUILD_ROOT}/*

    mkdir -p "\$BIN_DIR" "\$LIB_DIR"
    rel_out="\${OUTPUT_DIR#\$ROOT_DIR/}"
    printf "\${color_yellow}Starting build: \${color_green}\$rel_out\${color_reset} \n"
    echo "Build Timestamp: \$(date)\n" > "\$VERSION_FILE"

    build_module() {
        local module_dir="\$1"
        local type="\$2"  # "bin" or "lib"
        local dest_dir="\$3"

        # Relative paths (trim \$ROOT_DIR/)
        local rel_module="\${module_dir#\$ROOT_DIR/}"
        local rel_dest="\${dest_dir#\$ROOT_DIR/}"

        printf "\n\${color_yellow}Building====>\${color_reset} \$rel_module -> \$rel_dest\n"

        if [ -f "\$module_dir/Makefile" ]; then
            make -C "\$module_dir" --no-print-directory clean
            make -C "\$module_dir" --no-print-directory
            make -C "\$module_dir" --no-print-directory DEST="\$dest_dir" install

            local module_name
            module_name="\$(basename "\$module_dir")"

            local version_file="\$dest_dir/version.txt"
            local version="unknown"
            [ -f "\$version_file" ] && version="\$(cat "\$version_file")"

            printf "\${type^}/\${module_name}: \$version\n" >> "\$VERSION_FILE"
        fi
        printf "\${color_yellow}Done. \${color_reset}\n"
    }

    # Build Libraries (go to usr/lib)
    for lib in "\$ROOT_DIR/Libraries"/*; do
        [ -d "\$lib" ] && build_module "\$lib" "lib" "\$LIB_DIR"
    done

    # Build Applications (go to usr/bin)
    for app in "\$ROOT_DIR/Applications"/*; do
        [ -d "\$app" ] && build_module "\$app" "bin" "\$BIN_DIR"
    done

    # Final tarball
    cd "\$BUILD_ROOT"
    tar -cvzf "\$BUILD_ROOT/output-\$(date +%Y%m%d).tar.gz" "\$(basename "\$OUTPUT_DIR")"

    printf "\${color_yellow}Build complete. Output:\${color_reset} output-\$(date +%Y%m%d).tar.gz\n"

EOL
    chmod +x ${SOURCE_DIR}/build.sh
}

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
    mkdir -p ${SOURCE_DIR}/
fi

case "$1" in
    applications)
        create_applications
        ;;
    libraries)
        create_libraries
        ;;
    thirdparty)
        create_thirdparty
        ;;
    microservices)
        create_microservices
        ;;
    ALL)
        printf "Creating all directory types..."
        create_applications
        create_libraries
        create_thirdparty
        create_microservices
        ;;
    *)
        printf "${color_red}Invalid option. ${color_reset}\n"
        printf "${color_yellow}Usage:${color_reset} $0 <applications|libraries|thirdparty|microservices|ALL>\n"
        exit 1
        ;;
esac

# Generate Build.sh script
if [ -f "${SOURCE_DIR}/build.sh" ]; then
    printf "${color_yellow}build.sh already exists. Skipping generation.${color_reset}\n"
else
    printf "${color_blue}Generating build.sh...${color_reset}\n"
    generate_build_script
fi


# Generate CommonMakefile.mk
if [ -f "${SOURCE_DIR}/CommonMakefile.mk" ]; then
    printf "${color_yellow}Common Makefile already exists. Skipping generation.${color_reset}\n"
else
    printf "${color_blue}Generating CommonMakefile.mk ...${color_reset}\n"
    generate_common_makefile
fi

# README.md
touch README.md
