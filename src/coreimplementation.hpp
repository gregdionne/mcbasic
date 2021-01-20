// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COREIMPLEMENTATION_HPP
#define COREIMPLEMENTATION_HPP

#include "assembler.hpp"
#include "implementation.hpp"

// core implementation of virtual instruction set
// calls preamble() before any instruction.
// and then proceeds assuming X and ACCD are properly
// initialized as in "native" operation.

class CoreImplementation : public Implementation {
public:
  CoreImplementation() = default;
  CoreImplementation(const CoreImplementation &) = delete;
  CoreImplementation(CoreImplementation &&) = delete;
  CoreImplementation &operator=(const CoreImplementation &) = delete;
  CoreImplementation &operator=(CoreImplementation &&) = delete;
  ~CoreImplementation() override = default;

  std::string unimplemented(Instruction &inst) override;

  std::string immLin(InstLabel &inst) override;

  std::string inherent(InstComment &inst) override;
  std::string inherent(InstClear &inst) override;
  std::string inherent(InstBegin &inst) override;
  std::string inherent(InstEnd &inst) override;
  std::string inherent(InstReturn &inst) override;
  std::string inherent(InstStop &inst) override;
  std::string inherent(InstCls &inst) override;
  std::string inherent(InstInputBuf &inst) override;
  std::string inherent(InstIgnoreExtra &inst) override;
  std::string inherent(InstRestore &inst) override;
  std::string inherent(InstNext &inst) override;

  std::string extInt(InstNextVar &inst) override;
  std::string extFlt(InstNextVar &inst) override;

  std::string ptrInt_regInt(InstStep &inst) override;
  std::string ptrFlt_regInt(InstStep &inst) override;
  std::string ptrFlt_regFlt(InstStep &inst) override;

  std::string regInt_extInt(InstArrayDim1 &inst) override;
  std::string regInt_extFlt(InstArrayDim1 &inst) override;
  std::string regInt_extStr(InstArrayDim1 &inst) override;

  std::string regInt_extInt(InstArrayDim2 &inst) override;
  std::string regInt_extFlt(InstArrayDim2 &inst) override;
  std::string regInt_extStr(InstArrayDim2 &inst) override;

  std::string regInt_extInt(InstArrayDim3 &inst) override;
  std::string regInt_extFlt(InstArrayDim3 &inst) override;
  std::string regInt_extStr(InstArrayDim3 &inst) override;

  std::string regInt_extInt(InstArrayDim4 &inst) override;
  std::string regInt_extFlt(InstArrayDim4 &inst) override;
  std::string regInt_extStr(InstArrayDim4 &inst) override;

  std::string regInt_extInt(InstArrayDim5 &inst) override;
  std::string regInt_extFlt(InstArrayDim5 &inst) override;
  std::string regInt_extStr(InstArrayDim5 &inst) override;

  std::string regInt_extInt(InstArrayRef1 &inst) override;
  std::string regInt_extFlt(InstArrayRef1 &inst) override;
  std::string regInt_extStr(InstArrayRef1 &inst) override;

  std::string regInt_extInt(InstArrayRef2 &inst) override;
  std::string regInt_extFlt(InstArrayRef2 &inst) override;
  std::string regInt_extStr(InstArrayRef2 &inst) override;

  std::string regInt_extInt(InstArrayRef3 &inst) override;
  std::string regInt_extFlt(InstArrayRef3 &inst) override;
  std::string regInt_extStr(InstArrayRef3 &inst) override;

  std::string regInt_extInt(InstArrayRef4 &inst) override;
  std::string regInt_extFlt(InstArrayRef4 &inst) override;
  std::string regInt_extStr(InstArrayRef4 &inst) override;

  std::string regInt_extInt(InstArrayRef5 &inst) override;
  std::string regInt_extFlt(InstArrayRef5 &inst) override;
  std::string regInt_extStr(InstArrayRef5 &inst) override;

  std::string regInt_extInt(InstArrayVal1 &inst) override;
  std::string regInt_extFlt(InstArrayVal1 &inst) override;
  std::string regInt_extStr(InstArrayVal1 &inst) override;

