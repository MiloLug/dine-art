LOCAL_PATH := $(call my-dir)
oatdump-defaults_SRCS     = oatdump.cc

include art/build/Android.common_build.mk
# link oatdump binary
include $(CLEAR_VARS)
LOCAL_MODULE := oatdump
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(oatdump-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(oatdump-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(oatdump-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(oatdump-defaults_LDLIBS)
LOCAL_SRC_FILES = $(oatdump-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart \
        libart-compiler \
        libart-disassembler \
        libdexfile \
        libbase \
        $(oatdump-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(oatdump-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(oatdump-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

include art/build/Android.common_build.mk
# link oatdumpd binary
include $(CLEAR_VARS)
LOCAL_MODULE := oatdumpd
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(oatdump-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(oatdump-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(oatdump-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(oatdump-defaults_LDLIBS)
LOCAL_SRC_FILES = $(oatdump-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        libartd-compiler \
        libartd-disassembler \
        libdexfiled \
        libbase \
        $(oatdump-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(oatdump-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(oatdump-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

