LOCAL_PATH := $(call my-dir)
profman-defaults_SHARED_LIBS = libbase
profman-defaults_SRCS     =  \
        boot_image_profile.cc \
        profman.cc \
        profile_assistant.cc

include art/build/Android.common_build.mk
# link profman binary
include $(CLEAR_VARS)
LOCAL_MODULE := profman
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(profman-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(profman-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(profman-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(profman-defaults_LDLIBS)
LOCAL_SRC_FILES = $(profman-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart \
        libdexfile \
        $(profman-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(profman-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(profman-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

include art/build/Android.common_build.mk
# link profmand binary
include $(CLEAR_VARS)
LOCAL_MODULE := profmand
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(profman-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(profman-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(profman-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(profman-defaults_LDLIBS)
LOCAL_SRC_FILES = $(profman-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        libdexfiled \
        $(profman-defaults_SHARED_LIBS)
LOCAL_C_INCLUDES =  \
        $(profman-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(profman-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

