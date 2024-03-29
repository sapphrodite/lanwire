TARGET := lanwire
BUILD_DIR := build/
SOURCE_DIR := src/
INCLUDE_DIRS := /usr/include
LIBS :=  SDL SDL_mixer asan ubsan
CXXFLAGS := --std=c++20 -Wall -Wextra -g3  -fsanitize=undefined -fsanitize=address 
SUBMAKES :=
TARGET_DEPS :=


LDFLAGS := $(CXXFLAGS) $(addprefix -l, $(LIBS))
CXXFLAGS += -MMD -MP -I$(SOURCE_DIR) $(addprefix -I, $(INCLUDE_DIRS))
THIS_MAKEFILE := $(firstword $(MAKEFILE_LIST))
SOURCE_DIRS := $(SOURCE_DIR) $(addprefix $(SOURCE_DIR), $(SOURCE_SUBDIRS))
SOURCES := $(foreach d, $(SOURCE_DIRS), $(wildcard $(d)*.cpp))
HEADERS := $(foreach d, $(SOURCE_DIRS), $(wildcard $(d)*.h))
OBJECTS := $(patsubst $(SOURCE_DIR)%.cpp, $(BUILD_DIR)%.o, $(SOURCES))
DEPFILES := $(patsubst %.o,%.d,$(OBJECTS))
-include $(DEPFILES)
include $(SUBMAKES)


$(BUILD_DIR)%.o: $(SOURCE_DIR)%.cpp $(THIS_MAKEFILE)
	@mkdir -p "$(dir $@)"
	@echo "[CXX] $(notdir $@)"
	@$(CXX) $(CXXFLAGS) -c "$<" -o "$@"

$(TARGET): $(OBJECTS)
	@echo "[LD] $(notdir $@)"
	@$(CXX) $(OBJECTS) $(LDFLAGS) -o $(TARGET)

all: $(TARGET)

docs:
	SOURCES="$(SOURCES) $(HEADERS)" doxygen

clean:
	rm -rf $(TARGET)
	rm -rf $(BUILD_DIR)
	rm -rf docs

.PHONY: clean all docs
