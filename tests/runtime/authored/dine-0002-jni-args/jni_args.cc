// Natives for Main, built as a Linux .so and into the iOS app (JNI_OnLoad renamed to
// JNI_OnLoad_dinejniargs). RegisterNatives keeps Java_Main_* symbols out of the shared iOS binary.

#include <jni.h>

#include <cstring>

namespace {

template <typename T, size_t N>
T Select(const T (&values)[N], jint n) {
  return n >= 0 && static_cast<size_t>(n) < N ? values[n] : T{};
}

jlong Bits(jfloat f) {
  uint32_t bits;
  memcpy(&bits, &f, sizeof(bits));
  return bits;
}

jlong Bits(jdouble d) {
  jlong bits;
  memcpy(&bits, &d, sizeof(bits));
  return bits;
}

#define PARAMS16(T)                                                                         \
  T a0, T a1, T a2, T a3, T a4, T a5, T a6, T a7, T a8, T a9, T a10, T a11, T a12, T a13, \
      T a14, T a15
#define VALUES16 a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15

#define PICK16(Name, Self, T)                          \
  T Name(JNIEnv *, Self, jint n, PARAMS16(T)) {        \
    T values[] = {VALUES16};                           \
    return Select(values, n);                          \
  }

PICK16(PickInt, jclass, jint)
PICK16(PickIntInstance, jobject, jint)
PICK16(PickLong, jclass, jlong)
PICK16(PickFloat, jclass, jfloat)
PICK16(PickDouble, jclass, jdouble)
PICK16(PickByte, jclass, jbyte)
PICK16(PickShort, jclass, jshort)
PICK16(PickChar, jclass, jchar)
PICK16(PickBoolean, jclass, jboolean)
PICK16(PickObject, jclass, jobject)

jlong PickMixed(JNIEnv *, jclass, jint n, jbyte b0, jlong j1, jshort s2, jfloat f3, jchar c4,
                jdouble d5, jboolean z6, jint i7, jbyte b8, jfloat f9, jshort s10, jdouble d11,
                jchar c12, jlong j13, jboolean z14, jfloat f15, jint i16, jdouble d17, jbyte b18,
                jfloat f19, jshort s20, jlong j21, jchar c22, jdouble d23, jfloat f24, jdouble d25,
                jfloat f26, jdouble d27) {
  jlong values[] = {b0,  j1,       s2,  Bits(f3),  c4,       Bits(d5),  z6,       i7,
                    b8,  Bits(f9), s10, Bits(d11), c12,      j13,       z14,      Bits(f15),
                    i16, Bits(d17), b18, Bits(f19), s20,     j21,       c22,      Bits(d23),
                    Bits(f24), Bits(d25), Bits(f26), Bits(d27)};
  return Select(values, n);
}

#define X16(s) s s s s s s s s s s s s s s s s
#define METHOD(name, args, ret, fn) {name, "(I" args ")" ret, reinterpret_cast<void *>(fn)}

const JNINativeMethod kMethods[] = {
    METHOD("pickInt", X16("I"), "I", PickInt),
    METHOD("pickIntInstance", X16("I"), "I", PickIntInstance),
    METHOD("pickLong", X16("J"), "J", PickLong),
    METHOD("pickFloat", X16("F"), "F", PickFloat),
    METHOD("pickDouble", X16("D"), "D", PickDouble),
    METHOD("pickByte", X16("B"), "B", PickByte),
    METHOD("pickShort", X16("S"), "S", PickShort),
    METHOD("pickChar", X16("C"), "C", PickChar),
    METHOD("pickBoolean", X16("Z"), "Z", PickBoolean),
    METHOD("pickObject", X16("Ljava/lang/Object;"), "Ljava/lang/Object;", PickObject),
    METHOD("pickMixed", "BJSFCDZIBFSDCJZFIDBFSJCDFDFD", "J", PickMixed),
};

}  // namespace

JNIEXPORT jint JNI_OnLoad(JavaVM *vm, void *) {
  JNIEnv *env;
  if (vm->GetEnv(reinterpret_cast<void **>(&env), JNI_VERSION_1_6) != JNI_OK) return JNI_ERR;
  jclass main = env->FindClass("Main");
  if (main == nullptr) return JNI_ERR;
  if (env->RegisterNatives(main, kMethods, sizeof(kMethods) / sizeof(kMethods[0])) != JNI_OK) {
    return JNI_ERR;
  }
  return JNI_VERSION_1_6;
}
