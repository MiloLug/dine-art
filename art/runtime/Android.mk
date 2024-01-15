LOCAL_PATH := $(call my-dir)
art_operator_srcs_SRCS     =  \
        arch/instruction_set.h \
        base/mutex.h \
        class_status.h \
        debugger.h \
        gc_root.h \
        gc/allocator_type.h \
        gc/allocator/rosalloc.h \
        gc/collector_type.h \
        gc/collector/gc_type.h \
        gc/heap.h \
        gc/space/region_space.h \
        gc/space/space.h \
        gc/weak_root_state.h \
        image.h \
        instrumentation.h \
        indirect_reference_table.h \
        jdwp_provider.h \
        jdwp/jdwp.h \
        jdwp/jdwp_constants.h \
        lock_word.h \
        oat.h \
        object_callbacks.h \
        process_state.h \
        stack.h \
        suspend_reason.h \
        thread.h \
        thread_state.h \
        ti/agent.h \
        verifier/verifier_enums.h
define art_operator_srcs_GENERATED_SOURCES
GENERATED_SRC_DIR = $(call local-generated-sources-dir)
art_operator_srcs_GEN = $$(addprefix $$(GENERATED_SRC_DIR)/,$(addsuffix _operator_out.cc,$(art_operator_srcs_SRCS)))

$$(art_operator_srcs_GEN): PRIVATE_CUSTOM_TOOL = art/tools/generate_operator_out.py art/runtime $$< > $$@
$$(art_operator_srcs_GEN): $$(GENERATED_SRC_DIR)/%_operator_out.cc : $(LOCAL_PATH)/%
	$$(transform-generated-source)
LOCAL_GENERATED_SOURCES += $$(art_operator_srcs_GEN)

endef

libart_defaults_arm_SRCS     =  \
        interpreter/mterp/mterp.cc \
        interpreter/mterp/out/mterp_arm.S \
        arch/arm/context_arm.cc \
        arch/arm/entrypoints_init_arm.cc \
        arch/arm/instruction_set_features_assembly_tests.S \
        arch/arm/jni_entrypoints_arm.S \
        arch/arm/memcmp16_arm.S \
        arch/arm/quick_entrypoints_arm.S \
        arch/arm/quick_entrypoints_cc_arm.cc \
        arch/arm/thread_arm.cc \
        arch/arm/fault_handler_arm.cc
libart_defaults_arm_HOST_LDLIBS = -latomic
libart_defaults_arm64_SRCS     =  \
        interpreter/mterp/mterp.cc \
        interpreter/mterp/out/mterp_arm64.S \
        arch/arm64/context_arm64.cc \
        arch/arm64/entrypoints_init_arm64.cc \
        arch/arm64/jni_entrypoints_arm64.S \
        arch/arm64/memcmp16_arm64.S \
        arch/arm64/quick_entrypoints_arm64.S \
        arch/arm64/thread_arm64.cc \
        monitor_pool.cc \
        arch/arm64/fault_handler_arm64.cc
libart_defaults_arm64_HOST_LDLIBS = -latomic
libart_defaults_x86_SRCS     =  \
        interpreter/mterp/mterp.cc \
        interpreter/mterp/out/mterp_x86.S \
        arch/x86/context_x86.cc \
        arch/x86/entrypoints_init_x86.cc \
        arch/x86/jni_entrypoints_x86.S \
        arch/x86/memcmp16_x86.S \
        arch/x86/quick_entrypoints_x86.S \
        arch/x86/thread_x86.cc \
        arch/x86/fault_handler_x86.cc
libart_defaults_x86_64_SRCS     =  \
        interpreter/mterp/mterp.cc \
        interpreter/mterp/out/mterp_x86_64.S \
        arch/x86_64/context_x86_64.cc \
        arch/x86_64/entrypoints_init_x86_64.cc \
        arch/x86_64/jni_entrypoints_x86_64.S \
        arch/x86_64/memcmp16_x86_64.S \
        arch/x86_64/quick_entrypoints_x86_64.S \
        arch/x86_64/thread_x86_64.cc \
        monitor_pool.cc \
        arch/x86/fault_handler_x86.cc
libart_defaults_mips_SRCS     =  \
        interpreter/mterp/mterp.cc \
        interpreter/mterp/out/mterp_mips.S \
        arch/mips/context_mips.cc \
        arch/mips/entrypoints_init_mips.cc \
        arch/mips/jni_entrypoints_mips.S \
        arch/mips/memcmp16_mips.S \
        arch/mips/quick_entrypoints_mips.S \
        arch/mips/thread_mips.cc \
        arch/mips/fault_handler_mips.cc
