LOCAL_PATH := $(call my-dir)
dexdump_defaults_CFLAGS   = -Wall
dexdump_defaults_SRCS     =  \
        dexdump_cfg.cc \
        dexdump_main.cc \
        dexdump.cc
dexdump_defaults_INCLUDE_DIRS = art/runtime

include art/build/Android.common_build.mk
# link dexdump2 binary
include $(CLEAR_VARS)
LOCAL_MODULE := dexdump2
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(dexdump_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(dexdump_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(dexdump_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(dexdump_defaults_LDLIBS)
LOCAL_SRC_FILES = $(dexdump_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libdexfile \
        libbase \
        $(dexdump_defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(dexdump_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(dexdump_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

