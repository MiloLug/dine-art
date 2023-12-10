LOCAL_PATH := $(call my-dir)
libart-dexlayout-defaults_LDLIBS   = -lz
libart-dexlayout-defaults_SHARED_LIBS = libbase
libart-dexlayout-defaults_SRCS     =  \
        dexlayout.cc \
        dex_ir.cc \
        dex_ir_builder.cc \
        dex_verify.cc \
        dex_visualize.cc \
        dex_writer.cc
libart-dexlayout-defaults_EXPORT_INCLUDE_DIRS = $(LOCAL_PATH)/.

include art/build/Android.common_build.mk
# link libart-dexlayout shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libart-dexlayout
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart-dexlayout-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart-dexlayout-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart-dexlayout-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart-dexlayout-defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart-dexlayout-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart \
        $(libart-dexlayout-defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart-dexlayout-defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart-dexlayout-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart-dexlayout-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libart-dexlayout static library
include $(CLEAR_VARS)
LOCAL_MODULE := libart-dexlayout
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart-dexlayout-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart-dexlayout-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart-dexlayout-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart-dexlayout-defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart-dexlayout-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart \
        $(libart-dexlayout-defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart-dexlayout-defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart-dexlayout-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart-dexlayout-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libartd-dexlayout shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libartd-dexlayout
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart-dexlayout-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart-dexlayout-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart-dexlayout-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart-dexlayout-defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart-dexlayout-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        $(libart-dexlayout-defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart-dexlayout-defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart-dexlayout-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart-dexlayout-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libartd-dexlayout static library
include $(CLEAR_VARS)
LOCAL_MODULE := libartd-dexlayout
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart-dexlayout-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart-dexlayout-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart-dexlayout-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart-dexlayout-defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart-dexlayout-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        $(libart-dexlayout-defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart-dexlayout-defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart-dexlayout-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart-dexlayout-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link dexlayout binary
include $(CLEAR_VARS)
LOCAL_MODULE := dexlayout
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS   =  \
        $(ART_HOST_CFLAGS) \
        -Wall
LOCAL_SRC_FILES = dexlayout_main.cc
LOCAL_SHARED_LIBRARIES =  \
        libart \
        libart-dexlayout \
        libbase
LOCAL_C_INCLUDES = $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
include $(BUILD_HOST_EXECUTABLE)

include art/build/Android.common_build.mk
# link dexdiag binary
include $(CLEAR_VARS)
LOCAL_MODULE := dexdiag
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS   =  \
        $(ART_HOST_CFLAGS) \
        -Wall
LOCAL_SRC_FILES = dexdiag.cc
LOCAL_SHARED_LIBRARIES =  \
        libart \
        libart-dexlayout
LOCAL_C_INCLUDES = $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
include $(BUILD_HOST_EXECUTABLE)

