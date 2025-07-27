### Root: source/CommonMakefile.mk ###
ARCH ?= native
# Common build settings
CXX := g++
CXXFLAGS := -std=c++17 -Wall -Wextra -fPIC
LDFLAGS :=

# Root Directory (one level above source)
ROOT_DIR := $(abspath $(CURDIR)/../..)
LIBRARIES_DIR := $(ROOT_DIR)/Libraries
THIRD_PARTY_DIR := $(ROOT_DIR)/ThirdPartyLibs

# Output directories
BUILD_DIR := $(CURDIR)/.build_$(ARCH)
SRC_DIR := $(CURDIR)/src
INC_DIR := $(CURDIR)/include

# Tools
MKDIR_P := mkdir -p
RM := rm -rf