libart_defaults_mips64_SRCS     =  \
        interpreter/mterp/mterp.cc \
        interpreter/mterp/out/mterp_mips64.S \
        arch/mips64/context_mips64.cc \
        arch/mips64/entrypoints_init_mips64.cc \
        arch/mips64/jni_entrypoints_mips64.S \
        arch/mips64/memcmp16_mips64.S \
        arch/mips64/quick_entrypoints_mips64.S \
        arch/mips64/thread_mips64.cc \
        monitor_pool.cc \
        arch/mips64/fault_handler_mips64.cc
libart_defaults_CFLAGS   = -DBUILDING_LIBART=1
libart_defaults_LDLIBS   =  \
        $(libart_defaults_$(HOST_ARCH)_HOST_LDLIBS) \
        -lz \
        -llz4 \
        -ldl_bio
libart_defaults_SHARED_LIBS =  \
        libziparchive \
        libnativebridge \
        libbacktrace \
        liblog \
        libcutils \
        libbase \
        libsigchain
libart_defaults_SRCS     =  \
        $(libart_defaults_$(HOST_ARCH)_SRCS) \
        monitor_linux.cc \
        runtime_linux.cc \
        thread_linux.cc \
        aot_class_linker.cc \
        art_field.cc \
        art_method.cc \
        barrier.cc \
        base/arena_allocator.cc \
        base/arena_bit_vector.cc \
        base/file_utils.cc \
        base/mutex.cc \
        base/quasi_atomic.cc \
        base/scoped_arena_allocator.cc \
        base/timing_logger.cc \
        cha.cc \
        check_jni.cc \
        class_linker.cc \
        class_loader_context.cc \
        class_table.cc \
        common_throws.cc \
        compiler_filter.cc \
        debug_print.cc \
        debugger.cc \
        dex/art_dex_file_loader.cc \
        dex/dex_file_annotations.cc \
        dex_to_dex_decompiler.cc \
        elf_file.cc \
        exec_utils.cc \
        fault_handler.cc \
        gc/allocation_record.cc \
        gc/allocator/dlmalloc.cc \
        gc/allocator/rosalloc.cc \
        gc/accounting/bitmap.cc \
        gc/accounting/card_table.cc \
        gc/accounting/heap_bitmap.cc \
        gc/accounting/mod_union_table.cc \
        gc/accounting/remembered_set.cc \
        gc/accounting/space_bitmap.cc \
        gc/collector/concurrent_copying.cc \
        gc/collector/garbage_collector.cc \
        gc/collector/immune_region.cc \
        gc/collector/immune_spaces.cc \
        gc/collector/mark_compact.cc \
        gc/collector/mark_sweep.cc \
        gc/collector/partial_mark_sweep.cc \
        gc/collector/semi_space.cc \
        gc/collector/sticky_mark_sweep.cc \
        gc/gc_cause.cc \
        gc/heap.cc \
        gc/reference_processor.cc \
        gc/reference_queue.cc \
        gc/scoped_gc_critical_section.cc \
        gc/space/bump_pointer_space.cc \
        gc/space/dlmalloc_space.cc \
        gc/space/image_space.cc \
        gc/space/large_object_space.cc \
        gc/space/malloc_space.cc \
        gc/space/region_space.cc \
        gc/space/rosalloc_space.cc \
        gc/space/space.cc \
        gc/space/zygote_space.cc \
        gc/task_processor.cc \
        gc/verification.cc \
        hidden_api.cc \
        hprof/hprof.cc \
        image.cc \
        index_bss_mapping.cc \
        indirect_reference_table.cc \
        instrumentation.cc \
        intern_table.cc \
        interpreter/interpreter.cc \
        interpreter/interpreter_common.cc \
        interpreter/interpreter_intrinsics.cc \
        interpreter/interpreter_switch_impl.cc \
        interpreter/lock_count_data.cc \
        interpreter/shadow_frame.cc \
        interpreter/unstarted_runtime.cc \
        java_frame_root_info.cc \
        java_vm_ext.cc \
        jdwp/jdwp_event.cc \
        jdwp/jdwp_expand_buf.cc \
        jdwp/jdwp_handler.cc \
        jdwp/jdwp_main.cc \
        jdwp/jdwp_request.cc \
        jdwp/jdwp_socket.cc \
        jdwp/object_registry.cc \
        jni_env_ext.cc \
        jit/debugger_interface.cc \
        jit/jit.cc \
        jit/jit_code_cache.cc \
        jit/profile_compilation_info.cc \
        jit/profiling_info.cc \
        jit/profile_saver.cc \
        jni_internal.cc \
        jobject_comparator.cc \
        linear_alloc.cc \
        managed_stack.cc \
        mem_map.cc \
        memory_region.cc \
        method_handles.cc \
        mirror/array.cc \
        mirror/call_site.cc \
        mirror/class.cc \
        mirror/class_ext.cc \
        mirror/dex_cache.cc \
        mirror/emulated_stack_frame.cc \
        mirror/executable.cc \
        mirror/field.cc \
        mirror/method.cc \
        mirror/method_handle_impl.cc \
        mirror/method_handles_lookup.cc \
        mirror/method_type.cc \
        mirror/object.cc \
        mirror/reference.cc \
        mirror/stack_trace_element.cc \
        mirror/string.cc \
        mirror/throwable.cc \
        mirror/var_handle.cc \
        monitor.cc \
        native_bridge_art_interface.cc \
        native_stack_dump.cc \
        native/dalvik_system_DexFile.cc \
        native/dalvik_system_VMDebug.cc \
        native/dalvik_system_VMRuntime.cc \
        native/dalvik_system_VMStack.cc \
        native/dalvik_system_ZygoteHooks.cc \
        native/java_lang_Class.cc \
        native/java_lang_Object.cc \
        native/java_lang_String.cc \
        native/java_lang_StringFactory.cc \
        native/java_lang_System.cc \
        native/java_lang_Thread.cc \
        native/java_lang_Throwable.cc \
        native/java_lang_VMClassLoader.cc \
        native/java_lang_invoke_MethodHandleImpl.cc \
        native/java_lang_ref_FinalizerReference.cc \
        native/java_lang_ref_Reference.cc \
        native/java_lang_reflect_Array.cc \
        native/java_lang_reflect_Constructor.cc \
        native/java_lang_reflect_Executable.cc \
        native/java_lang_reflect_Field.cc \
        native/java_lang_reflect_Method.cc \
        native/java_lang_reflect_Parameter.cc \
        native/java_lang_reflect_Proxy.cc \
        native/java_util_concurrent_atomic_AtomicLong.cc \
        native/libcore_util_CharsetUtils.cc \
        native/org_apache_harmony_dalvik_ddmc_DdmServer.cc \
        native/org_apache_harmony_dalvik_ddmc_DdmVmInternal.cc \
        native/sun_misc_Unsafe.cc \
        non_debuggable_classes.cc \
        oat.cc \
        oat_file.cc \
        oat_file_assistant.cc \
        oat_file_manager.cc \
        oat_quick_method_header.cc \
        object_lock.cc \
        offsets.cc \
        parsed_options.cc \
        plugin.cc \
        quick_exception_handler.cc \
        read_barrier.cc \
        reference_table.cc \
        reflection.cc \
        runtime.cc \
        runtime_callbacks.cc \
        runtime_common.cc \
        runtime_intrinsics.cc \
        runtime_options.cc \
        scoped_thread_state_change.cc \
        signal_catcher.cc \
        stack.cc \
        stack_map.cc \
        thread.cc \
        thread_list.cc \
        thread_pool.cc \
        ti/agent.cc \
        trace.cc \
        transaction.cc \
        type_lookup_table.cc \
        vdex_file.cc \
        verifier/instruction_flags.cc \
        verifier/method_verifier.cc \
        verifier/reg_type.cc \
        verifier/reg_type_cache.cc \
        verifier/register_line.cc \
        verifier/verifier_deps.cc \
        verify_object.cc \
        well_known_classes.cc \
        zip_archive.cc \
        arch/context.cc \
        arch/instruction_set.cc \
        arch/instruction_set_features.cc \
        arch/memcmp16.cc \
        arch/arm/instruction_set_features_arm.cc \
        arch/arm/registers_arm.cc \
        arch/arm64/instruction_set_features_arm64.cc \
        arch/arm64/registers_arm64.cc \
        arch/mips/instruction_set_features_mips.cc \
        arch/mips/registers_mips.cc \
        arch/mips64/instruction_set_features_mips64.cc \
        arch/mips64/registers_mips64.cc \
        arch/x86/instruction_set_features_x86.cc \
        arch/x86/registers_x86.cc \
        arch/x86_64/registers_x86_64.cc \
        entrypoints/entrypoint_utils.cc \
        entrypoints/jni/jni_entrypoints.cc \
        entrypoints/math_entrypoints.cc \
        entrypoints/quick/quick_alloc_entrypoints.cc \
        entrypoints/quick/quick_cast_entrypoints.cc \
        entrypoints/quick/quick_deoptimization_entrypoints.cc \
        entrypoints/quick/quick_dexcache_entrypoints.cc \
        entrypoints/quick/quick_entrypoints_enum.cc \
        entrypoints/quick/quick_field_entrypoints.cc \
        entrypoints/quick/quick_fillarray_entrypoints.cc \
        entrypoints/quick/quick_jni_entrypoints.cc \
        entrypoints/quick/quick_lock_entrypoints.cc \
        entrypoints/quick/quick_math_entrypoints.cc \
        entrypoints/quick/quick_thread_entrypoints.cc \
        entrypoints/quick/quick_throw_entrypoints.cc \
        entrypoints/quick/quick_trampoline_entrypoints.cc
