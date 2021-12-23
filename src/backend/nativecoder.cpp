// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "nativecoder.hpp"

// call the implementation via native instructions:
//   operation() should evaluate to LDX, LDD, or LDAB.
//   operands() should evaluate to numeric label or data.
//   JSR is invoked directly on the call label.
//   postoperation() should evaluate to .text, .word, or .byte
//   postoperands() should evaluate to labels or text string.

std::string NativeCoder::defaultCode(Instruction *instruction) {
  std::string ops;

  if (!instruction->comment.empty()) {
    ops += "\t; " + instruction->comment + '\n';
  }

  if (!instruction->label.empty()) {
    ops += instruction->label + '\n';
  }

  if (!instruction->mnemonic.empty()) {
    if (instruction->arg1->exists() && !instruction->arg1->operand().empty()) {
      ops += '\t' + instruction->arg1->operation() + '\t' +
             instruction->arg1->operand() + '\n';
    }

    if (instruction->arg2->exists() && !instruction->arg2->operand().empty() &&
        !(instruction->arg1->isExtended() && instruction->arg2->isExtended())) {
      ops += '\t' + instruction->arg2->operation() + '\t' +
             instruction->arg2->operand() + '\n';
    }

    if (instruction->arg3->exists() && !instruction->arg3->operand().empty()) {
      ops += '\t' + instruction->arg3->operation() + '\t' +
             instruction->arg3->operand() + '\n';
    }

    ops += "\tjsr\t" + instruction->callLabel() + '\n';

    if (instruction->arg1->exists() &&
        !instruction->arg1->postoperation().empty()) {
      ops += '\t' + instruction->arg1->postoperation() + '\t' +
             instruction->arg1->postoperands() + '\n';
    }

    if (instruction->arg2->exists() &&
        !instruction->arg2->postoperation().empty()) {
      ops += '\t' + instruction->arg2->postoperation() + '\t' +
             instruction->arg2->postoperands() + '\n';
    }

    if (instruction->arg3->exists() &&
        !instruction->arg3->postoperation().empty()) {
      ops += '\t' + instruction->arg3->postoperation() + '\t' +
             instruction->arg3->postoperands() + '\n';
    }
  }

  return ops;
}
