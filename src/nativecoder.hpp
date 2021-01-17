// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef NATIVECODER_HPP
#define NATIVECODER_HPP

#include "coder.hpp"

// call the implementation via native instructions:
//   example:
//
//	ldx	#INTVAR_X
//	ldab	#2
//	jsr	ld_ix_pb	; load integer destination with positive byte

class NativeCoder : public Coder {
public:
  using Coder::operate;

protected:
  std::string defaultCode(Instruction *inst) override;
};

#endif
