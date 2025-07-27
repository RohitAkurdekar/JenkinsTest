# Libraries/libakutils/makefile

ROOT_DIR := $(realpath ../..)
include $(ROOT_DIR)/CommonMakefile.mk

TARGET ?= native
SRC_DIR := src
INCLUDE_DIR := include
BUILD_DIR := $(ROOT_DIR)/Libraries/libakutils/.build_$(TARGET)
OUT_DIR := $(ROOT_DIR)/Libraries/libakutils/output

SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst %.cpp,$(BUILD_DIR)/%.o,$(SRCS))
DEPS := $(OBJS:.o=.d)

BIN := $(BUILD_DIR)/libakutils.so

CXXFLAGS += -fPIC -I$(INCLUDE_DIR)
CXXFLAGS += -I$(THIRD_PARTY_DIR)/nlohmann-json/includes

$(BUILD_DIR)/%.o: %.cpp
	@echo "Compiling <---------- $(notdir $<)"
	@mkdir -p $(dir $@)
	@$(CXX) $(CXXFLAGS) -c $< -o $@

all: $(BIN)

$(BIN): $(OBJS)
	@echo "Building library: $(notdir $(BIN))"
	@mkdir -p $(dir $@)
	@$(CXX) -shared $^ -o $@
	@$(STRIP) $@
	@echo "Done"

install: install_lib

install_lib:
	@echo "Installing library: libakutils"
	@mkdir -p $(INSTALL_PATH)/usr/lib
	@cp $(BIN) $(INSTALL_PATH)/usr/lib
	@echo "Done"

clean:
	@echo "Cleaning build directories"
	@rm -rf $(BUILD_DIR) $(OUT_DIR)
	@echo "Done"

-include $(DEPS)
