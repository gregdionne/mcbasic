// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "nativetarget.hpp"
#include "nativecoder.hpp"
#include "nativeimplementation.hpp"

std::string NativeTarget::generateCode(InstQueue &queue) {
  Assembler tasm;
  tasm.blank();
  tasm.comment("main program");
  tasm.org("M_CODE");
  tasm.blank();
  std::string ops = tasm.source();

  NativeCoder coder;
  for (auto &instruction : queue.queue) {
    ops += instruction->operate(&coder);
    ops += '\n';
  }

  return ops;
}

up<Dispatcher> NativeTarget::makeDispatcher() {
  return makeup<Dispatcher>(makeup<NativeImplementation>());
}
