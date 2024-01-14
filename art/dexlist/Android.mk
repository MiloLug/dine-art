LOCAL_PATH := $(call my-dir)
include art/build/Android.common_build.mk
# link dexlist binary
include $(CLEAR_VARS)
LOCAL_MODULE := dexlist
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS   =  \
        $(ART_HOST_CFLAGS) \
        -Wall
LOCAL_SRC_FILES = dexlist.cc
LOCAL_SHARED_LIBRARIES =  \
        libdexfile \
        libbase
LOCAL_C_INCLUDES =  \
        $(ART_C_INCLUDES) \
        art/runtime
LOCAL_CPP_EXTENSION = .cc
include $(BUILD_HOST_EXECUTABLE)

