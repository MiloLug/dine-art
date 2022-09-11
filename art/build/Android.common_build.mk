#
# Copyright (C) 2011 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifndef ART_ANDROID_COMMON_BUILD_MK
ART_ANDROID_COMMON_BUILD_MK = true

include art/build/Android.common.mk
include art/build/Android.common_utils.mk

# These can be overridden via the environment or by editing to
# enable/disable certain build configuration.
#
# For example, to disable everything but the host debug build you use:
#
# (export ART_BUILD_TARGET_NDEBUG=false && export ART_BUILD_TARGET_DEBUG=false && export ART_BUILD_HOST_NDEBUG=false && ...)
#
# Beware that tests may use the non-debug build for performance, notable 055-enum-performance
#
ART_BUILD_HOST_NDEBUG ?= true
ART_BUILD_HOST_DEBUG ?= true

ifeq ($(ART_BUILD_HOST_NDEBUG),false)
$(info Disabling ART_BUILD_HOST_NDEBUG)
endif
ifeq ($(ART_BUILD_HOST_DEBUG),false)
$(info Disabling ART_BUILD_HOST_DEBUG)
endif

#
# Used to enable JIT
#
ART_JIT := false
ifneq ($(wildcard art/JIT_ART),)
$(info Enabling ART_JIT because of existence of art/JIT_ART)
ART_JIT := true
endif
ifeq ($(WITH_ART_JIT), true)
ART_JIT := true
endif

#
# Used to change the default GC. Valid values are CMS, SS, GSS. The default is CMS.
#
ART_DEFAULT_GC_TYPE ?= CMS
art_default_gc_type_cflags := -DART_DEFAULT_GC_TYPE_IS_$(ART_DEFAULT_GC_TYPE)

ART_HOST_CFLAGS :=

# Clang build support.

# Host.
ART_HOST_CLANG := false
ifneq ($(WITHOUT_HOST_CLANG),true)
  # By default, host builds use clang for better warnings.
  ART_HOST_CLANG := true
endif

# Warn about thread safety violations with clang.
art_clang_cflags := -Wthread-safety

# Warn if switch fallthroughs aren't annotated.
art_clang_cflags += -Wimplicit-fallthrough

# Enable float equality warnings.
art_clang_cflags += -Wfloat-equal

# Enable warning of converting ints to void*.
art_clang_cflags += -Wint-to-void-pointer-cast

# Enable warning of wrong unused annotations.
art_clang_cflags += -Wused-but-marked-unused

# Enable warning for deprecated language features.
art_clang_cflags += -Wdeprecated

# Enable warning for unreachable break & return.
art_clang_cflags += -Wunreachable-code-break -Wunreachable-code-return

# Enable missing-noreturn only on non-Mac. As lots of things are not implemented for Apple, it's
# a pain.
ifneq ($(HOST_OS),darwin)
  art_clang_cflags += -Wmissing-noreturn
endif


# GCC-only warnings.
art_gcc_cflags := -Wunused-but-set-parameter
# Suggest const: too many false positives, but good for a trial run.
#                  -Wsuggest-attribute=const
# Useless casts: too many, as we need to be 32/64 agnostic, but the compiler knows.
#                  -Wuseless-cast
# Zero-as-null: Have to convert all NULL and "diagnostic ignore" all includes like libnativehelper
# that are still stuck pre-C++11.
#                  -Wzero-as-null-pointer-constant \
# Suggest final: Have to move to a more recent GCC.
#                  -Wsuggest-final-types

# Clear local variables now their use has ended.
art_clang_cflags :=
art_gcc_cflags :=

ART_CPP_EXTENSION := .cc

ART_C_INCLUDES := \
  external/gtest/include \
  external/icu/icu4c/source/common \
  external/valgrind/include \
  external/valgrind \
  external/vixl/src \
  external/zlib \

# Base set of cflags used by all things ART.
art_cflags := \
  -fno-rtti \
  -std=gnu++11 \
  -ggdb3 \
  -Wall \
  -Wextra \
  -Wstrict-aliasing \
  -fstrict-aliasing \
  -Wunreachable-code \
  -Wredundant-decls \
  -Wshadow \
  -Wunused \
  -fvisibility=protected \
  $(art_default_gc_type_cflags)

