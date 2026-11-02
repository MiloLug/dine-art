// Natives for Main. RegisterNatives keeps Java_Main_* symbols out of a shared binary.

#include <jni.h>
#include <pthread.h>

#include <cstdint>

#include "art_embedder.h"

namespace {

JavaVM *gVm;

jlong ToLong(void *tag) { return static_cast<jlong>(reinterpret_cast<uintptr_t>(tag)); }

void SetTag(JNIEnv *env, jclass, jobject group, jlong tag) {
  jclass cls = env->FindClass("java/lang/ThreadGroup");
  env->SetLongField(group, env->GetFieldID(cls, "embedderTag", "J"), tag);
}

jlong CurrentTag(JNIEnv *, jclass) { return ToLong(art_thread_embedder_tag()); }

struct Attach {
  jobject group;
  jlong tag;
};

void *AttachAndRead(void *arg) {
  Attach *attach = static_cast<Attach *>(arg);
  JavaVMAttachArgs args{JNI_VERSION_1_6, const_cast<char *>("attached"), attach->group};
  JNIEnv *env;
  if (gVm->AttachCurrentThread(&env, &args) != JNI_OK) {
    attach->tag = -1;
    return nullptr;
  }
  attach->tag = ToLong(art_thread_embedder_tag());
  gVm->DetachCurrentThread();
  return nullptr;
}

jlong AttachedTag(JNIEnv *env, jclass, jobject group) {
  Attach attach{group != nullptr ? env->NewGlobalRef(group) : nullptr, 0};
  pthread_t thread;
  if (pthread_create(&thread, nullptr, AttachAndRead, &attach) != 0) return -1;
  pthread_join(thread, nullptr);
  if (attach.group != nullptr) env->DeleteGlobalRef(attach.group);
  return attach.tag;
}

jboolean SetAttachGroup(JNIEnv *env, jclass, jobject group) {
  return art_set_default_attach_group(env, group);
}

jboolean JoinGroup(JNIEnv *env, jclass, jobject group) {
  return art_join_thread_group(env, group);
}

const JNINativeMethod kMethods[] = {
    {const_cast<char *>("setTag"), const_cast<char *>("(Ljava/lang/ThreadGroup;J)V"),
     reinterpret_cast<void *>(SetTag)},
    {const_cast<char *>("currentTag"), const_cast<char *>("()J"),
     reinterpret_cast<void *>(CurrentTag)},
    {const_cast<char *>("attachedTag"), const_cast<char *>("(Ljava/lang/ThreadGroup;)J"),
     reinterpret_cast<void *>(AttachedTag)},
    {const_cast<char *>("setAttachGroup"), const_cast<char *>("(Ljava/lang/ThreadGroup;)Z"),
     reinterpret_cast<void *>(SetAttachGroup)},
    {const_cast<char *>("joinGroup"), const_cast<char *>("(Ljava/lang/ThreadGroup;)Z"),
     reinterpret_cast<void *>(JoinGroup)},
};

}  // namespace

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *) {
  gVm = vm;
  JNIEnv *env;
  if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK) return JNI_ERR;
  jclass main = env->FindClass("Main");
  if (main == nullptr) return JNI_ERR;
  if (env->RegisterNatives(main, kMethods, sizeof(kMethods) / sizeof(kMethods[0])) != JNI_OK) {
    return JNI_ERR;
  }
  return JNI_VERSION_1_6;
}
