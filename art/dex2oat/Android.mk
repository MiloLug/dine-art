LOCAL_PATH := $(call my-dir)
art_dex2oat_operator_srcs_SRCS     = linker/image_writer.h
define art_dex2oat_operator_srcs_GENERATED_SOURCES
GENERATED_SRC_DIR = $(call local-generated-sources-dir)
art_dex2oat_operator_srcs_GEN = $$(addprefix $$(GENERATED_SRC_DIR)/,$(addsuffix _operator_out.cc,$(art_dex2oat_operator_srcs_SRCS)))

$$(art_dex2oat_operator_srcs_GEN): PRIVATE_CUSTOM_TOOL = art/tools/generate_operator_out.py art/dex2oat $$< > $$@
$$(art_dex2oat_operator_srcs_GEN): $$(GENERATED_SRC_DIR)/%_operator_out.cc : $(LOCAL_PATH)/%
	$$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $$(art_dex2oat_operator_srcs_GEN)

endef

libart-dex2oat-defaults_LDLIBS   =  \
        -llz4 \
        -llzma \
        -lcrypto
libart-dex2oat-defaults_SHARED_LIBS = libbase
libart-dex2oat-defaults_SRCS     =  \
        linker/elf_writer.cc \
        linker/elf_writer_quick.cc \
        linker/image_writer.cc \
        linker/multi_oat_relative_patcher.cc \
        linker/oat_writer.cc
libart-dex2oat-defaults_INCLUDE_DIRS =  \
        external/lz4/lib \
        external/zlib
libart-dex2oat-defaults_EXPORT_INCLUDE_DIRS = $(LOCAL_PATH)/.
libart-dex2oat-defaults_GENERATED_SOURCES = $(art_dex2oat_operator_srcs_GENERATED_SOURCES)

include art/build/Android.common_build.mk
# link libart-dex2oat static library
include $(CLEAR_VARS)
LOCAL_MODULE := libart-dex2oat
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart-dex2oat-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart-dex2oat-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart-dex2oat-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart-dex2oat-defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart-dex2oat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart-compiler \
        libart-dexlayout \
        libart \
        $(libart-dex2oat-defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart-dex2oat-defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart-dex2oat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart-dex2oat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libartd-dex2oat static library
include $(CLEAR_VARS)
LOCAL_MODULE := libartd-dex2oat
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart-dex2oat-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart-dex2oat-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart-dex2oat-defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart-dex2oat-defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart-dex2oat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd-compiler \
        libartd-dexlayout \
        libartd \
        $(libart-dex2oat-defaults_SHARED_LIBS)
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart-dex2oat-defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart-dex2oat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart-dex2oat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

dex2oat-defaults_LDLIBS   = -lcrypto
dex2oat-defaults_SRCS     =  \
        dex2oat_options.cc \
        dex2oat.cc


include art/build/Android.common_build.mk
# link dex2oat binary
include $(CLEAR_VARS)
LOCAL_MODULE := dex2oat
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS =  \
        $(dex2oat-defaults_CXXFLAGS) \
        $(dex2oat-pgo-defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(dex2oat-defaults_CFLAGS) \
        $(dex2oat-pgo-defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  =  \
        $(dex2oat-defaults_LDFLAGS) \
        $(dex2oat-pgo-defaults_LDFLAGS)
LOCAL_LDLIBS   =  \
        $(dex2oat-defaults_LDLIBS) \
        $(dex2oat-pgo-defaults_LDLIBS) \
        -llz4
LOCAL_SRC_FILES =  \
        $(dex2oat-defaults_SRCS) \
        $(dex2oat-pgo-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libart-compiler \
        libart-dexlayout \
        libart \
        libdexfile \
        libbase \
        libsigchain \
        $(dex2oat-defaults_SHARED_LIBS) \
        $(dex2oat-pgo-defaults_SHARED_LIBS)
LOCAL_STATIC_LIBRARIES = libart-dex2oat
LOCAL_C_INCLUDES =  \
        $(dex2oat-defaults_INCLUDE_DIRS) \
        $(dex2oat-pgo-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(dex2oat-defaults_GENERATED_SOURCES))
$(eval $(dex2oat-pgo-defaults_GENERATED_SOURCES))
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
LOCAL_LDLIBS   =  \
        $(dex2oat-defaults_LDLIBS) \
        -llz4
LOCAL_SRC_FILES = $(dex2oat-defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libartd-compiler \
        libartd-dexlayout \
        libartd \
        libdexfiled \
        libbase \
        libsigchain \
        $(dex2oat-defaults_SHARED_LIBS)
LOCAL_STATIC_LIBRARIES = libartd-dex2oat
LOCAL_C_INCLUDES =  \
        $(dex2oat-defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(dex2oat-defaults_GENERATED_SOURCES))
include $(BUILD_HOST_EXECUTABLE)

