/* C API for an embedder that runs several apps in one VM: an app is an opaque tag in its
 * ThreadGroup's embedderTag, which ART copies to every thread that starts in or attaches to it. */
#ifndef ART_EMBEDDER_H
#define ART_EMBEDDER_H

#include <stdbool.h>

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

#ifdef __cplusplus
}
#endif

#endif