  std::string regInt_extInt(InstArrayVal2 &inst) override;
  std::string regInt_extFlt(InstArrayVal2 &inst) override;
  std::string regInt_extStr(InstArrayVal2 &inst) override;

  std::string regInt_extInt(InstArrayVal3 &inst) override;
  std::string regInt_extFlt(InstArrayVal3 &inst) override;
  std::string regInt_extStr(InstArrayVal3 &inst) override;

  std::string regInt_extInt(InstArrayVal4 &inst) override;
  std::string regInt_extFlt(InstArrayVal4 &inst) override;
  std::string regInt_extStr(InstArrayVal4 &inst) override;

  std::string regInt_extInt(InstArrayVal5 &inst) override;
  std::string regInt_extFlt(InstArrayVal5 &inst) override;
  std::string regInt_extStr(InstArrayVal5 &inst) override;

  std::string regInt_immLbl(InstJmpIfEqual &inst) override;
  std::string regInt_immLbl(InstJmpIfNotEqual &inst) override;

  std::string regInt_immLbl(InstJsrIfEqual &inst) override;
  std::string regInt_immLbl(InstJsrIfNotEqual &inst) override;

  std::string immLbl(InstGoTo &inst) override;
  std::string immLbl(InstGoSub &inst) override;

  virtual std::string regInt_regInt_posByte(InstShift &inst) override;
  virtual std::string regFlt_regFlt_posByte(InstShift &inst) override;
  virtual std::string regFlt_regInt_negByte(InstShift &inst) override;
  virtual std::string regFlt_regFlt_negByte(InstShift &inst) override;

  std::string regFlt_posByte(InstLd &inst) override;
  std::string regFlt_negByte(InstLd &inst) override;
  std::string regFlt_posWord(InstLd &inst) override;
  std::string regFlt_negWord(InstLd &inst) override;
  std::string regFlt_extFlt(InstLd &inst) override;
  std::string regFlt_extInt(InstLd &inst) override;
  std::string regInt_posByte(InstLd &inst) override;
  std::string regInt_negByte(InstLd &inst) override;
  std::string regInt_posWord(InstLd &inst) override;
  std::string regInt_negWord(InstLd &inst) override;
  std::string regInt_extInt(InstLd &inst) override;
  std::string regStr_immStr(InstLd &inst) override;
  std::string regStr_extStr(InstLd &inst) override;
  std::string extFlt_posByte(InstLd &inst) override;
  std::string extFlt_negByte(InstLd &inst) override;
  std::string extFlt_posWord(InstLd &inst) override;
  std::string extFlt_negWord(InstLd &inst) override;
  std::string extFlt_regFlt(InstLd &inst) override;
  std::string extFlt_regInt(InstLd &inst) override;
  std::string extInt_posByte(InstLd &inst) override;
  std::string extInt_negByte(InstLd &inst) override;
  std::string extInt_posWord(InstLd &inst) override;
  std::string extInt_negWord(InstLd &inst) override;
  std::string extInt_regInt(InstLd &inst) override;
  std::string extStr_immStr(InstLd &inst) override;
  std::string extStr_regStr(InstLd &inst) override;
  std::string indFlt_posByte(InstLd &inst) override;
  std::string indFlt_negByte(InstLd &inst) override;
  std::string indFlt_posWord(InstLd &inst) override;
  std::string indFlt_negWord(InstLd &inst) override;
  std::string indFlt_regFlt(InstLd &inst) override;
  std::string indFlt_regInt(InstLd &inst) override;
  std::string indInt_posByte(InstLd &inst) override;
  std::string indInt_negByte(InstLd &inst) override;
  std::string indInt_posWord(InstLd &inst) override;
  std::string indInt_negWord(InstLd &inst) override;
  std::string indInt_regInt(InstLd &inst) override;
  std::string indStr_immStr(InstLd &inst) override;
  std::string indStr_regStr(InstLd &inst) override;

  std::string regStr_regStr(InstStrInit &inst) override;
  std::string regStr_extStr(InstStrInit &inst) override;
  std::string regStr_immStr(InstStrInit &inst) override;

