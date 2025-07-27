TARGET         := libakutils.so
include ../../CommonMakefile.mk
BUILD_DIR      := .build_$(ARCH)
SRC_DIR        := src
INCLUDES := \
	-Iinclude \
	-I$(THIRD_PARTY_DIR)/nlohmann-json/includes

OBJ_DIR        := $(BUILD_DIR)/src
OBJS           := $(OBJ_DIR)/akJsonUtils.o
CXX            := g++
CXXFLAGS       += -Wall -Werror -fPIC $(INCLUDES)
LDFLAGS        += -shared

# Color codes
YELLOW := \033[1;33m
NC := \033[0m

.PHONY: all clean

all: $(BUILD_DIR)/$(TARGET)
	@echo "$(YELLOW)[STAGE]$(NC) Built $(TARGET)"

$(BUILD_DIR)/$(TARGET): $(OBJS)
	@echo "$(YELLOW)[STAGE]$(NC) Building Shared Library: $(TARGET)"
	@$(CXX) $(LDFLAGS) -o $@ $^

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@echo "$(YELLOW)[Compiling]$(NC) $<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR):
	@mkdir -p $@

clean:
	@rm -rf $(BUILD_DIR)
