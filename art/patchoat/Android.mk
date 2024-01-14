LOCAL_PATH := $(call my-dir)
patchoat-defaults_LDLIBS   = -lcrypto
patchoat-defaults_SHARED_LIBS = libbase
patchoat-defaults_SRCS     = patchoat.cc

include art/build/Android.common_build.mk
# link patchoat binary
include $(CLEAR_VARS)
LOCAL_MODULE := patchoat
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(patchoat-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(patchoat-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(patchoat-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(patchoat-defaults_LDLIBS)
LOCAL_SRC_FILES = $(patchoat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart \
        $(patchoat-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(patchoat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(patchoat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

include art/build/Android.common_build.mk
# link patchoatd binary
include $(CLEAR_VARS)
LOCAL_MODULE := patchoatd
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(patchoat-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(patchoat-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(patchoat-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(patchoat-defaults_LDLIBS)
LOCAL_SRC_FILES = $(patchoat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        $(patchoat-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(patchoat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(patchoat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