  std::string regStr_regStr_regStr(InstStrCat &inst) override;
  std::string regStr_regStr_extStr(InstStrCat &inst) override;
  std::string regStr_regStr_immStr(InstStrCat &inst) override;

  std::string regStr(InstInkey &inst) override;

  std::string regInt_regInt(InstNeg &inst) override;
  std::string regInt_extInt(InstNeg &inst) override;
  std::string regFlt_regFlt(InstNeg &inst) override;
  std::string regFlt_extFlt(InstNeg &inst) override;

  std::string regInt_regInt(InstCom &inst) override;
  std::string regInt_extInt(InstCom &inst) override;

  std::string regInt_regInt(InstSgn &inst) override;
  std::string regInt_regFlt(InstSgn &inst) override;
  std::string regInt_extInt(InstSgn &inst) override;
  std::string regInt_extFlt(InstSgn &inst) override;

  std::string regFlt_regFlt(InstAbs &inst) override;
  std::string regInt_regInt(InstAbs &inst) override;
  std::string regFlt_extFlt(InstAbs &inst) override;
  std::string regInt_extInt(InstAbs &inst) override;

  std::string regInt_regInt_posByte(InstOr &inst) override;
  std::string regInt_regInt_negByte(InstOr &inst) override;
  std::string regInt_regInt_posWord(InstOr &inst) override;
  std::string regInt_regInt_negWord(InstOr &inst) override;
  std::string regInt_regInt_regInt(InstOr &inst) override;
  std::string regInt_regInt_extInt(InstOr &inst) override;

  std::string regInt_regInt_posByte(InstAnd &inst) override;
  std::string regInt_regInt_negByte(InstAnd &inst) override;
  std::string regInt_regInt_posWord(InstAnd &inst) override;
  std::string regInt_regInt_negWord(InstAnd &inst) override;
  std::string regInt_regInt_regInt(InstAnd &inst) override;
  std::string regInt_regInt_extInt(InstAnd &inst) override;

  std::string regInt_posByte(InstIRnd &inst) override;
  std::string regInt_posWord(InstIRnd &inst) override;

  std::string regFlt_posByte(InstRnd &inst) override;
  std::string regFlt_negByte(InstRnd &inst) override;
  std::string regFlt_posWord(InstRnd &inst) override;
  std::string regFlt_negWord(InstRnd &inst) override;
  std::string regFlt_regInt(InstRnd &inst) override;
  std::string regFlt_extInt(InstRnd &inst) override;

  std::string regFlt_regInt(InstInv &inst) override;
  std::string regFlt_regFlt(InstInv &inst) override;

  std::string regInt_regStr(InstAsc &inst) override;
  std::string regInt_extStr(InstAsc &inst) override;

  std::string regInt_regStr(InstLen &inst) override;
  std::string regInt_extStr(InstLen &inst) override;

  std::string regStr_regInt(InstChr &inst) override;
  std::string regStr_extInt(InstChr &inst) override;

  std::string regStr_regInt(InstStr &inst) override;
  std::string regStr_regFlt(InstStr &inst) override;
  std::string regStr_extInt(InstStr &inst) override;
  std::string regStr_extFlt(InstStr &inst) override;

  std::string regFlt_regStr(InstVal &inst) override;
  std::string regFlt_extStr(InstVal &inst) override;

  std::string regStr_regStr_regInt(InstLeft &inst) override;
  std::string regStr_regStr_extInt(InstLeft &inst) override;
  std::string regStr_regStr_posByte(InstLeft &inst) override;

  std::string regStr_regStr_regInt(InstMid &inst) override;
  std::string regStr_regStr_extInt(InstMid &inst) override;
  std::string regStr_regStr_posByte(InstMid &inst) override;

  std::string regStr_regStr_regInt(InstMidT &inst) override;
  std::string regStr_regStr_extInt(InstMidT &inst) override;
  std::string regStr_regStr_posByte(InstMidT &inst) override;

  std::string regStr_regStr_regInt(InstRight &inst) override;
  std::string regStr_regStr_extInt(InstRight &inst) override;
  std::string regStr_regStr_posByte(InstRight &inst) override;

