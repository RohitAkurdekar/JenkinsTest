TARGET         := test-bin
VERSION		:= 1.0.6
include ../../CommonMakefile.mk
BUILD_DIR      := .build_$(ARCH)
SRC_DIR        := src
INCLUDES := \
	-Iinclude \
	-I$(LIBRARIES_DIR)/libakutils/include \
	-I$(THIRD_PARTY_DIR)/nlohmann-json/includes
OBJ_DIR        := $(BUILD_DIR)/src
OBJS           := $(OBJ_DIR)/testMain.o
CXX            := g++
CXXFLAGS       += -Wall -Werror $(INCLUDES)
LDFLAGS        += -L$(LIBRARIES_DIR)/libakutils/.build_$(ARCH)
LDFLAGS        += -lakutils

# Color codes
YELLOW := \033[1;33m
NC := \033[0m

.PHONY: all clean

all: $(BUILD_DIR)/$(TARGET)
	@echo "$(YELLOW)[STAGE]$(NC) Build Complete: $(TARGET)"

$(BUILD_DIR)/$(TARGET): $(OBJS)
	@echo "$(YELLOW)[STAGE]$(NC) Linking Application: $(TARGET)"
	@$(CXX) -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp | $(OBJ_DIR)
	@echo "$(YELLOW)[Compiling]$(NC) $<"
	@$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJ_DIR):
	@mkdir -p $@

install:
	@echo "$(YELLOW)[STAGE]$(NC) Installing: $(TARGET)"
	@install -Dm755 $(BUILD_DIR)/$(TARGET) $(DEST)/$(TARGET)
	@echo "$(TARGET): $(VERSION)" > $(DEST)/version.txt

clean:
	@rm -rf $(BUILD_DIR)
