#!/bin/bash

# Check if a parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <applications|libraries|thirdparty|microservices|ALL>"
    exit 1
fi

# Add content to CommonMakefile.mk
generate_common_makefile() {
    cat > CommonMakefile.mk <<EOL
# CommonMakefile
BUILD_MODE ?= release
ARCH ?= x86_64
BUILD_DIR = .build_\$(ARCH)

ifeq (\$(BUILD_MODE), debug)
    CFLAGS += -g -O0
else
    CFLAGS += -O2 -s
endif

INSTALL_PATH ?= \$(DEST)

all: build

build:
	@echo "Building in \$(BUILD_DIR) with mode: \$(BUILD_MODE)"
	@mkdir -p \$(BUILD_DIR)

install:
	@echo "Installing to \$(INSTALL_PATH)"
	@if [ -z "\$(INSTALL_PATH)" ]; then echo "DEST is not set"; exit 1; fi
	@mkdir -p \$(INSTALL_PATH)/usr/bin
	@mkdir -p \$(INSTALL_PATH)/usr/lib
EOL
}

# Update Makefile content to handle installation paths
add_makefile_content() {
    local dir_path=$1
    local binary_name=$2
    local install_path=$3
    cat > "$dir_path/Makefile" <<EOL
include ../../CommonMakefile.mk

TARGET ?= native
SRC_DIR := src
INCLUDE_DIR := include
BUILD_DIR := .build
OUT_DIR := output

SRCS := \$(wildcard \$(SRC_DIR)/*.cpp)
OBJS := \$(SRCS:%.cpp=\$(BUILD_DIR)/%.o)
DEPS := \$(OBJS:.o=.d)

BIN := \$(BUILD_DIR)/$binary_name

CXXFLAGS += -I\$(INCLUDE_DIR)

\$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p \$(dir \$@)
	\$(CXX) \$(CXXFLAGS) -c \$< -o \$@

all: \$(BIN)

\$(BIN): \$(OBJS)
	\$(CXX) \$^ -o \$@
	\$(STRIP) \$@

install:
	@mkdir -p \$(INSTALL_PATH)/$install_path
	cp \$(BIN) \$(INSTALL_PATH)/$install_path

clean:
	rm -rf \$(BUILD_DIR) \$(OUT_DIR)

-include \$(DEPS)
EOL
}

create_applications() {
    read -p "Enter the number of application directories: " app_count
    for ((i = 1; i <= app_count; i++)); do
        read -p "Enter name for application directory $i: " app_name
        local app_path="Applications/$app_name"
        mkdir -p "$app_path/src/apis"
        mkdir -p "$app_path/include"
        mkdir -p "$app_path/.build/output"
        touch "$app_path/README.md"
        add_makefile_content "$app_path" "$app_name" "usr/bin"
    done
}

create_libraries() {
    read -p "Enter the number of library directories: " lib_count
    for ((i = 1; i <= lib_count; i++)); do
        read -p "Enter name for library directory $i: " lib_name
        local lib_path="Libraries/lib$lib_name"
        mkdir -p "$lib_path/src"
        mkdir -p "$lib_path/include"
        mkdir -p "$lib_path/.build/output"
        touch "$lib_path/README.md"
        add_makefile_content "$lib_path" "lib$lib_name.so" "usr/lib"
    done
}

create_thirdparty() {
    read -p "Enter the number of third-party directories: " tp_count
    for ((i = 1; i <= tp_count; i++)); do
        read -p "Enter name for third-party directory $i: " tp_name
        mkdir -p ThirdPartyLibs/"$tp_name"/includes
        mkdir -p ThirdPartyLibs/"$tp_name"/libs
        touch ThirdPartyLibs/"$tp_name"/Makefile
        touch ThirdPartyLibs/"$tp_name"/README.md
    done
}

create_microservices() {
    read -p "Enter the number of plugin directories: " plugin_count
    for ((i = 1; i <= plugin_count; i++)); do
        read -p "Enter name for plugin directory $i: " plugin_name
        local plugin_path="Microservices/plugins/$plugin_name"
        mkdir -p "$plugin_path/src"
        mkdir -p "$plugin_path/include"
        mkdir -p "$plugin_path/.build"
        touch "$plugin_path/README.md"
        add_makefile_content "$plugin_path" "$plugin_name.so" "usr/lib/$plugin_name"
    done

    read -p "Enter the number of extension module directories: " extmod_count
    for ((i = 1; i <= extmod_count; i++)); do
        read -p "Enter name for extension module directory $i: " mod_name
        local mod_path="Microservices/extModule/mod-$mod_name-akext"
        mkdir -p "$mod_path/src"
        mkdir -p "$mod_path/include"
        mkdir -p "$mod_path/.build"
        touch "$mod_path/README.md"
        add_makefile_content "$mod_path" "mod-$mod_name-akext.so" "usr/lib/mod-$mod_name-akext"
    done
}

generate_build_script() {
    cat > Build.sh <<EOL
#!/bin/bash

export TARGET=native
export BUILD_TYPE=release
export TRIM_BINARY=1

# Function to build all directories under a given path
build_directories() {
    local base_dir=\$1
    if [ -d "\$base_dir" ]; then
        for dir in \$(find "\$base_dir" -mindepth 1 -maxdepth 1 -type d); do
            echo "Building \$dir..."
            make -C "\$dir" target=\$TARGET BUILD_TYPE=\$BUILD_TYPE
            if [ \$? -ne 0 ]; then
                echo "Build failed for \$dir. Exiting."
                exit 1
            fi
        done
    fi
}

# Build Applications
echo "Building Applications..."
build_directories "Applications"

# Build Libraries
echo "Building Libraries..."
build_directories "Libraries"

# Build Microservices Plugins
echo "Building Microservices Plugins..."
build_directories "Microservices/plugins"

# Build Microservices Extension Modules
echo "Building Microservices Extension Modules..."
build_directories "Microservices/extModule"

echo "Build completed successfully."
EOL
    chmod +x Build.sh
}

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
        echo "Creating all directory types..."
        create_applications
        create_libraries
        create_thirdparty
        create_microservices
        ;;
    *)
        echo "Invalid option. Use 'applications', 'libraries', 'thirdparty', 'microservices', or 'ALL'."
        exit 1
        ;;
esac

# Generate Build.sh script
generate_build_script

# Generate CommonMakefile.mk
generate_common_makefile

# CommonMakefile, README.md
touch README.md
