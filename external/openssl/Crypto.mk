local_c_flags :=

local_c_includes := $(log_c_includes)

local_additional_dependencies := $(LOCAL_PATH)/android-config.mk $(LOCAL_PATH)/Crypto.mk

include $(LOCAL_PATH)/Crypto-config.mk

#######################################
# host shared library
include $(CLEAR_VARS)
include $(LOCAL_PATH)/android-config.mk
LOCAL_SHARED_LIBRARIES := $(log_shared_libraries)
LOCAL_SRC_FILES += $(host_src_files)
LOCAL_CFLAGS += $(host_c_flags) -DPURIFY
LOCAL_C_INCLUDES += $(host_c_includes)
LOCAL_LDLIBS += -ldl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE:= libcrypto-host
LOCAL_ADDITIONAL_DEPENDENCIES := $(local_additional_dependencies)
include $(BUILD_HOST_SHARED_LIBRARY)

########################################
# host static library, which is used by some SDK tools.

include $(CLEAR_VARS)
include $(LOCAL_PATH)/android-config.mk
LOCAL_SHARED_LIBRARIES := $(log_shared_libraries)
LOCAL_SRC_FILES += $(host_src_files)
LOCAL_CFLAGS += $(host_c_flags) -DPURIFY
LOCAL_C_INCLUDES += $(host_c_includes)
LOCAL_LDLIBS += -ldl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE:= libcrypto_static
LOCAL_ADDITIONAL_DEPENDENCIES := $(local_additional_dependencies)
include $(BUILD_HOST_STATIC_LIBRARY)
