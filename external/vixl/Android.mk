LOCAL_PATH := $(call my-dir)
vixl-common_CXXFLAGS =  \
        -DVIXL_GENERATE_SIMULATOR_INSTRUCTIONS_VALUE=0 \
        -Wextra \
        -fdiagnostics-show-option \
        -Wredundant-decls \
        -Wunreachable-code \
        -Wmissing-noreturn \
        -pedantic \
        -Wwrite-strings \
        -DVIXL_CODE_BUFFER_MALLOC \
        -Isrc
vixl-common_CFLAGS   =  \
        -Wall \
        -Isrc
vixl-common_SRCS     = $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/*.cc))

vixl-arm_arm_CODEGEN_SRCS     = $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/aarch32/*.cc))
vixl-arm_arm64_CODEGEN_SRCS     = $(vixl-arm_arm_CODEGEN_SRCS)
vixl-arm_CXXFLAGS = $(vixl-common_CXXFLAGS)
vixl-arm_CFLAGS   = $(vixl-common_CFLAGS)
vixl-arm_LDFLAGS  = $(vixl-common_LDFLAGS)
vixl-arm_LDLIBS   = $(vixl-common_LDLIBS)
vixl-arm_SRCS     =  \
        $(vixl-common_SRCS) \
        $(vixl-arm_$(HOST_ARCH)_CODEGEN_SRCS)
vixl-arm_INCLUDE_DIRS = $(vixl-common_INCLUDE_DIRS)
vixl-arm_EXPORT_INCLUDE_DIRS = $(vixl-common_EXPORT_INCLUDE_DIRS)
vixl-arm_GENERATED_SOURCES = $(vixl-common_GENERATED_SOURCES)

vixl-arm64_arm64_CODEGEN_SRCS     = $(subst $(LOCAL_PATH)/,,$(wildcard $(LOCAL_PATH)/src/aarch64/*.cc))
vixl-arm64_CXXFLAGS = $(vixl-common_CXXFLAGS)
vixl-arm64_CFLAGS   = $(vixl-common_CFLAGS)
vixl-arm64_LDFLAGS  = $(vixl-common_LDFLAGS)
vixl-arm64_LDLIBS   = $(vixl-common_LDLIBS)
vixl-arm64_SRCS     =  \
        $(vixl-common_SRCS) \
        $(vixl-arm64_$(HOST_ARCH)_CODEGEN_SRCS)
vixl-arm64_INCLUDE_DIRS = $(vixl-common_INCLUDE_DIRS)
vixl-arm64_EXPORT_INCLUDE_DIRS = $(vixl-common_EXPORT_INCLUDE_DIRS)
vixl-arm64_GENERATED_SOURCES = $(vixl-common_GENERATED_SOURCES)

vixl-debug_CXXFLAGS =  \
        $(vixl-common_CXXFLAGS) \
        -DVIXL_DEBUG \
        -UNDEBUG \
        -O2 \
        -ggdb3
vixl-debug_CFLAGS   = $(vixl-common_CFLAGS)
vixl-debug_LDFLAGS  = $(vixl-common_LDFLAGS)
vixl-debug_LDLIBS   = $(vixl-common_LDLIBS)
vixl-debug_SRCS     = $(vixl-common_SRCS)
vixl-debug_INCLUDE_DIRS = $(vixl-common_INCLUDE_DIRS)
vixl-debug_EXPORT_INCLUDE_DIRS = $(vixl-common_EXPORT_INCLUDE_DIRS)
vixl-debug_GENERATED_SOURCES = $(vixl-common_GENERATED_SOURCES)

vixl-release_CXXFLAGS =  \
        $(vixl-common_CXXFLAGS) \
        -O3
vixl-release_CFLAGS   = $(vixl-common_CFLAGS)
vixl-release_LDFLAGS  = $(vixl-common_LDFLAGS)
vixl-release_LDLIBS   = $(vixl-common_LDLIBS)
vixl-release_SRCS     = $(vixl-common_SRCS)
vixl-release_INCLUDE_DIRS = $(vixl-common_INCLUDE_DIRS)
vixl-release_EXPORT_INCLUDE_DIRS = $(vixl-common_EXPORT_INCLUDE_DIRS)
vixl-release_GENERATED_SOURCES = $(vixl-common_GENERATED_SOURCES)

include art/build/Android.common_build.mk
# link libvixl shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libvixl
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CPPFLAGS =  \
        $(vixl-release_CXXFLAGS) \
        $(vixl-arm_CXXFLAGS) \
        $(vixl-arm64_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(vixl-release_CFLAGS) \
        $(vixl-arm_CFLAGS) \
        $(vixl-arm64_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  =  \
        $(vixl-release_LDFLAGS) \
        $(vixl-arm_LDFLAGS) \
        $(vixl-arm64_LDFLAGS)
LOCAL_LDLIBS   =  \
        $(vixl-release_LDLIBS) \
        $(vixl-arm_LDLIBS) \
        $(vixl-arm64_LDLIBS)
LOCAL_SRC_FILES_ =  \
        $(vixl-release_SRCS) \
        $(vixl-arm_SRCS) \
        $(vixl-arm64_SRCS)
LOCAL_SRC_FILES = $(sort $(LOCAL_SRC_FILES_))
LOCAL_SHARED_LIBRARIES =  \
        $(vixl-release_SHARED_LIBS) \
        $(vixl-arm_SHARED_LIBS) \
        $(vixl-arm64_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS =  \
        $(vixl-release_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm64_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(vixl-release_INCLUDE_DIRS) \
        $(vixl-arm_INCLUDE_DIRS) \
        $(vixl-arm64_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(vixl-release_GENERATED_SOURCES))
$(eval $(vixl-arm_GENERATED_SOURCES))
$(eval $(vixl-arm64_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libvixl static library
include $(CLEAR_VARS)
LOCAL_MODULE := libvixl
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CPPFLAGS =  \
        $(vixl-release_CXXFLAGS) \
        $(vixl-arm_CXXFLAGS) \
        $(vixl-arm64_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(vixl-release_CFLAGS) \
        $(vixl-arm_CFLAGS) \
        $(vixl-arm64_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  =  \
        $(vixl-release_LDFLAGS) \
        $(vixl-arm_LDFLAGS) \
        $(vixl-arm64_LDFLAGS)
LOCAL_LDLIBS   =  \
        $(vixl-release_LDLIBS) \
        $(vixl-arm_LDLIBS) \
        $(vixl-arm64_LDLIBS)
LOCAL_SRC_FILES_ =  \
        $(vixl-release_SRCS) \
        $(vixl-arm_SRCS) \
        $(vixl-arm64_SRCS)
LOCAL_SRC_FILES = $(sort $(LOCAL_SRC_FILES_))
LOCAL_SHARED_LIBRARIES =  \
        $(vixl-release_SHARED_LIBS) \
        $(vixl-arm_SHARED_LIBS) \
        $(vixl-arm64_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS =  \
        $(vixl-release_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm64_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(vixl-release_INCLUDE_DIRS) \
        $(vixl-arm_INCLUDE_DIRS) \
        $(vixl-arm64_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(vixl-release_GENERATED_SOURCES))
$(eval $(vixl-arm_GENERATED_SOURCES))
$(eval $(vixl-arm64_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libvixld shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libvixld
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CPPFLAGS =  \
        $(vixl-debug_CXXFLAGS) \
        $(vixl-arm_CXXFLAGS) \
        $(vixl-arm64_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(vixl-debug_CFLAGS) \
        $(vixl-arm_CFLAGS) \
        $(vixl-arm64_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  =  \
        $(vixl-debug_LDFLAGS) \
        $(vixl-arm_LDFLAGS) \
        $(vixl-arm64_LDFLAGS)
LOCAL_LDLIBS   =  \
        $(vixl-debug_LDLIBS) \
        $(vixl-arm_LDLIBS) \
        $(vixl-arm64_LDLIBS)
LOCAL_SRC_FILES_ =  \
        $(vixl-debug_SRCS) \
        $(vixl-arm_SRCS) \
        $(vixl-arm64_SRCS)
LOCAL_SRC_FILES = $(sort $(LOCAL_SRC_FILES_))
LOCAL_SHARED_LIBRARIES =  \
        $(vixl-debug_SHARED_LIBS) \
        $(vixl-arm_SHARED_LIBS) \
        $(vixl-arm64_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS =  \
        $(vixl-debug_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm64_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(vixl-debug_INCLUDE_DIRS) \
        $(vixl-arm_INCLUDE_DIRS) \
        $(vixl-arm64_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(vixl-debug_GENERATED_SOURCES))
$(eval $(vixl-arm_GENERATED_SOURCES))
$(eval $(vixl-arm64_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libvixld static library
include $(CLEAR_VARS)
LOCAL_MODULE := libvixld
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CPPFLAGS =  \
        $(vixl-debug_CXXFLAGS) \
        $(vixl-arm_CXXFLAGS) \
        $(vixl-arm64_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(vixl-debug_CFLAGS) \
        $(vixl-arm_CFLAGS) \
        $(vixl-arm64_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  =  \
        $(vixl-debug_LDFLAGS) \
        $(vixl-arm_LDFLAGS) \
        $(vixl-arm64_LDFLAGS)
LOCAL_LDLIBS   =  \
        $(vixl-debug_LDLIBS) \
        $(vixl-arm_LDLIBS) \
        $(vixl-arm64_LDLIBS)
LOCAL_SRC_FILES_ =  \
        $(vixl-debug_SRCS) \
        $(vixl-arm_SRCS) \
        $(vixl-arm64_SRCS)
LOCAL_SRC_FILES = $(sort $(LOCAL_SRC_FILES_))
LOCAL_SHARED_LIBRARIES =  \
        $(vixl-debug_SHARED_LIBS) \
        $(vixl-arm_SHARED_LIBS) \
        $(vixl-arm64_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS =  \
        $(vixl-debug_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm_EXPORT_INCLUDE_DIRS) \
        $(vixl-arm64_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(vixl-debug_INCLUDE_DIRS) \
        $(vixl-arm_INCLUDE_DIRS) \
        $(vixl-arm64_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(vixl-debug_GENERATED_SOURCES))
$(eval $(vixl-arm_GENERATED_SOURCES))
$(eval $(vixl-arm64_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