# Missing declarations: too many at the moment, as we use "extern" quite a bit.
#  -Wmissing-declarations \



ifdef ART_IMT_SIZE
  art_cflags += -DIMT_SIZE=$(ART_IMT_SIZE)
else
  # Default is 64
  art_cflags += -DIMT_SIZE=64
endif

ifeq ($(ART_USE_OPTIMIZING_COMPILER),true)
  art_cflags += -DART_USE_OPTIMIZING_COMPILER=1
endif

ifeq ($(ART_HEAP_POISONING),true)
  art_cflags += -DART_HEAP_POISONING=1
endif

ifeq ($(ART_USE_READ_BARRIER),true)
  art_cflags += -DART_USE_READ_BARRIER=1
endif

ifeq ($(ART_USE_TLAB),true)
  art_cflags += -DART_USE_TLAB=1
endif

# Cflags for non-debug ART and ART tools.
art_non_debug_cflags := \
  -O3

# Cflags for debug ART and ART tools.
art_debug_cflags := \
  -O2 \
  -DDYNAMIC_ANNOTATIONS_ENABLED=1 \
  -DVIXL_DEBUG \
  -UNDEBUG

art_host_non_debug_cflags := $(art_non_debug_cflags)

ifeq ($(HOST_OS),linux)
  # Larger frame-size for host clang builds today
  ifneq ($(ART_COVERAGE),true)
    ifneq ($(NATIVE_COVERAGE),true)
      ifndef SANITIZE_HOST
        art_host_non_debug_cflags += -Wframe-larger-than=2700
      endif
    endif
  endif
endif

ifndef LIBART_IMG_HOST_BASE_ADDRESS
  $(error LIBART_IMG_HOST_BASE_ADDRESS unset)
endif
ART_HOST_CFLAGS += $(art_cflags) -DART_BASE_ADDRESS=$(LIBART_IMG_HOST_BASE_ADDRESS)
ART_HOST_CFLAGS += -DART_DEFAULT_INSTRUCTION_SET_FEATURES=default

ART_HOST_NON_DEBUG_CFLAGS := $(art_host_non_debug_cflags)
ART_HOST_DEBUG_CFLAGS := $(art_debug_cflags)

ifndef LIBART_IMG_HOST_MIN_BASE_ADDRESS_DELTA
  LIBART_IMG_HOST_MIN_BASE_ADDRESS_DELTA=-0x1000000
endif
ifndef LIBART_IMG_HOST_MAX_BASE_ADDRESS_DELTA
  LIBART_IMG_HOST_MAX_BASE_ADDRESS_DELTA=0x1000000
endif
ART_HOST_CFLAGS += -DART_BASE_ADDRESS_MIN_DELTA=$(LIBART_IMG_HOST_MIN_BASE_ADDRESS_DELTA)
ART_HOST_CFLAGS += -DART_BASE_ADDRESS_MAX_DELTA=$(LIBART_IMG_HOST_MAX_BASE_ADDRESS_DELTA)

# To use oprofile_android --callgraph, uncomment this and recompile with "mmm art -B -j16"
# ART_TARGET_CFLAGS += -fno-omit-frame-pointer -marm -mapcs

# Clear locals now they've served their purpose.
art_cflags :=
art_debug_cflags :=
art_non_debug_cflags :=
art_host_non_debug_cflags :=
art_default_gc_type :=
art_default_gc_type_cflags :=

ART_HOST_LDLIBS :=
ifneq ($(ART_HOST_CLANG),true)
  # GCC lacks libc++ assumed atomic operations, grab via libatomic.
  ART_HOST_LDLIBS += -latomic
endif

# Support for disabling certain builds.
ART_BUILD_HOST := false
ART_BUILD_NDEBUG := false
ART_BUILD_DEBUG := false

ifeq ($(ART_BUILD_HOST_NDEBUG),true)
  ART_BUILD_HOST := true
  ART_BUILD_NDEBUG := true
endif
ifeq ($(ART_BUILD_HOST_DEBUG),true)
  ART_BUILD_HOST := true
  ART_BUILD_DEBUG := true
endif

endif # ART_ANDROID_COMMON_BUILD_MK