  std::string regInt_regInt_posByte(InstLdEq &inst) override;
  std::string regInt_regInt_negByte(InstLdEq &inst) override;
  std::string regInt_regInt_posWord(InstLdEq &inst) override;
  std::string regInt_regInt_negWord(InstLdEq &inst) override;
  std::string regInt_regInt_regInt(InstLdEq &inst) override;
  std::string regInt_regInt_extInt(InstLdEq &inst) override;
  std::string regInt_regInt_regFlt(InstLdEq &inst) override;
  std::string regInt_regInt_extFlt(InstLdEq &inst) override;
  std::string regInt_regFlt_posByte(InstLdEq &inst) override;
  std::string regInt_regFlt_negByte(InstLdEq &inst) override;
  std::string regInt_regFlt_posWord(InstLdEq &inst) override;
  std::string regInt_regFlt_negWord(InstLdEq &inst) override;
  std::string regInt_regFlt_regInt(InstLdEq &inst) override;
  std::string regInt_regFlt_extInt(InstLdEq &inst) override;
  std::string regInt_regFlt_regFlt(InstLdEq &inst) override;
  std::string regInt_regFlt_extFlt(InstLdEq &inst) override;
  std::string regInt_regStr_regStr(InstLdEq &inst) override;
  std::string regInt_regStr_extStr(InstLdEq &inst) override;
  std::string regInt_regStr_immStr(InstLdEq &inst) override;

  std::string regInt_regInt_posByte(InstLdNe &inst) override;
  std::string regInt_regInt_negByte(InstLdNe &inst) override;
  std::string regInt_regInt_posWord(InstLdNe &inst) override;
  std::string regInt_regInt_negWord(InstLdNe &inst) override;
  std::string regInt_regInt_regInt(InstLdNe &inst) override;
  std::string regInt_regInt_extInt(InstLdNe &inst) override;
  std::string regInt_regInt_regFlt(InstLdNe &inst) override;
  std::string regInt_regInt_extFlt(InstLdNe &inst) override;
  std::string regInt_regFlt_posByte(InstLdNe &inst) override;
  std::string regInt_regFlt_negByte(InstLdNe &inst) override;
  std::string regInt_regFlt_posWord(InstLdNe &inst) override;
  std::string regInt_regFlt_negWord(InstLdNe &inst) override;
  std::string regInt_regFlt_regInt(InstLdNe &inst) override;
  std::string regInt_regFlt_extInt(InstLdNe &inst) override;
  std::string regInt_regFlt_regFlt(InstLdNe &inst) override;
  std::string regInt_regFlt_extFlt(InstLdNe &inst) override;
  std::string regInt_regStr_regStr(InstLdNe &inst) override;
  std::string regInt_regStr_extStr(InstLdNe &inst) override;
  std::string regInt_regStr_immStr(InstLdNe &inst) override;

  std::string regInt_regInt_posByte(InstLdLt &inst) override;
  std::string regInt_regInt_negByte(InstLdLt &inst) override;
  std::string regInt_regInt_posWord(InstLdLt &inst) override;
  std::string regInt_regInt_negWord(InstLdLt &inst) override;
  std::string regInt_regInt_regInt(InstLdLt &inst) override;
  std::string regInt_regInt_extInt(InstLdLt &inst) override;
  std::string regInt_regInt_regFlt(InstLdLt &inst) override;
  std::string regInt_regInt_extFlt(InstLdLt &inst) override;
  std::string regInt_regFlt_posByte(InstLdLt &inst) override;
  std::string regInt_regFlt_negByte(InstLdLt &inst) override;
  std::string regInt_regFlt_posWord(InstLdLt &inst) override;
  std::string regInt_regFlt_negWord(InstLdLt &inst) override;
  std::string regInt_regFlt_regInt(InstLdLt &inst) override;
  std::string regInt_regFlt_extInt(InstLdLt &inst) override;
  std::string regInt_regFlt_regFlt(InstLdLt &inst) override;
  std::string regInt_regFlt_extFlt(InstLdLt &inst) override;

