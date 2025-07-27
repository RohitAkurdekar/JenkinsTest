# CommonMakefile.mk

BUILD_MODE ?= release
ARCH ?= x86_64
BUILD_DIR ?= .build_$(ARCH)
BUILD_DIR_REL := $(notdir $(BUILD_DIR))
THIRD_PARTY_DIR ?= $(ROOT_DIR)/ThirdPartyLibs
LIB_DIR ?= $(ROOT_DIR)/Libraries

ifeq ($(BUILD_MODE), debug)
    CFLAGS += -g -O0
else
    CFLAGS += -O2 -s
endif

INSTALL_PATH ?= $(DEST)
STRIP ?= strip

all: build

build:
	@echo "Building in $(BUILD_DIR_REL) with mode: $(BUILD_MODE)"
	@mkdir -p $(BUILD_DIR)

install:
	@echo "Installing to $(INSTALL_PATH)"
	@if [ -z "$(INSTALL_PATH)" ]; then echo "DEST is not set"; exit 1; fi
	@mkdir -p $(INSTALL_PATH)/usr/bin
	@mkdir -p $(INSTALL_PATH)/usr/lib
