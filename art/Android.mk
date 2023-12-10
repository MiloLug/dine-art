LOCAL_PATH := $(call my-dir)
art_path := $(LOCAL_PATH)
include $(art_path)/benchmark/Android.mk
include $(art_path)/build/Android.mk
include $(art_path)/cmdline/Android.mk
include $(art_path)/compiler/Android.mk
include $(art_path)/dalvikvm/Android.mk
include $(art_path)/dex2oat/Android.mk
include $(art_path)/dexdump/Android.mk
include $(art_path)/dexlayout/Android.mk
include $(art_path)/dexlist/Android.mk
include $(art_path)/dexoptanalyzer/Android.mk
include $(art_path)/disassembler/Android.mk
include $(art_path)/imgdiag/Android.mk
include $(art_path)/oatdump/Android.mk
include $(art_path)/patchoat/Android.mk
include $(art_path)/profman/Android.mk
include $(art_path)/runtime/Android.mk
include $(art_path)/sigchainlib/Android.mk
include $(art_path)/tools/cpp-define-generator/Android.mk
include $(art_path)/tools/dmtracedump/Android.mk
