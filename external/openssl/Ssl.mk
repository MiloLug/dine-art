local_c_flags :=

local_c_includes := $(log_c_includes)

local_additional_dependencies := $(LOCAL_PATH)/android-config.mk $(LOCAL_PATH)/Ssl.mk

include $(LOCAL_PATH)/Ssl-config.mk

#######################################
# host shared library
include $(CLEAR_VARS)
include $(LOCAL_PATH)/android-config.mk
LOCAL_SRC_FILES += $(host_src_files)
LOCAL_CFLAGS += $(host_c_flags)
LOCAL_C_INCLUDES += $(host_c_includes)
LOCAL_SHARED_LIBRARIES += libcrypto-host $(log_shared_libraries)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE:= libssl-host
LOCAL_ADDITIONAL_DEPENDENCIES := $(local_additional_dependencies)
include $(BUILD_HOST_SHARED_LIBRARY)

#######################################
# ssltest
include $(CLEAR_VARS)
include $(LOCAL_PATH)/android-config.mk
LOCAL_SRC_FILES:= ssl/ssltest.c
LOCAL_C_INCLUDES += $(host_c_includes)
LOCAL_SHARED_LIBRARIES := libssl libcrypto $(log_shared_libraries)
LOCAL_MODULE:= ssltest
LOCAL_MODULE_TAGS := optional
LOCAL_ADDITIONAL_DEPENDENCIES := $(local_additional_dependencies)
include $(BUILD_EXECUTABLE)
