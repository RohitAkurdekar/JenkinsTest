### Root: source/CommonMakefile.mk ###
SHELL := /bin/bash
ARCH ?= native
# Common build settings
CXX := g++
CXXFLAGS += -std=c++17 -Wall -Wextra -fPIC
LDFLAGS :=

# Root Directory (one level above source)
ROOT_DIR ?= $(shell git rev-parse --show-toplevel)
SOURCE_DIR := $(ROOT_DIR)/source
LIBRARIES_DIR := $(SOURCE_DIR)/Libraries
THIRD_PARTY_DIR := $(SOURCE_DIR)/ThirdPartyLibs

# Output directories
BUILD_DIR := .build_$(ARCH)
SRC_DIR := src
INC_DIR := include

# Color codes
COLOR_RED := \033[1;31m
COLOR_GREEN := \033[1;32m
COLOR_YELLOW := \033[1;33m
COLOR_BLUE := \033[1;34m
COLOR_RESET := \033[0m

# Tools
MKDIR_P := mkdir -p
RM := rm -rf

