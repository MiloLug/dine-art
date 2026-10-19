
# Definitions for building the wolfSSL JNI library and native code

LOCAL_PATH := $(call my-dir)

javac_flags:=-Xmaxwarns 9999999

# Create the wolfSSL JNI library
include $(CLEAR_VARS)

# Source file list to compile, exclude WolfSSLJDK8Helper on older Android
# versions (ex: 23) that do not have newer SSLParameters methods (i.e. SNI)
# TODO: does this check work in our case?
#LOCAL_SRC_EXCLUDES :=
#ifeq ($(PLATFORM_VERSION),6.0.1)
LOCAL_SRC_EXCLUDES := \
    src/java/com/wolfssl/provider/jsse/adapter/WolfSSLJDK8Helper.java
#endif
LOCAL_SRC_FILES := $(call all-java-files-under,src/java)
LOCAL_SRC_FILES := $(filter-out $(LOCAL_SRC_EXCLUDES), $(LOCAL_SRC_FILES))

LOCAL_JAVACFLAGS := $(javac_flags)
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := wolfssljni-hostdex
LOCAL_REQUIRED_MODULES := libwolfssljni
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
LOCAL_JAVA_LIBRARIES := core-libart-hostdex
include $(BUILD_HOST_DALVIK_JAVA_LIBRARY)

# Create wolfSSL JNI native library
include $(CLEAR_VARS)
# __ANDROID__: rely on libcore implementation details, not the JDK's. No feature defines: the
# sources include the library's own wolfssl/options.h, and extra ones would change struct layouts.
LOCAL_CFLAGS := -D__ANDROID__ -Os
# the app links every JNI library, so JNI_OnLoad gets the JEP 178 name
ifeq ($(HOST_OS),darwin)
LOCAL_CFLAGS += -DJNI_OnLoad=JNI_OnLoad_wolfssljni
endif
LOCAL_SRC_FILES := \
    native/com_wolfssl_wolfcrypt_ECC.c \
    native/com_wolfssl_wolfcrypt_EccKey.c \
    native/com_wolfssl_wolfcrypt_RSA.c \
    native/com_wolfssl_WolfSSL.c \
    native/com_wolfssl_WolfSSLCertificate.c \
    native/com_wolfssl_WolfSSLCertManager.c \
    native/com_wolfssl_WolfSSLContext.c \
    native/com_wolfssl_WolfSSLSession.c \
    native/com_wolfssl_WolfSSLX509StoreCtx.c
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/native \
    external/wolfssl
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/native
LOCAL_LDLIBS := -lwolfssl
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE := libwolfssljni
LOCAL_ADDITIONAL_DEPENDENCIES := $(LOCAL_PATH)/Android.mk
include $(BUILD_HOST_SHARED_LIBRARY)

# Clear local variables
javac_flags :=

