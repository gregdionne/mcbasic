// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DISPATCHER_HPP
#define DISPATCHER_HPP

#include "implementation.hpp"

// Virtual instructions have various addressing modes
// the Dispatcher delegates the instruction implementation
// to the approprate implementation.
//
// Originally all source was implemented without a dispatcher
// There were no "immediate" addressing modes (all constants
// were in dedicated symbols).  But alas, memory constraints
// and performance suggested adding those addressing modes,
// which demanded instruction re-ordering and elision.  So
// we perform the branching here.

class Dispatcher : public InstructionOp {
public:
  explicit Dispatcher(std::unique_ptr<Implementation> interp)
      : implementation(std::move(interp)) {}

  // because the "rule-of-five"
  Dispatcher() = delete;
  Dispatcher(const Dispatcher &) = delete;
  Dispatcher(Dispatcher &&) = delete;
  Dispatcher &operator=(const Dispatcher &) = delete;
  Dispatcher &operator=(Dispatcher &&) = delete;

  // because compilers ask us to
  virtual ~Dispatcher() = default;

  std::string operate(Instruction &inst) override;
  std::string operate(InstComment &inst) override;
  std::string operate(InstLabel &inst) override;
  std::string operate(InstArrayDim1 &inst) override;
  std::string operate(InstArrayRef1 &inst) override;
  std::string operate(InstArrayVal1 &inst) override;
  std::string operate(InstArrayDim2 &inst) override;
  std::string operate(InstArrayRef2 &inst) override;
  std::string operate(InstArrayVal2 &inst) override;
  std::string operate(InstArrayDim3 &inst) override;
  std::string operate(InstArrayRef3 &inst) override;
  std::string operate(InstArrayVal3 &inst) override;
  std::string operate(InstArrayDim4 &inst) override;
  std::string operate(InstArrayRef4 &inst) override;
  std::string operate(InstArrayVal4 &inst) override;
  std::string operate(InstArrayDim5 &inst) override;
  std::string operate(InstArrayRef5 &inst) override;
  std::string operate(InstArrayVal5 &inst) override;
  std::string operate(InstArrayDim &inst) override;
  std::string operate(InstArrayRef &inst) override;
  std::string operate(InstArrayVal &inst) override;
  std::string operate(InstLd &inst) override;
  std::string operate(InstAbs &inst) override;
  std::string operate(InstNeg &inst) override;
  std::string operate(InstCom &inst) override;
  std::string operate(InstSgn &inst) override;
  std::string operate(InstPeek &inst) override;
  std::string operate(InstSqr &inst) override;
  std::string operate(InstInv &inst) override;
  std::string operate(InstLog &inst) override;
  std::string operate(InstExp &inst) override;
  std::string operate(InstSin &inst) override;
  std::string operate(InstCos &inst) override;
  std::string operate(InstTan &inst) override;
  std::string operate(InstIRnd &inst) override;
  std::string operate(InstRnd &inst) override;
  std::string operate(InstStr &inst) override;
  std::string operate(InstVal &inst) override;
  std::string operate(InstAsc &inst) override;
  std::string operate(InstLen &inst) override;
  std::string operate(InstChr &inst) override;
  std::string operate(InstInkey &inst) override;
  std::string operate(InstAdd &inst) override;
  std::string operate(InstSub &inst) override;
  std::string operate(InstMul &inst) override;
  std::string operate(InstDiv &inst) override;
  std::string operate(InstLdEq &inst) override;
  std::string operate(InstLdNe &inst) override;
  std::string operate(InstLdLo &inst) override;
  std::string operate(InstLdLt &inst) override;
  std::string operate(InstLdHs &inst) override;
  std::string operate(InstLdGe &inst) override;
  std::string operate(InstAnd &inst) override;
  std::string operate(InstOr &inst) override;
  std::string operate(InstPoint &inst) override;
  std::string operate(InstStrInit &inst) override;
  std::string operate(InstStrCat &inst) override;
  std::string operate(InstLeft &inst) override;
  std::string operate(InstRight &inst) override;
  std::string operate(InstMid &inst) override;
  std::string operate(InstMidT &inst) override;
  std::string operate(InstPrTab &inst) override;
  std::string operate(InstPrComma &inst) override;
  std::string operate(InstPrSpace &inst) override;
  std::string operate(InstPrCR &inst) override;
  std::string operate(InstPrAt &inst) override;
  std::string operate(InstPr &inst) override;
  std::string operate(InstFor &inst) override;
  std::string operate(InstTo &inst) override;
  std::string operate(InstStep &inst) override;
  std::string operate(InstNext &inst) override;
  std::string operate(InstNextVar &inst) override;
  std::string operate(InstGoTo &inst) override;
  std::string operate(InstGoSub &inst) override;
  std::string operate(InstOnGoTo &inst) override;
  std::string operate(InstOnGoSub &inst) override;
  std::string operate(InstJsrIfEqual &inst) override;
  std::string operate(InstJsrIfNotEqual &inst) override;
  std::string operate(InstJmpIfEqual &inst) override;
  std::string operate(InstJmpIfNotEqual &inst) override;
  std::string operate(InstInputBuf &inst) override;
  std::string operate(InstReadBuf &inst) override;
  std::string operate(InstIgnoreExtra &inst) override;
  std::string operate(InstRead &inst) override;
  std::string operate(InstRestore &inst) override;
  std::string operate(InstReturn &inst) override;
  std::string operate(InstClear &inst) override;
  std::string operate(InstCls &inst) override;
  std::string operate(InstClsN &inst) override;
  std::string operate(InstSet &inst) override;
  std::string operate(InstSetC &inst) override;
  std::string operate(InstReset &inst) override;
  std::string operate(InstStop &inst) override;
  std::string operate(InstPoke &inst) override;
  std::string operate(InstSound &inst) override;
  std::string operate(InstBegin &inst) override;
  std::string operate(InstEnd &inst) override;

protected:
  std::unique_ptr<Implementation> implementation;
};

#endif
