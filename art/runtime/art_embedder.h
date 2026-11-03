/* C API for an embedder that runs several apps in one VM: an app is an opaque tag in its
 * ThreadGroup's embedderTag, which ART copies to every thread that starts in or attaches to it. */
#ifndef ART_EMBEDDER_H
#define ART_EMBEDDER_H

#include <stdbool.h>
#include <stddef.h>

#include <jni.h>

#ifdef __cplusplus
extern "C" {
#endif

/* The calling thread's tag, NULL for none or an unattached thread. Async-signal-safe. */
void *art_thread_embedder_tag(void);

/* Moves the calling attached thread into group and takes group's tag. False with the Java
 * exception pending when the move fails. */
bool art_join_thread_group(JNIEnv *env, jobject group);

/* Threads that attach through JNI without a group join this one instead of the main group. Set
 * once per VM: false, and nothing changes, on a second call. */
bool art_set_default_attach_group(JNIEnv *env, jobject group);

/* The Java_* names the native library (its file's stem: "javacore" for libjavacore.so) may
 * resolve, replacing an earlier list; names are copied. Any time, also before the VM. On Apple,
 * where every library is the app's image, a library without a list resolves none. */
void art_register_jni_symbols(const char *library, const char *const *names, size_t count);

#ifdef __cplusplus
}
#endif

#endif
