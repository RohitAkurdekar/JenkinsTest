# CommonMakefile
BUILD_MODE ?= release
ARCH ?= x86_64
BUILD_DIR = .build_$(ARCH)

ifeq ($(BUILD_MODE), debug)
    CFLAGS += -g -O0
else
    CFLAGS += -O2 -s
endif

INSTALL_PATH ?= $(DEST)

all: build

build:
	@echo "Building in $(BUILD_DIR) with mode: $(BUILD_MODE)"
	@mkdir -p $(BUILD_DIR)

install:
	@echo "Installing to $(INSTALL_PATH)"
	@if [ -z "$(INSTALL_PATH)" ]; then echo "DEST is not set"; exit 1; fi
	@mkdir -p $(INSTALL_PATH)/usr/bin
	@mkdir -p $(INSTALL_PATH)/usr/lib
