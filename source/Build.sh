#!/bin/bash

export TARGET=native
export BUILD_TYPE=release
export TRIM_BINARY=1

# Function to build all directories under a given path
build_directories() {
    local base_dir=$1
    if [ -d "$base_dir" ]; then
        for dir in $(find "$base_dir" -mindepth 1 -maxdepth 1 -type d); do
            echo "Building $dir..."
            make -C "$dir" target=$TARGET BUILD_TYPE=$BUILD_TYPE
            if [ $? -ne 0 ]; then
                echo "Build failed for $dir. Exiting."
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
