/*
 * Copyright (C) 2026 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */


#ifndef ART_RUNTIME_ARCH_ARM64_ASM_SYMBOLS_ARM64_H_
#define ART_RUNTIME_ARCH_ARM64_ASM_SYMBOLS_ARM64_H_

// Symbol helpers for the arm64 assembly (quick entrypoints and mterp). Mach-O C symbols carry a
// leading underscore and have no .type/.size.
#if defined(__APPLE__)
#define SYMBOL(name) _ ## name
#define ASM_HIDDEN .private_extern
#define FUNCTION_TYPE(name)
#define OBJECT_TYPE(name)
#define SIZE(name)
#else
#define SYMBOL(name) name
#define ASM_HIDDEN .hidden
#define FUNCTION_TYPE(name) .type name, %function
#define OBJECT_TYPE(name) .type name, %object
#define SIZE(name) .size name, .-name
#endif

// Mach-O starts an atom at every label not prefixed with L, and CFI can't advance across atoms;
// these files use .L labels throughout, so Apple builds carry no CFI.
#if defined(__APPLE__)
#define CFI(...)
#else
#define CFI(...) __VA_ARGS__
#endif

#endif  // ART_RUNTIME_ARCH_ARM64_ASM_SYMBOLS_ARM64_H_
