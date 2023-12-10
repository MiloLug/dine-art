LOCAL_PATH := $(call my-dir)
dex2oat-defaults_SRCS     = dex2oat.cc
dex2oat-defaults_INCLUDE_DIRS = art/cmdline

include art/build/Android.common_build.mk
# link dex2oat binary
include $(CLEAR_VARS)
LOCAL_MODULE := dex2oat
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(dex2oat-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(dex2oat-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(dex2oat-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(dex2oat-defaults_LDLIBS)
LOCAL_SRC_FILES = $(dex2oat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart \
        libart-compiler \
        libbase \
        libsigchain \
        $(dex2oat-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(dex2oat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(dex2oat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

include art/build/Android.common_build.mk
# link dex2oatd binary
include $(CLEAR_VARS)
LOCAL_MODULE := dex2oatd
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(dex2oat-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(dex2oat-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(dex2oat-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(dex2oat-defaults_LDLIBS)
LOCAL_SRC_FILES = $(dex2oat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        libartd-compiler \
        libbase \
        libsigchain \
        $(dex2oat-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(dex2oat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(dex2oat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

