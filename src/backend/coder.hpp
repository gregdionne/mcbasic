// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_CODER_HPP
#define BACKEND_CODER_HPP

#include "compiler/instruction.hpp"

// default interface for NativeCoder and ByteCoder
//  generates "!unimplemented" in the assembly if not
//  overridden

class Coder : public InstructionOp {
public:
  Coder() = default;
  Coder(const Coder &) = delete;
  Coder(Coder &&) = delete;
  Coder &operator=(const Coder &) = delete;
  Coder &operator=(Coder &&) = delete;
  virtual ~Coder() = default;

  std::string operate(Instruction &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstComment &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLabel &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayDim1 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayRef1 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayVal1 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayDim2 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayRef2 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayVal2 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayDim3 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayRef3 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayVal3 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayDim4 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayRef4 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayVal4 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayDim5 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayRef5 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayVal5 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayDim &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayRef &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstArrayVal &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstShift &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLd &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstOne &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstTrue &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstClr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstInc &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstDec &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstAbs &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstDbl &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstHlf &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSq &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstNeg &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstMul3 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstCom &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSgn &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPeek &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPeekWord &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSqr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstInv &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLog &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstExp &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSin &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstCos &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstTan &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstIRnd &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstRnd &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstStr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstVal &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstAsc &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLen &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstChr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstInkey &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstMem &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPos &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstTimer &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstAdd &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSub &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstRSub &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstMul &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstDiv &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstIDiv &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstIDiv3 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstIDiv5 &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstIDiv5S &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPow &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLdEq &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLdNe &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLdLt &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLdGe &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstAnd &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstOr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPoint &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstStrInit &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstStrCat &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstLeft &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstRight &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstMid &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstMidT &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPrTab &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPrComma &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPrSpace &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPrCR &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPrAt &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstFor &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstForOne &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstForTrue &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstForClr &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstTo &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstStep &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstNext &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstNextVar &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstGoTo &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstGoSub &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstOnGoTo &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstOnGoSub &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstJsrIfEqual &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstJsrIfNotEqual &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstJmpIfEqual &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstJmpIfNotEqual &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstInputBuf &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstReadBuf &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstIgnoreExtra &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstRead &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstRestore &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstReturn &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstClear &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstCls &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstClsN &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSet &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSetC &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstReset &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstStop &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstPoke &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstSound &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstExec &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstError &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstBegin &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }
  std::string operate(InstEnd &inst) override {
    return defaultCode(static_cast<Instruction *>(&inst));
  }

protected:
  virtual std::string defaultCode(Instruction * /*inst*/) {
    return "\t!unimplemented";
  }
};

#endif
