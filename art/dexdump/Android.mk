LOCAL_PATH := $(call my-dir)
include art/build/Android.common_build.mk
# link dexdump2 binary
include $(CLEAR_VARS)
LOCAL_MODULE := dexdump2
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS   =  \
        $(ART_HOST_CFLAGS) \
        -Wall
LOCAL_SRC_FILES =  \
        dexdump_cfg.cc \
        dexdump_main.cc \
        dexdump.cc
LOCAL_SHARED_LIBRARIES =  \
        libart \
        libbase
LOCAL_C_INCLUDES = $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
include $(BUILD_HOST_EXECUTABLE)

