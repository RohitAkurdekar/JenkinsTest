### Makefile for Libraries/libmylogger  ###
include ../../CommonMakefile.mk

TARGET    := libmylogger.so
DEST		?= usr/lib
ARCH		?= native
VERSION   := 1.0.0
BUILD_DIR := .build_$(ARCH)
SRC_DIR   := src
INCLUDES  := -Iinclude
OBJ_DIR   := $(BUILD_DIR)/src
SRCS      := $(wildcard $(SRC_DIR)/*.c)
OBJS      := $(patsubst $(SRC_DIR)/%.c,$(OBJ_DIR)/%.o,$(SRCS))
CFLAGS    += $(INCLUDES)

.PHONY: all clean

all: $(BUILD_DIR)/$(TARGET)
	@printf "$(COLOR_YELLOW)[STAGE]$(COLOR_RESET) Build Complete: $(TARGET)\n"

$(BUILD_DIR)/$(TARGET): $(OBJS)
	@printf "$(COLOR_YELLOW)[STAGE]$(COLOR_RESET) Linking Application: $(TARGET)\n"
	@$(CC) -shared -o $@ $^ $(LDFLAGS)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@printf "$(COLOR_YELLOW)[Compiling]$(COLOR_RESET) $<\n"
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	@mkdir -p $@

install:
	@printf "$(COLOR_YELLOW)[STAGE]$(COLOR_RESET) Installing: $(TARGET)\n"
	@install -Dm755 $(BUILD_DIR)/$(TARGET) $(DEST)/$(TARGET)
	@echo "$(TARGET): $(VERSION)" > $(DEST)/version.txt

clean:
	@rm -rf $(BUILD_DIR)

# EoF makefile
