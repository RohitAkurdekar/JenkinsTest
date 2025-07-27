#!/bin/bash

export TARGET=native
export BUILD_TYPE=release
export TRIM_BINARY=1

# Function to build all directories under a given path
build_directories() {
    local base_dir=$1
    if [ -d "$base_dir" ]; then
        for dir in $(find "$base_dir" -mindepth 1 -maxdepth 1 -type d); do
            printf"Building $dir..."
            make -C "$dir" target=$TARGET BUILD_TYPE=$BUILD_TYPE
            if [ $? -ne 0 ]; then
                printf"Build failed for $dir. Exiting."
                exit 1
            fi
        done
    fi
}

# Build Applications
printf"Building Applications..."
build_directories "Applications"

# Build Libraries
printf"Building Libraries..."
build_directories "Libraries"

# Build Microservices Plugins
printf"Building Microservices Plugins..."
build_directories "Microservices/plugins"

# Build Microservices Extension Modules
printf"Building Microservices Extension Modules..."
build_directories "Microservices/extModule"

printf"Build completed successfully."