libart_defaults_INCLUDE_DIRS =  \
        art/sigchainlib \
        external/icu/icu4c/source/common \
        external/lz4/lib \
        external/zlib \
        $(LOCAL_PATH)/generated
libart_defaults_EXPORT_INCLUDE_DIRS = $(LOCAL_PATH)/.
libart_defaults_GENERATED_SOURCES =  \
        $(libart_defaults_$(HOST_ARCH)_GENERATED_SOURCES) \
        $(art_operator_srcs_GENERATED_SOURCES)

include art/build/Android.common_build.mk
# link libart shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libart
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libdexfile \
        $(libart_defaults_SHARED_LIBS)
LOCAL_WHOLE_STATIC_LIBRARIES = libartbase
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libart static library
include $(CLEAR_VARS)
LOCAL_MODULE := libart
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libdexfile \
        $(libart_defaults_SHARED_LIBS)
LOCAL_WHOLE_STATIC_LIBRARIES = libartbase
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libartd shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libartd
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libdexfiled \
        $(libart_defaults_SHARED_LIBS)
LOCAL_WHOLE_STATIC_LIBRARIES = libartbased
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_SHARED_LIBRARY)

# link libartd static library
include $(CLEAR_VARS)
LOCAL_MODULE := libartd
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CXXFLAGS = $(libart_defaults_CXXFLAGS)
LOCAL_CFLAGS   =  \
        $(libart_defaults_CFLAGS) \
        $(ART_HOST_CFLAGS)
