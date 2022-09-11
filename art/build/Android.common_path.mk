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

ifndef ART_ANDROID_COMMON_PATH_MK
ART_ANDROID_COMMON_PATH_MK := true

include art/build/Android.common.mk

# Directory used for dalvik-cache on device.
#ART_TARGET_DALVIK_CACHE_DIR := /data/dalvik-cache

# Directory used for temporary test files on the host.
ifneq ($(TMPDIR),)
ART_HOST_TEST_DIR := $(TMPDIR)/test-art-$(shell echo $$PPID)
else
ART_HOST_TEST_DIR := /tmp/test-art-$(shell echo $$PPID)
endif

# Core.oat location on the device.

CORE_OAT_SUFFIX := .oat

# Core.oat locations under the out directory.
HOST_CORE_OAT_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(ART_HOST_ARCH)/core
ifneq ($(HOST_PREFER_32_BIT),true)
2ND_HOST_CORE_OAT_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(2ND_ART_HOST_ARCH)/core
endif
HOST_CORE_OAT_OUTS :=

CORE_IMG_SUFFIX := .art

# Core.art locations under the out directory.
HOST_CORE_IMG_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(ART_HOST_ARCH)/core
ifneq ($(HOST_PREFER_32_BIT),true)
2ND_HOST_CORE_IMG_OUT_BASE := $(HOST_OUT_JAVA_LIBRARIES)/$(2ND_ART_HOST_ARCH)/core
endif
HOST_CORE_IMG_OUTS :=

# Oat location of core.art.
HOST_CORE_IMG_LOCATION := $(HOST_OUT_JAVA_LIBRARIES)/core.art

# Jar files for core.art.
TARGET_CORE_JARS := core-libart conscrypt okhttp core-junit bouncycastle
HOST_CORE_JARS := $(addsuffix -hostdex,$(TARGET_CORE_JARS))

HOST_CORE_DEX_LOCATIONS   := $(foreach jar,$(HOST_CORE_JARS),  $(HOST_OUT_JAVA_LIBRARIES)/$(jar).jar)

HOST_CORE_DEX_FILES   := $(foreach jar,$(HOST_CORE_JARS),  $(call intermediates-dir-for,JAVA_LIBRARIES,$(jar),t,COMMON)/javalib.jar)

# Classpath for Jack compilation: we only need core-libart.
HOST_JACK_CLASSPATH   := $(abspath $(call intermediates-dir-for,JAVA_LIBRARIES,core-libart-hostdex,t,COMMON)/classes.jack)
endif # ART_ANDROID_COMMON_PATH_MK