  std::string regInt_regInt_posByte(InstLdGe &inst) override;
  std::string regInt_regInt_negByte(InstLdGe &inst) override;
  std::string regInt_regInt_posWord(InstLdGe &inst) override;
  std::string regInt_regInt_negWord(InstLdGe &inst) override;
  std::string regInt_regInt_regInt(InstLdGe &inst) override;
  std::string regInt_regInt_extInt(InstLdGe &inst) override;
  std::string regInt_regInt_regFlt(InstLdGe &inst) override;
  std::string regInt_regInt_extFlt(InstLdGe &inst) override;
  std::string regInt_regFlt_posByte(InstLdGe &inst) override;
  std::string regInt_regFlt_negByte(InstLdGe &inst) override;
  std::string regInt_regFlt_posWord(InstLdGe &inst) override;
  std::string regInt_regFlt_negWord(InstLdGe &inst) override;
  std::string regInt_regFlt_regInt(InstLdGe &inst) override;
  std::string regInt_regFlt_extInt(InstLdGe &inst) override;
  std::string regInt_regFlt_regFlt(InstLdGe &inst) override;
  std::string regInt_regFlt_extFlt(InstLdGe &inst) override;

  std::string regInt_regStr_regStr(InstLdLo &inst) override;
  std::string regInt_regStr_extStr(InstLdLo &inst) override;
  std::string regInt_regStr_immStr(InstLdLo &inst) override;
  std::string regInt_regStr_regStr(InstLdHs &inst) override;
  std::string regInt_regStr_extStr(InstLdHs &inst) override;
  std::string regInt_regStr_immStr(InstLdHs &inst) override;

  std::string regInt_regInt(InstPeek &inst) override;
  std::string regInt_extInt(InstPeek &inst) override;
  std::string regInt_posWord(InstPeek &inst) override;
  std::string regInt_posByte(InstPeek &inst) override;

  std::string posByte_regInt(InstPoke &inst) override;
  std::string posByte_extInt(InstPoke &inst) override;
  std::string posWord_regInt(InstPoke &inst) override;
  std::string posWord_extInt(InstPoke &inst) override;
  std::string regInt_posByte(InstPoke &inst) override;
  std::string regInt_regInt(InstPoke &inst) override;
  std::string regInt_extInt(InstPoke &inst) override;
  std::string extInt_posByte(InstPoke &inst) override;
  std::string extInt_regInt(InstPoke &inst) override;

  std::string extInt_posByte(InstFor &inst) override;
  std::string extInt_negByte(InstFor &inst) override;
  std::string extInt_posWord(InstFor &inst) override;
  std::string extInt_negWord(InstFor &inst) override;
  std::string extInt_regInt(InstFor &inst) override;
  std::string extFlt_posByte(InstFor &inst) override;
  std::string extFlt_negByte(InstFor &inst) override;
  std::string extFlt_posWord(InstFor &inst) override;
  std::string extFlt_negWord(InstFor &inst) override;
  std::string extFlt_regInt(InstFor &inst) override;
  std::string extFlt_regFlt(InstFor &inst) override;

  std::string ptrInt_posByte(InstTo &inst) override;
  std::string ptrInt_negByte(InstTo &inst) override;
  std::string ptrInt_posWord(InstTo &inst) override;
  std::string ptrInt_negWord(InstTo &inst) override;
  std::string ptrInt_regInt(InstTo &inst) override;
  std::string ptrInt_extInt(InstTo &inst) override;
  std::string ptrFlt_posByte(InstTo &inst) override;
  std::string ptrFlt_negByte(InstTo &inst) override;
  std::string ptrFlt_posWord(InstTo &inst) override;
  std::string ptrFlt_negWord(InstTo &inst) override;
  std::string ptrFlt_regInt(InstTo &inst) override;
  std::string ptrFlt_extInt(InstTo &inst) override;
  std::string ptrFlt_regFlt(InstTo &inst) override;
  std::string ptrFlt_extFlt(InstTo &inst) override;

  std::string regInt_immLbls(InstOnGoTo &inst) override;
  std::string regInt_immLbls(InstOnGoSub &inst) override;

