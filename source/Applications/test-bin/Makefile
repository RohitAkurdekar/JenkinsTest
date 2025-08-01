### Makefile for Applications/test-bin  ###
include ../../CommonMakefile.mk

TARGET   := test-bin
DEST        ?= usr/bin
ARCH        ?= native
VERSION     := 1.0.0
BUILD_DIR   := .build_$(ARCH)
SRC_DIR     := src
INCLUDES := \
	-Iinclude \
	-I$(LIBRARIES_DIR)/libakutils/include \
	-I$(THIRD_PARTY_DIR)/nlohmann-json/includes
OBJ_DIR     := $(BUILD_DIR)/src
SRCS     := $(wildcard $(SRC_DIR)/*.cpp)
OBJS     := $(patsubst $(SRC_DIR)/%.cpp,$(OBJ_DIR)/%.o,$(SRCS))
CXXFLAGS += $(INCLUDES)
LDFLAGS  += -L$(LIBRARIES_DIR)/libakutils/$(BUILD_DIR)
LDFLAGS  += -lakutils

.PHONY: all clean

all: $(BUILD_DIR)/$(TARGET)
	@printf "$(COLOR_YELLOW)[STAGE]$(COLOR_RESET) Build Complete: $(TARGET)\n"

$(BUILD_DIR)/$(TARGET): $(OBJS)
	@printf "$(COLOR_YELLOW)[STAGE]$(COLOR_RESET) Linking Application: $(TARGET)\n"
	@$(CXX)  -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@printf "$(COLOR_YELLOW)[Compiling]$(COLOR_RESET) $<\n"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR):
	@mkdir -p $@

install:
	@printf "$(COLOR_YELLOW)[STAGE]$(COLOR_RESET) Installing: $(TARGET)\n"
	@install -Dm755 $(BUILD_DIR)/$(TARGET) $(DEST)/$(TARGET)
	@echo "$(TARGET): $(VERSION)" > $(DEST)/version.txt

clean:
	@rm -rf $(BUILD_DIR)

# EoF makefile
