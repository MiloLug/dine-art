LOCAL_PATH := $(call my-dir)
art_libartbase_operator_srcs_SRCS     =  \
        base/allocator.h \
        base/callee_save_type.h \
        base/unix_file/fd_file.h
define art_libartbase_operator_srcs_GENERATED_SOURCES
GENERATED_SRC_DIR = $(call local-generated-sources-dir)
art_libartbase_operator_srcs_GEN = $$(addprefix $$(GENERATED_SRC_DIR)/,$(addsuffix _operator_out.cc,$(art_libartbase_operator_srcs_SRCS)))

$$(art_libartbase_operator_srcs_GEN): PRIVATE_CUSTOM_TOOL = art/tools/generate_operator_out.py art/libartbase $$< > $$@
$$(art_libartbase_operator_srcs_GEN): $$(GENERATED_SRC_DIR)/%_operator_out.cc : $(LOCAL_PATH)/%
	$$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $$(art_libartbase_operator_srcs_GEN)

endef

libartbase_defaults_CFLAGS   = -DBUILDING_LIBART=1
libartbase_defaults_SHARED_LIBS =  \
        libbase \
        liblog
libartbase_defaults_SRCS     =  \
        base/allocator.cc \
        base/bit_vector.cc \
        base/file_magic.cc \
        base/hex_dump.cc \
        base/logging.cc \
        base/os_linux.cc \
        base/runtime_debug.cc \
        base/safe_copy.cc \
        base/scoped_flock.cc \
        base/time_utils.cc \
        base/unix_file/fd_file.cc \
        base/unix_file/random_access_file_utils.cc \
        base/utils.cc
libartbase_defaults_EXPORT_INCLUDE_DIRS = $(LOCAL_PATH)/.
libartbase_defaults_GENERATED_SOURCES = $(art_libartbase_operator_srcs_GENERATED_SOURCES)

include art/build/Android.common_build.mk
# link libartbase shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libartbase
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libartbase_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libartbase_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libartbase_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libartbase_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libartbase_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libbase \
        $(libartbase_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libartbase_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libartbase_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libartbase_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libartbase static library
include $(CLEAR_VARS)
LOCAL_MODULE := libartbase
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libartbase_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libartbase_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libartbase_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libartbase_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libartbase_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libbase \
        $(libartbase_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libartbase_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libartbase_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libartbase_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libartbased shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libartbased
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libartbase_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libartbase_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libartbase_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libartbase_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libartbase_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libbase \
        $(libartbase_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libartbase_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libartbase_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libartbase_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libartbased static library
include $(CLEAR_VARS)
LOCAL_MODULE := libartbased
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libartbase_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libartbase_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libartbase_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libartbase_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libartbase_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libbase \
        $(libartbase_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libartbase_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libartbase_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libartbase_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

