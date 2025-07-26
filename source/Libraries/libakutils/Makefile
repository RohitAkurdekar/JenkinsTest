include ../../CommonMakefile.mk

TARGET ?= native
SRC_DIR := src
INCLUDE_DIR := include
BUILD_DIR := .build
OUT_DIR := output

SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(SRCS:%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

BIN := $(BUILD_DIR)/libakutils.so

CXXFLAGS += -I$(INCLUDE_DIR)

$(BUILD_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

all: $(BIN)

$(BIN): $(OBJS)
	$(CXX) $^ -o $@
	$(STRIP) $@

install:
	@mkdir -p $(INSTALL_PATH)/usr/lib
	cp $(BIN) $(INSTALL_PATH)/usr/lib

clean:
	rm -rf $(BUILD_DIR) $(OUT_DIR)

-include $(DEPS)
