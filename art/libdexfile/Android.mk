LOCAL_PATH := $(call my-dir)
dexfile_operator_srcs_SRCS     =  \
        dex/dex_file.h \
        dex/dex_file_layout.h \
        dex/dex_instruction.h \
        dex/dex_instruction_utils.h \
        dex/invoke_type.h \
        dex/method_reference.h
define dexfile_operator_srcs_GENERATED_SOURCES
GENERATED_SRC_DIR = $(call local-generated-sources-dir)
dexfile_operator_srcs_GEN = $$(addprefix $$(GENERATED_SRC_DIR)/,$(addsuffix _operator_out.cc,$(dexfile_operator_srcs_SRCS)))

$$(dexfile_operator_srcs_GEN): PRIVATE_CUSTOM_TOOL = art/tools/generate_operator_out.py art/libdexfile $$< > $$@
$$(dexfile_operator_srcs_GEN): $$(GENERATED_SRC_DIR)/%_operator_out.cc : $(LOCAL_PATH)/%
	$$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $$(dexfile_operator_srcs_GEN)

endef

libdexfile_defaults_LDLIBS   =  \
        -lz \
        -lz
libdexfile_defaults_SHARED_LIBS =  \
        libziparchive \
        liblog \
        libbase
libdexfile_defaults_SRCS     =  \
        dex/compact_dex_file.cc \
        dex/compact_offset_table.cc \
        dex/descriptors_names.cc \
        dex/dex_file.cc \
        dex/dex_file_exception_helpers.cc \
        dex/dex_file_layout.cc \
        dex/dex_file_loader.cc \
        dex/dex_file_tracking_registrar.cc \
        dex/dex_file_verifier.cc \
        dex/dex_instruction.cc \
        dex/modifiers.cc \
        dex/primitive.cc \
        dex/standard_dex_file.cc \
        dex/utf.cc
libdexfile_defaults_EXPORT_INCLUDE_DIRS = $(LOCAL_PATH)/.
libdexfile_defaults_GENERATED_SOURCES = $(dexfile_operator_srcs_GENERATED_SOURCES)

include art/build/Android.common_build.mk
# link libdexfile shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libdexfile
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libdexfile_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libdexfile_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libdexfile_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libdexfile_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libdexfile_defaults_SRCS)
LOCAL_SHARED_LIBRARIES = $(libdexfile_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libdexfile_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libdexfile_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libdexfile_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libdexfile static library
include $(CLEAR_VARS)
LOCAL_MODULE := libdexfile
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libdexfile_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libdexfile_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libdexfile_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libdexfile_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libdexfile_defaults_SRCS)
LOCAL_SHARED_LIBRARIES = $(libdexfile_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libdexfile_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libdexfile_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libdexfile_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libdexfiled shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libdexfiled
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libdexfile_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libdexfile_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libdexfile_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libdexfile_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libdexfile_defaults_SRCS)
LOCAL_SHARED_LIBRARIES = $(libdexfile_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libdexfile_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libdexfile_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libdexfile_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libdexfiled static library
include $(CLEAR_VARS)
LOCAL_MODULE := libdexfiled
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libdexfile_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libdexfile_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libdexfile_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libdexfile_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libdexfile_defaults_SRCS)
LOCAL_SHARED_LIBRARIES = $(libdexfile_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libdexfile_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libdexfile_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libdexfile_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