  std::string immStr(InstPr &inst) override;
  std::string regStr(InstPr &inst) override;
  std::string extStr(InstPr &inst) override;

  std::string posByte(InstPrAt &inst) override;
  std::string posWord(InstPrAt &inst) override;
  std::string regInt(InstPrAt &inst) override;
  std::string extInt(InstPrAt &inst) override;

  std::string regInt(InstPrTab &inst) override;
  std::string extInt(InstPrTab &inst) override;
  std::string posByte(InstPrTab &inst) override;

  std::string regInt_posByte(InstSet &inst) override;
  std::string regInt_regInt(InstSet &inst) override;
  std::string regInt_extInt(InstSet &inst) override;

  std::string regInt_regInt_posByte(InstSetC &inst) override;
  std::string regInt_regInt_regInt(InstSetC &inst) override;
  std::string regInt_regInt_extInt(InstSetC &inst) override;

  std::string regInt_regInt_regInt(InstPoint &inst) override;
  std::string regInt_regInt_extInt(InstPoint &inst) override;
  std::string regInt_regInt_posByte(InstPoint &inst) override;

  std::string regInt_posByte(InstReset &inst) override;
  std::string regInt_regInt(InstReset &inst) override;
  std::string regInt_extInt(InstReset &inst) override;

  std::string posByte(InstClsN &inst) override;
  std::string regInt(InstClsN &inst) override;
  std::string extInt(InstClsN &inst) override;

  std::string extFlt(InstReadBuf &inst) override;
  std::string indFlt(InstReadBuf &inst) override;
  std::string extStr(InstReadBuf &inst) override;
  std::string indStr(InstReadBuf &inst) override;

  std::string indInt(InstRead &inst) override;
  std::string indFlt(InstRead &inst) override;
  std::string indStr(InstRead &inst) override;
  std::string extInt(InstRead &inst) override;
  std::string extFlt(InstRead &inst) override;
  std::string extStr(InstRead &inst) override;

  std::string regInt_regInt(InstSound &inst) override;

  std::string indFlt_indFlt_regFlt(InstAdd &inst) override;
  std::string indFlt_indFlt_regInt(InstAdd &inst) override;
  std::string indFlt_indFlt_posByte(InstAdd &inst) override;
  std::string indFlt_indFlt_negByte(InstAdd &inst) override;
  std::string indFlt_indFlt_posWord(InstAdd &inst) override;
  std::string indFlt_indFlt_negWord(InstAdd &inst) override;
  std::string indInt_indInt_regInt(InstAdd &inst) override;
  std::string indInt_indInt_posByte(InstAdd &inst) override;
  std::string indInt_indInt_negByte(InstAdd &inst) override;
  std::string indInt_indInt_posWord(InstAdd &inst) override;
  std::string indInt_indInt_negWord(InstAdd &inst) override;
  std::string extFlt_extFlt_regFlt(InstAdd &inst) override;
  std::string extFlt_extFlt_regInt(InstAdd &inst) override;
  std::string extFlt_extFlt_posByte(InstAdd &inst) override;
  std::string extFlt_extFlt_negByte(InstAdd &inst) override;
  std::string extFlt_extFlt_posWord(InstAdd &inst) override;
  std::string extFlt_extFlt_negWord(InstAdd &inst) override;
  std::string extInt_extInt_regInt(InstAdd &inst) override;
  std::string extInt_extInt_posByte(InstAdd &inst) override;
  std::string extInt_extInt_negByte(InstAdd &inst) override;
  std::string extInt_extInt_posWord(InstAdd &inst) override;
  std::string extInt_extInt_negWord(InstAdd &inst) override;
  std::string regFlt_regFlt_regFlt(InstAdd &inst) override;
  std::string regFlt_regFlt_regInt(InstAdd &inst) override;
  std::string regFlt_regInt_regFlt(InstAdd &inst) override;
  std::string regInt_regInt_regInt(InstAdd &inst) override;
  std::string regFlt_regFlt_extFlt(InstAdd &inst) override;
  std::string regFlt_regFlt_extInt(InstAdd &inst) override;
  std::string regFlt_regInt_extFlt(InstAdd &inst) override;
  std::string regInt_regInt_extInt(InstAdd &inst) override;
  std::string regFlt_regFlt_posByte(InstAdd &inst) override;
  std::string regFlt_regFlt_negByte(InstAdd &inst) override;
  std::string regFlt_regFlt_posWord(InstAdd &inst) override;
  std::string regFlt_regFlt_negWord(InstAdd &inst) override;
  std::string regInt_regInt_posByte(InstAdd &inst) override;
  std::string regInt_regInt_negByte(InstAdd &inst) override;
  std::string regInt_regInt_posWord(InstAdd &inst) override;
  std::string regInt_regInt_negWord(InstAdd &inst) override;
  std::string regFlt_extFlt_posByte(InstAdd &inst) override;
  std::string regFlt_extFlt_negByte(InstAdd &inst) override;
  std::string regFlt_extFlt_posWord(InstAdd &inst) override;
  std::string regFlt_extFlt_negWord(InstAdd &inst) override;
  std::string regInt_extInt_posByte(InstAdd &inst) override;
  std::string regInt_extInt_negByte(InstAdd &inst) override;
  std::string regInt_extInt_posWord(InstAdd &inst) override;
  std::string regInt_extInt_negWord(InstAdd &inst) override;
  std::string regFlt_posByte_extFlt(InstAdd &inst) override;
  std::string regFlt_negByte_extFlt(InstAdd &inst) override;
  std::string regFlt_posWord_extFlt(InstAdd &inst) override;
  std::string regFlt_negWord_extFlt(InstAdd &inst) override;
  std::string regInt_posByte_extInt(InstAdd &inst) override;
  std::string regInt_negByte_extInt(InstAdd &inst) override;
  std::string regInt_posWord_extInt(InstAdd &inst) override;
  std::string regInt_negWord_extInt(InstAdd &inst) override;

