# Copyright (C) 2015 The Android Open Source Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in
#    the documentation and/or other materials provided with the
#    distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
# FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
# COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
# INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
# BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
# OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
# AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#
#
# Copyright (c) 2015 ARM Ltd
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. The name of the company may not be used to endorse or promote
#    products derived from this software without specific prior written
#    permission.
#
# THIS SOFTWARE IS PROVIDED BY ARM LTD ``AS IS'' AND ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL ARM LTD BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

LOCAL_PATH:= $(call my-dir)

vixl_root := $(LOCAL_PATH)/
vixl_include_files := $(vixl_root)/src/

vixl_src_files := \
  src/aarch32/assembler-aarch32.cc \
  src/aarch32/constants-aarch32.cc \
  src/aarch32/disasm-aarch32.cc \
  src/aarch32/instructions-aarch32.cc \
  src/aarch32/label-aarch32.cc \
  src/aarch32/macro-assembler-aarch32.cc \
  src/aarch32/operands-aarch32.cc \
  src/aarch64/assembler-aarch64.cc \
  src/aarch64/cpu-aarch64.cc \
  src/aarch64/debugger-aarch64.cc \
  src/aarch64/decoder-aarch64.cc \
  src/aarch64/disasm-aarch64.cc \
  src/aarch64/instructions-aarch64.cc \
  src/aarch64/instrument-aarch64.cc \
  src/aarch64/logic-aarch64.cc \
  src/aarch64/macro-assembler-aarch64.cc \
  src/aarch64/operands-aarch64.cc \
  src/aarch64/simulator-aarch64.cc \
  src/code-buffer-vixl.cc \
  src/compiler-intrinsics-vixl.cc \
  src/utils-vixl.cc

vixl_test_files := \
  

vixl_cpp_flags := \
  -DVIXL_INCLUDE_SIMULATOR \
  -DVIXL_GENERATE_SIMULATOR_INSTRUCTIONS_VALUE=0 \
  -Wall \
  -Wextra \
  -fdiagnostics-show-option \
  -Wredundant-decls \
  -Wunreachable-code \
  -Wmissing-noreturn \
  -pedantic \
  -std=c++11 \
  -DVIXL_CODE_BUFFER_MALLOC \

# Explicitly enable the write-strings warning. VIXL uses
# const correctly when handling string constants.
vixl_cpp_flags += \
  -Wwrite-strings \

vixl_cpp_flags_release := \
  $(vixl_cpp_flags) \
  -O3 \

vixl_cpp_flags_debug := \
  $(vixl_cpp_flags) \
  -DVIXL_DEBUG \
  -UNDEBUG \
  -O2 \
  -ggdb3 \

VIXL_COVERAGE := false

ifeq ($(ART_COVERAGE), true)
  VIXL_COVERAGE := true
endif

include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_release)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_src_files)
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libvixl
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_debug)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_src_files)
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libvixld
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_release)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_NATIVE_COVERAGE := $(VIXL_COVERAGE)
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_src_files)
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libvixl
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
LOCAL_MULTILIB := both
include $(BUILD_HOST_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_debug)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_NATIVE_COVERAGE := $(VIXL_COVERAGE)
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_src_files)
LOCAL_SHARED_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libvixld
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
LOCAL_MULTILIB := both
include $(BUILD_HOST_SHARED_LIBRARY)

# Static libraries for host
include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_release)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_NATIVE_COVERAGE := $(VIXL_COVERAGE)
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_src_files)
LOCAL_STATIC_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libvixl
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
LOCAL_MULTILIB := both
include $(BUILD_HOST_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_debug)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_NATIVE_COVERAGE := $(VIXL_COVERAGE)
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_src_files)
LOCAL_STATIC_LIBRARIES := liblog
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libvixld
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
LOCAL_MULTILIB := both
include $(BUILD_HOST_STATIC_LIBRARY)


######### VIXL HOST TESTS #########
#
# We only support 64bit host builds for now.
# To run all the tests: vixl-test-runner --run_all
#
include $(CLEAR_VARS)
LOCAL_CLANG := true
LOCAL_CPP_EXTENSION := .cc
LOCAL_CPPFLAGS := $(vixl_cpp_flags_debug)
LOCAL_CLANG_CFLAGS := -Wimplicit-fallthrough
LOCAL_NATIVE_COVERAGE := $(VIXL_COVERAGE)
LOCAL_C_INCLUDES := $(vixl_include_files)
LOCAL_SRC_FILES :=  $(vixl_test_files) $(vixl_src_files)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_HOST_ARCH := x86_64
LOCAL_FORCE_STATIC_EXECUTABLE := true
LOCAL_MODULE := vixl-test-runner
LOCAL_SANITIZE_RECOVER := shift-exponent
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_HOST_EXECUTABLE)

