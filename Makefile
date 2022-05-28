CXX=cc
CXXFLAGS=-std=c99 -pipe -pedantic -O2 -Wall
INCLUDE=-I. -I./include
LDFLAGS=

BIN=mash
TARGET=target

TARGET_BUILD=$(TARGET)/build
TARGET_BIN=$(TARGET)/bin

CFILES=$(wildcard src/*.c)
OBJ=$(CFILES:%.c=$(TARGET_BUILD)/%.o)
DEP=$(OBJ:%.o=%.d)

.PHONY: all run clean
run: all
	@echo -------------------------------------
	@$(TARGET_BIN)/$(BIN) .
all: post-build
post-build: main-build
main-build: pre-build
	@$(MAKE) --no-print-directory $(BIN)
pre-build:
	@mkdir -p $(TARGET_BUILD)

# alias
$(BIN) : $(TARGET_BIN)/$(BIN)

# build final executable
$(TARGET_BIN)/$(BIN): $(OBJ)
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) $^ -o $@ $(LDFLAGS)

-include $(DEP)

$(TARGET_BUILD)/%.o: %.c
	@mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) $(INCLUDE) -MMD -c $< -o $@

clean:
	@rm -rf $(TARGET)