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

env_test:
ifndef TARGET
	@echo "Target not specified or environment not set up - see . projconf.env"
endif

all: env_test $(TARGET)

$(BUILD_DIR)%.o: $(SOURCE_DIR)%.cpp $(THIS_MAKEFILE)
	@mkdir -p "$(dir $@)"
	@echo "[CXX] $(notdir $@)"
	@$(CXX) $(CXXFLAGS) -c "$<" -o "$@"

$(TARGET): $(OBJECTS) $(TARGET_DEPS)
	@echo "[LD] $(notdir $@)"
	@$(CXX) $(OBJECTS) $(LDFLAGS) -o $(TARGET)

docs: env_test $(SOURCES) $(HEADERS)
	@mkdir -p $(DOCS_DIR)
	@rm -rf $(DOXYFILE)
	@echo "OUTPUT_DIRECTORY=$(DOCS_DIR)/" >> $(DOXYFILE)
	@echo "INPUT=$(SOURCES) $(HEADERS)" >> $(DOXYFILE)
	@doxygen $(DOXYFILE)

clean: env_test
	rm -rf $(TARGET)
	rm -rf $(BUILD_DIR)
	rm -rf $(DOCS_DIR)


.PHONY: clean all docs env_test
