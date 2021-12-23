// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "bytecoder.hpp"

std::string ByteCoder::defaultCode(Instruction *instruction) {
  std::string ops;

  if (!instruction->comment.empty()) {
    ops += "\t; " + instruction->comment + '\n';
  }

  if (!instruction->label.empty()) {
    ops += instruction->label + "\n";
  }

  if (!instruction->mnemonic.empty()) {
    ops += "\t.byte\tbytecode_" + instruction->callLabel() + '\n';

    if (instruction->arg1->exists() && !instruction->arg1->operand().empty()) {
      ops += "\t" + instruction->arg1->directive() + '\t' +
             instruction->arg1->doperand() + '\n';
    }

    if (instruction->arg2->exists() && !instruction->arg2->operand().empty() &&
        !(instruction->arg1->isExtended() && instruction->arg2->isExtended())) {
      ops += "\t" + instruction->arg2->directive() + '\t' +
             instruction->arg2->doperand() + '\n';
    }

    if (instruction->arg3->exists() && !instruction->arg3->operand().empty()) {
      ops += "\t" + instruction->arg3->directive() + '\t' +
             instruction->arg3->doperand() + '\n';
    }

    if (instruction->arg1->exists() &&
        !instruction->arg1->postoperation().empty()) {
      ops += "\t" + instruction->arg1->postoperation() + '\t' +
             instruction->arg1->postoperands() + '\n';
    }

    if (instruction->arg2->exists() &&
        !instruction->arg2->postoperation().empty()) {
      ops += "\t" + instruction->arg2->postoperation() + '\t' +
             instruction->arg2->postoperands() + '\n';
    }

    if (instruction->arg3->exists() &&
        !instruction->arg3->postoperation().empty()) {
      ops += "\t" + instruction->arg3->postoperation() + '\t' +
             instruction->arg3->postoperands() + '\n';
    }
  }

  return ops;
}
