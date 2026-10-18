/*
 * Copyright (C) 2014 The Android Open Source Project
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

#include "fault_handler.h"

#include <sys/ucontext.h>

#include "arch/instruction_set.h"
#include "art_method.h"
#include "base/enums.h"
#include "base/hex_dump.h"
#include "base/logging.h"  // For VLOG.
#include "base/macros.h"
#include "registers_arm64.h"
#include "runtime_globals.h"
#include "thread-current-inl.h"

#if defined(__APPLE__)
#define ucontext __darwin_ucontext
#define CTX_SP uc_mcontext->__ss.__sp
#define CTX_PC uc_mcontext->__ss.__pc
#define CTX_X0 uc_mcontext->__ss.__x[0]
#define CTX_LR uc_mcontext->__ss.__lr
#define CTX_FAULT_ADDRESS uc_mcontext->__es.__far
#else
#ifdef __GLIBC__
#define ucontext ucontext_t
#endif
// glibc's and bionic's uc_mcontext have the kernel's struct sigcontext fields.
#define CTX_SP uc_mcontext.sp
#define CTX_PC uc_mcontext.pc
#define CTX_X0 uc_mcontext.regs[0]
#define CTX_LR uc_mcontext.regs[30]
#define CTX_FAULT_ADDRESS uc_mcontext.fault_address
#endif

extern "C" void art_quick_throw_stack_overflow();
extern "C" void art_quick_throw_null_pointer_exception_from_signal();
extern "C" void art_quick_implicit_suspend();

//
// ARM64 specific fault handler functions.
//

namespace art {

void FaultManager::GetMethodAndReturnPcAndSp(siginfo_t* siginfo ATTRIBUTE_UNUSED, void* context,
                                             ArtMethod** out_method,
                                             uintptr_t* out_return_pc, uintptr_t* out_sp) {
  struct ucontext *uc = reinterpret_cast<struct ucontext *>(context);
  *out_sp = static_cast<uintptr_t>(uc->CTX_SP);
  VLOG(signals) << "sp: " << *out_sp;
  if (*out_sp == 0) {
    return;
  }

  // In the case of a stack overflow, the stack is not valid and we can't
  // get the method from the top of the stack.  However it's in x0.
  uintptr_t* fault_addr = reinterpret_cast<uintptr_t*>(uc->CTX_FAULT_ADDRESS);
  uintptr_t* overflow_addr = reinterpret_cast<uintptr_t*>(
      reinterpret_cast<uint8_t*>(*out_sp) - GetStackOverflowReservedBytes(InstructionSet::kArm64));
  if (overflow_addr == fault_addr) {
    *out_method = reinterpret_cast<ArtMethod*>(uc->CTX_X0);
  } else {
    // The method is at the top of the stack.
    *out_method = *reinterpret_cast<ArtMethod**>(*out_sp);
  }

  // Work out the return PC.  This will be the address of the instruction
  // following the faulting ldr/str instruction.
  VLOG(signals) << "pc: " << std::hex
      << static_cast<void*>(reinterpret_cast<uint8_t*>(uc->CTX_PC));

  *out_return_pc = uc->CTX_PC + 4;
}

bool NullPointerHandler::Action(int sig ATTRIBUTE_UNUSED, siginfo_t* info, void* context) {
  if (!IsValidImplicitCheck(info)) {
    return false;
  }
  // The code that looks for the catch location needs to know the value of the
  // PC at the point of call.  For Null checks we insert a GC map that is immediately after
  // the load/store instruction that might cause the fault.

  struct ucontext *uc = reinterpret_cast<struct ucontext*>(context);

  // Push the gc map location to the stack and pass the fault address in LR.
  uc->CTX_SP -= sizeof(uintptr_t);
  *reinterpret_cast<uintptr_t*>(uc->CTX_SP) = uc->CTX_PC + 4;
  uc->CTX_LR = reinterpret_cast<uintptr_t>(info->si_addr);

  uc->CTX_PC = reinterpret_cast<uintptr_t>(art_quick_throw_null_pointer_exception_from_signal);
  VLOG(signals) << "Generating null pointer exception";
  return true;
}

// A suspend check is done using the following instruction sequence:
//      0xf7223228: f9405640  ldr x0, [x18, #168]
// .. some intervening instructions
//      0xf7223230: f9400000  ldr x0, [x0]

// The offset from r18 is Thread::ThreadSuspendTriggerOffset().
// To check for a suspend check, we examine the instructions that caused
// the fault (at PC-4 and PC).
bool SuspensionHandler::Action(int sig ATTRIBUTE_UNUSED, siginfo_t* info ATTRIBUTE_UNUSED,
                               void* context) {
  // These are the instructions to check for.  The first one is the ldr x0,[r18,#xxx]
  // where xxx is the offset of the suspend trigger.
  uint32_t checkinst1 = 0xf9400240 |
      (Thread::ThreadSuspendTriggerOffset<PointerSize::k64>().Int32Value() << 7);
  uint32_t checkinst2 = 0xf9400000;

  struct ucontext *uc = reinterpret_cast<struct ucontext *>(context);
  uint8_t* ptr2 = reinterpret_cast<uint8_t*>(uc->CTX_PC);
  uint8_t* ptr1 = ptr2 - 4;
  VLOG(signals) << "checking suspend";

  uint32_t inst2 = *reinterpret_cast<uint32_t*>(ptr2);
  VLOG(signals) << "inst2: " << std::hex << inst2 << " checkinst2: " << checkinst2;
  if (inst2 != checkinst2) {
    // Second instruction is not good, not ours.
    return false;
  }

  // The first instruction can a little bit up the stream due to load hoisting
  // in the compiler.
  uint8_t* limit = ptr1 - 80;   // Compiler will hoist to a max of 20 instructions.
  bool found = false;
  while (ptr1 > limit) {
    uint32_t inst1 = *reinterpret_cast<uint32_t*>(ptr1);
    VLOG(signals) << "inst1: " << std::hex << inst1 << " checkinst1: " << checkinst1;
    if (inst1 == checkinst1) {
      found = true;
      break;
    }
    ptr1 -= 4;
  }
  if (found) {
    VLOG(signals) << "suspend check match";
    // This is a suspend check.  Arrange for the signal handler to return to
    // art_quick_implicit_suspend.  Also set LR so that after the suspend check it
    // will resume the instruction (current PC + 4).  PC points to the
    // ldr x0,[x0,#0] instruction (r0 will be 0, set by the trigger).

    uc->CTX_LR = uc->CTX_PC + 4;
    uc->CTX_PC = reinterpret_cast<uintptr_t>(art_quick_implicit_suspend);

    // Now remove the suspend trigger that caused this fault.
    Thread::Current()->RemoveSuspendTrigger();
    VLOG(signals) << "removed suspend trigger invoking test suspend";
    return true;
  }
  return false;
}

bool StackOverflowHandler::Action(int sig ATTRIBUTE_UNUSED, siginfo_t* info ATTRIBUTE_UNUSED,
                                  void* context) {
  struct ucontext *uc = reinterpret_cast<struct ucontext *>(context);
  VLOG(signals) << "stack overflow handler with sp at " << std::hex << &uc;
  VLOG(signals) << "ucontext: " << std::hex << uc;

  uintptr_t sp = uc->CTX_SP;
  VLOG(signals) << "sp: " << std::hex << sp;

  uintptr_t fault_addr = uc->CTX_FAULT_ADDRESS;
  VLOG(signals) << "fault_addr: " << std::hex << fault_addr;
  VLOG(signals) << "checking for stack overflow, sp: " << std::hex << sp <<
      ", fault_addr: " << fault_addr;

  uintptr_t overflow_addr = sp - GetStackOverflowReservedBytes(InstructionSet::kArm64);

  // Check that the fault address is the value expected for a stack overflow.
  if (fault_addr != overflow_addr) {
    VLOG(signals) << "Not a stack overflow";
    return false;
  }

  VLOG(signals) << "Stack overflow found";

  // Now arrange for the signal handler to return to art_quick_throw_stack_overflow.
  // The value of LR must be the same as it was when we entered the code that
  // caused this fault.  This will be inserted into a callee save frame by
  // the function to which this handler returns (art_quick_throw_stack_overflow).
  uc->CTX_PC = reinterpret_cast<uintptr_t>(art_quick_throw_stack_overflow);

  // The kernel will now return to the address in uc->CTX_PC.
  return true;
}
}       // namespace art

