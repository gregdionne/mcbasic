TARGET_EXEC ?= ../mcbasic

BUILD_DIR ?= .build

SRCS := $(shell find . -name \*.cpp -or -name \*.c -or -name \*.s)
OBJS := $(SRCS:%.cpp=$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

CXXFLAGS ?= -MMD -MP -std=c++14 -O3 -Wall -Wextra -I.

# assume clang if on darwin
ifeq ($(OSTYPE),darwin)
 ifeq ($(CXX),c++)
  CXXFLAGS += -ferror-limit=4
 endif
endif

#$(BUILD_DIR)/$(TARGET_EXEC): $(OBJS)
$(TARGET_EXEC): $(OBJS)
	$(CXX) $(OBJS) -o $@ 

# c++ source
$(BUILD_DIR)/%.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@


.PHONY: clean

clean:
	$(RM) -r $(BUILD_DIR)

-include $(DEPS)

MKDIR_P ?= mkdir -p
