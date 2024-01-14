LOCAL_PATH := $(call my-dir)
cpp-define-generator-asm-support_OUT      = asm_support_gen.h
define cpp-define-generator-asm-support_GENERATED_SOURCES
GENERATED_SRC_DIR = $(call local-generated-sources-dir)
cpp-define-generator-asm-support_GEN = $$(addprefix $$(GENERATED_SRC_DIR)/,$(cpp-define-generator-asm-support_OUT))

$$(cpp-define-generator-asm-support_GEN): PRIVATE_CUSTOM_TOOL = $(location verify-asm-support) --quiet \"$(location cpp-define-generator-data)\" \"$$@\"
$$(cpp-define-generator-asm-support_GEN):
	$$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $$(cpp-define-generator-asm-support_GEN)

endef

# link cpp-define-generator-data binary
include $(CLEAR_VARS)
LOCAL_MODULE := cpp-define-generator-data
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_SRC_FILES = main.cc
LOCAL_SHARED_LIBRARIES = libbase
LOCAL_C_INCLUDES =  \
        art/libartbase \
        art/libdexfile \
        art/runtime
include $(BUILD_HOST_EXECUTABLE)

