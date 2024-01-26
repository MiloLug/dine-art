LOCAL_PATH := $(call my-dir)
libandroidfw_defaults_CFLAGS   =  \
        -Wunreachable-code \
        -std=c++14

# link libandroidfw shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libandroidfw
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libandroidfw_defaults_CXXFLAGS)
LOCAL_CFLAGS   = $(libandroidfw_defaults_CFLAGS)
LOCAL_LDFLAGS  = $(libandroidfw_defaults_LDFLAGS)
LOCAL_LDLIBS   =  \
        $(libandroidfw_defaults_LDLIBS) \
        -lz
LOCAL_SRC_FILES =  \
        $(libandroidfw_defaults_SRCS) \
        ApkAssets.cpp \
        Asset.cpp \
        AssetDir.cpp \
        AssetManager.cpp \
        AssetManager2.cpp \
        AttributeResolution.cpp \
        ChunkIterator.cpp \
        ConfigDescription.cpp \
        Idmap.cpp \
        LoadedArsc.cpp \
        Locale.cpp \
        LocaleData.cpp \
        misc.cpp \
        ObbFile.cpp \
        PosixUtils.cpp \
        ResourceTypes.cpp \
        ResourceUtils.cpp \
        StreamingZipInflater.cpp \
        TypeWrappers.cpp \
        Util.cpp \
        ZipFileRO.cpp \
        ZipUtils.cpp \
        androidfw_c_api.cpp
LOCAL_SHARED_LIBRARIES =  \
        libziparchive \
        libbase \
        liblog \
        libcutils \
        libutils \
        $(libandroidfw_defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS =  \
        $(libandroidfw_defaults_EXPORT_INCLUDE_DIRS) \
        $(LOCAL_PATH)/include
LOCAL_C_INCLUDES =  \
        $(libandroidfw_defaults_INCLUDE_DIRS) \
        $(LOCAL_EXPORT_C_INCLUDE_DIRS)
$(eval $(libandroidfw_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