LOCAL_LDFLAGS  = $(libart_defaults_LDFLAGS)
LOCAL_LDLIBS   = $(libart_defaults_LDLIBS)
LOCAL_SRC_FILES = $(libart_defaults_SRCS)
LOCAL_SHARED_LIBRARIES =  \
        libdexfiled \
        $(libart_defaults_SHARED_LIBS)
LOCAL_WHOLE_STATIC_LIBRARIES = libartbased
LOCAL_EXPORT_C_INCLUDE_DIRS = $(libart_defaults_EXPORT_INCLUDE_DIRS)
LOCAL_C_INCLUDES =  \
        $(libart_defaults_INCLUDE_DIRS) \
        $(ART_C_INCLUDES)
LOCAL_CPP_EXTENSION = .cc
$(eval $(libart_defaults_GENERATED_SOURCES))
include $(BUILD_HOST_STATIC_LIBRARY)

include art/build/Android.common_build.mk
# link libart-runtime-gtest shared library
include $(CLEAR_VARS)
LOCAL_MODULE := libart-runtime-gtest
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS   = $(ART_HOST_CFLAGS)
LOCAL_SRC_FILES =  \
        common_runtime_test.cc \
        dexopt_test.cc
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        libbase \
        libbacktrace
LOCAL_C_INCLUDES =  \
        $(ART_C_INCLUDES) \
        external/icu/icu4c/source/common
LOCAL_CPP_EXTENSION = .cc
include $(BUILD_HOST_SHARED_LIBRARY)

# link libart-runtime-gtest static library
include $(CLEAR_VARS)
LOCAL_MODULE := libart-runtime-gtest
LOCAL_MODULE_CLASS := STATIC_LIBRARIES
LOCAL_IS_HOST_MODULE := true
LOCAL_CFLAGS   = $(ART_HOST_CFLAGS)
LOCAL_SRC_FILES =  \
        common_runtime_test.cc \
        dexopt_test.cc
LOCAL_SHARED_LIBRARIES =  \
        libartd \
        libbase \
        libbacktrace
LOCAL_C_INCLUDES =  \
        $(ART_C_INCLUDES) \
        external/icu/icu4c/source/common
LOCAL_CPP_EXTENSION = .cc
include $(BUILD_HOST_STATIC_LIBRARY)

