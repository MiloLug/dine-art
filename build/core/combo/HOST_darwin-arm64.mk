#
# Copyright (C) 2006 The Android Open Source Project
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

# Configuration for ____TARGET=ios (envsetup.mk): arm64-apple-ios, cross-compiled on Linux with
# clang and the iPhoneOS SDK. Included by combo/select.mk.

ifeq ($(strip $(____IOS_SDK)),)
$(error ____TARGET=ios needs ____IOS_SDK=<iPhoneOS.sdk> and ____IOS_MIN=<deployment target>)
endif

HOST_CC  := clang -target arm64-apple-ios$(____IOS_MIN) -isysroot $(____IOS_SDK)
HOST_CXX := clang++ -target arm64-apple-ios$(____IOS_MIN) -isysroot $(____IOS_SDK)
HOST_AR  := llvm-ar

# Third-party iOS libraries (ICU, lz4, liblzma, wolfSSL) installed into the prefix. -isystem is
# searched before the SDK, whose usr/include/unicode is a C-only ICU.
HOST_GLOBAL_CFLAGS += -isystem $(____PREFIX)/include \
  -include $(call select-android-config-h,darwin-arm64)

# Darwin has no <elf.h>; this is musl v1.2.6's.
HOST_GLOBAL_CFLAGS += -isystem external/musl/include

# TODO: Set _FORTIFY_SOURCE=2. Bug 20558757.
HOST_GLOBAL_CFLAGS += -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=0 -fstack-protector

# Workaround differences in inttypes.h between host and target.
# See bug 12708004.
HOST_GLOBAL_CFLAGS += -D__STDC_FORMAT_MACROS -D__STDC_CONSTANT_MACROS

# The Linux build's gcc defaults to C23; clang still defaults to C17.
HOST_GLOBAL_CONLYFLAGS += -std=gnu23

# The tree was last built warning-free by gcc and by a 2019 clang, not by this one.
HOST_GLOBAL_CFLAGS += -Wno-unknown-warning-option
HOST_GLOBAL_UNSUPPORTED_CFLAGS += -Werror

# Everything links into the iOS app: shared-library modules are archived instead of linked.
HOST_SHLIB_SUFFIX := .a
HOST_CUSTOM_LD_COMMAND := true
define transform-host-o-to-shared-lib-inner
@rm -f $@
$(extract-and-include-host-whole-static-libs)
$(call split-long-arguments,$(HOST_AR) $(HOST_GLOBAL_ARFLAGS) $(PRIVATE_ARFLAGS) $@,$(PRIVATE_ALL_OBJECTS))
endef

# $(1): The file to check
define get-file-size
stat --format "%s" "$(1)" | tr -d '\n'
endef