  std::string indFlt_indFlt_regFlt(InstSub &inst) override;
  std::string indFlt_indFlt_regInt(InstSub &inst) override;
  std::string indFlt_indFlt_posByte(InstSub &inst) override;
  std::string indFlt_indFlt_negByte(InstSub &inst) override;
  std::string indFlt_indFlt_posWord(InstSub &inst) override;
  std::string indFlt_indFlt_negWord(InstSub &inst) override;
  std::string indInt_indInt_regInt(InstSub &inst) override;
  std::string indInt_indInt_posByte(InstSub &inst) override;
  std::string indInt_indInt_negByte(InstSub &inst) override;
  std::string indInt_indInt_posWord(InstSub &inst) override;
  std::string indInt_indInt_negWord(InstSub &inst) override;
  std::string extFlt_extFlt_regFlt(InstSub &inst) override;
  std::string extFlt_extFlt_regInt(InstSub &inst) override;
  std::string extFlt_extFlt_posByte(InstSub &inst) override;
  std::string extFlt_extFlt_negByte(InstSub &inst) override;
  std::string extFlt_extFlt_posWord(InstSub &inst) override;
  std::string extFlt_extFlt_negWord(InstSub &inst) override;
  std::string extInt_extInt_regInt(InstSub &inst) override;
  std::string extInt_extInt_posByte(InstSub &inst) override;
  std::string extInt_extInt_negByte(InstSub &inst) override;
  std::string extInt_extInt_posWord(InstSub &inst) override;
  std::string extInt_extInt_negWord(InstSub &inst) override;
  std::string regFlt_regFlt_regFlt(InstSub &inst) override;
  std::string regFlt_regFlt_regInt(InstSub &inst) override;
  std::string regFlt_regInt_regFlt(InstSub &inst) override;
  std::string regInt_regInt_regInt(InstSub &inst) override;
  std::string regFlt_regFlt_extFlt(InstSub &inst) override;
  std::string regFlt_regFlt_extInt(InstSub &inst) override;
  std::string regFlt_regInt_extFlt(InstSub &inst) override;
  std::string regInt_regInt_extInt(InstSub &inst) override;
  std::string regFlt_regFlt_posByte(InstSub &inst) override;
  std::string regFlt_regFlt_negByte(InstSub &inst) override;
  std::string regFlt_regFlt_posWord(InstSub &inst) override;
  std::string regFlt_regFlt_negWord(InstSub &inst) override;
  std::string regInt_regInt_posByte(InstSub &inst) override;
  std::string regInt_regInt_negByte(InstSub &inst) override;
  std::string regInt_regInt_posWord(InstSub &inst) override;
  std::string regInt_regInt_negWord(InstSub &inst) override;
  std::string regFlt_extFlt_posByte(InstSub &inst) override;
  std::string regFlt_extFlt_negByte(InstSub &inst) override;
  std::string regFlt_extFlt_posWord(InstSub &inst) override;
  std::string regFlt_extFlt_negWord(InstSub &inst) override;
  std::string regInt_extInt_posByte(InstSub &inst) override;
  std::string regInt_extInt_negByte(InstSub &inst) override;
  std::string regInt_extInt_posWord(InstSub &inst) override;
  std::string regInt_extInt_negWord(InstSub &inst) override;
  std::string regFlt_posByte_extFlt(InstSub &inst) override;
  std::string regFlt_negByte_extFlt(InstSub &inst) override;
  std::string regFlt_posWord_extFlt(InstSub &inst) override;
  std::string regFlt_negWord_extFlt(InstSub &inst) override;
  std::string regInt_posByte_extInt(InstSub &inst) override;
  std::string regInt_negByte_extInt(InstSub &inst) override;
  std::string regInt_posWord_extInt(InstSub &inst) override;
  std::string regInt_negWord_extInt(InstSub &inst) override;

