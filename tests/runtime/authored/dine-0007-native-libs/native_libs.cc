// Natives for Main and Second, found by their Java_* names: the lookup is what the test checks.

#include <jni.h>

#include "art_embedder.h"

extern "C" JNIEXPORT jint JNICALL Java_Main_value(JNIEnv *, jclass) { return 1; }

extern "C" JNIEXPORT jint JNICALL Java_Second_value(JNIEnv *, jclass) { return 2; }

extern "C" JNIEXPORT void JNICALL Java_Main_registerList(JNIEnv *, jclass) {
  static const char *const names[] = {"Java_Main_listed"};
  art_register_jni_symbols("nativelibs", names, 1);
}

extern "C" JNIEXPORT jint JNICALL Java_Main_listed(JNIEnv *, jclass) { return 3; }

extern "C" JNIEXPORT jint JNICALL Java_Main_unlisted(JNIEnv *, jclass) { return 4; }
