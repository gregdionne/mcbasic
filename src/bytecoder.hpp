// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BYTECODER_HPP
#define BYTECODER_HPP

#include "coder.hpp"

// handles emitting instruction bytecode
//   example:
//     .byte bytecode_ld_ix_pb ; load integer destination with positive
//     .byte bytecode_INTVAR_X ; destination
//     .byte 2                 ; positive byte

class ByteCoder : public Coder {
public:
  using Coder::operate;

protected:
  // emits a .byte for the instruction and either .word or .byte for
  // an operand, and postoperations for "Stk" address modes.
  std::string defaultCode(Instruction *inst) override;
};

#endif