  std::string regFlt_regFlt_regFlt(InstMul &inst) override;
  std::string regFlt_regFlt_extFlt(InstMul &inst) override;
  std::string regFlt_regFlt_regInt(InstMul &inst) override;
  std::string regFlt_regFlt_extInt(InstMul &inst) override;
  std::string regFlt_regFlt_posByte(InstMul &inst) override;
  std::string regFlt_regFlt_negByte(InstMul &inst) override;
  std::string regFlt_regFlt_posWord(InstMul &inst) override;
  std::string regFlt_regFlt_negWord(InstMul &inst) override;
  std::string regFlt_regInt_regFlt(InstMul &inst) override;
  std::string regFlt_regInt_extFlt(InstMul &inst) override;
  std::string regInt_regInt_regInt(InstMul &inst) override;
  std::string regInt_regInt_extInt(InstMul &inst) override;
  std::string regInt_regInt_posByte(InstMul &inst) override;
  std::string regInt_regInt_negByte(InstMul &inst) override;
  std::string regInt_regInt_posWord(InstMul &inst) override;
  std::string regInt_regInt_negWord(InstMul &inst) override;

  std::string regFlt_regFlt_regFlt(InstDiv &inst) override;
  std::string regFlt_regFlt_extFlt(InstDiv &inst) override;
  std::string regFlt_regFlt_regInt(InstDiv &inst) override;
  std::string regFlt_regFlt_extInt(InstDiv &inst) override;
  std::string regFlt_regFlt_posByte(InstDiv &inst) override;
  std::string regFlt_regFlt_negByte(InstDiv &inst) override;
  std::string regFlt_regFlt_posWord(InstDiv &inst) override;
  std::string regFlt_regFlt_negWord(InstDiv &inst) override;
  std::string regFlt_regInt_regFlt(InstDiv &inst) override;
  std::string regFlt_regInt_extFlt(InstDiv &inst) override;
  std::string regFlt_regInt_regInt(InstDiv &inst) override;
  std::string regFlt_regInt_extInt(InstDiv &inst) override;
  std::string regFlt_regInt_posByte(InstDiv &inst) override;
  std::string regFlt_regInt_negByte(InstDiv &inst) override;
  std::string regFlt_regInt_posWord(InstDiv &inst) override;
  std::string regFlt_regInt_negWord(InstDiv &inst) override;

protected:
  virtual void preamble(Assembler &tasm, Instruction &inst);
};

#endif
