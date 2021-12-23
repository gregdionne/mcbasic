// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_IMPLEMENTATION_HPP
#define BACKEND_IMPLEMENTATION_HPP

#include "compiler/instruction.hpp"

// Interface for the virtual instruction implementation

class Implementation {
public:
  Implementation() = default;
  Implementation(const Implementation &) = delete;
  Implementation(Implementation &&) = delete;
  Implementation &operator=(const Implementation &) = delete;
  Implementation &operator=(Implementation &&) = delete;
  virtual ~Implementation() = default;

  virtual std::string unimplemented(Instruction &inst) = 0;

  virtual std::string immLin(InstLabel &inst) = 0;

  virtual std::string inherent(InstComment &inst) = 0;
  virtual std::string inherent(InstClear &inst) = 0;
  virtual std::string inherent(InstBegin &inst) = 0;
  virtual std::string inherent(InstEnd &inst) = 0;
  virtual std::string inherent(InstReturn &inst) = 0;
  virtual std::string inherent(InstStop &inst) = 0;
  virtual std::string inherent(InstCls &inst) = 0;
  virtual std::string inherent(InstPrComma &inst) = 0;
  virtual std::string inherent(InstInputBuf &inst) = 0;
  virtual std::string inherent(InstIgnoreExtra &inst) = 0;
  virtual std::string inherent(InstRestore &inst) = 0;
  virtual std::string inherent(InstNext &inst) = 0;

  virtual std::string posByte(InstError &inst) = 0;

  virtual std::string extInt(InstNextVar &inst) = 0;
  virtual std::string extFlt(InstNextVar &inst) = 0;

  virtual std::string ptrInt_regInt(InstStep &inst) = 0;
  virtual std::string ptrFlt_regInt(InstStep &inst) = 0;
  virtual std::string ptrFlt_regFlt(InstStep &inst) = 0;

  virtual std::string regInt_extInt(InstArrayDim1 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayDim1 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayDim1 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayDim2 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayDim2 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayDim2 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayDim3 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayDim3 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayDim3 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayDim4 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayDim4 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayDim4 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayDim5 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayDim5 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayDim5 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayRef1 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayRef1 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayRef1 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayRef2 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayRef2 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayRef2 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayRef3 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayRef3 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayRef3 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayRef4 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayRef4 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayRef4 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayRef5 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayRef5 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayRef5 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayVal1 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayVal1 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayVal1 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayVal2 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayVal2 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayVal2 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayVal3 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayVal3 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayVal3 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayVal4 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayVal4 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayVal4 &inst) = 0;

  virtual std::string regInt_extInt(InstArrayVal5 &inst) = 0;
  virtual std::string regInt_extFlt(InstArrayVal5 &inst) = 0;
  virtual std::string regInt_extStr(InstArrayVal5 &inst) = 0;

  virtual std::string regInt_immLbl(InstJmpIfEqual &inst) = 0;
  virtual std::string regFlt_immLbl(InstJmpIfEqual &inst) = 0;
  virtual std::string regInt_immLbl(InstJmpIfNotEqual &inst) = 0;
  virtual std::string regFlt_immLbl(InstJmpIfNotEqual &inst) = 0;

  virtual std::string regInt_immLbl(InstJsrIfEqual &inst) = 0;
  virtual std::string regFlt_immLbl(InstJsrIfEqual &inst) = 0;
  virtual std::string regInt_immLbl(InstJsrIfNotEqual &inst) = 0;
  virtual std::string regFlt_immLbl(InstJsrIfNotEqual &inst) = 0;

  virtual std::string immLbl(InstGoTo &inst) = 0;
  virtual std::string immLbl(InstGoSub &inst) = 0;

  virtual std::string regFlt_regFlt_regInt(InstShift &inst) = 0;
  virtual std::string regFlt_regFlt_extInt(InstShift &inst) = 0;
  virtual std::string regFlt_regInt_regInt(InstShift &inst) = 0;
  virtual std::string regFlt_regInt_extInt(InstShift &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstShift &inst) = 0;
  virtual std::string regFlt_regFlt_posByte(InstShift &inst) = 0;
  virtual std::string regFlt_regInt_negByte(InstShift &inst) = 0;
  virtual std::string regFlt_regFlt_negByte(InstShift &inst) = 0;

  virtual std::string regFlt_posByte(InstLd &inst) = 0;
  virtual std::string regFlt_negByte(InstLd &inst) = 0;
  virtual std::string regFlt_posWord(InstLd &inst) = 0;
  virtual std::string regFlt_negWord(InstLd &inst) = 0;
  virtual std::string regFlt_extFlt(InstLd &inst) = 0;
  virtual std::string regFlt_extInt(InstLd &inst) = 0;
  virtual std::string regInt_posByte(InstLd &inst) = 0;
  virtual std::string regInt_negByte(InstLd &inst) = 0;
  virtual std::string regInt_posWord(InstLd &inst) = 0;
  virtual std::string regInt_negWord(InstLd &inst) = 0;
  virtual std::string regInt_extInt(InstLd &inst) = 0;
  virtual std::string regStr_immStr(InstLd &inst) = 0;
  virtual std::string regStr_extStr(InstLd &inst) = 0;
  virtual std::string extFlt_posByte(InstLd &inst) = 0;
  virtual std::string extFlt_negByte(InstLd &inst) = 0;
  virtual std::string extFlt_posWord(InstLd &inst) = 0;
  virtual std::string extFlt_negWord(InstLd &inst) = 0;
  virtual std::string extFlt_regFlt(InstLd &inst) = 0;
  virtual std::string extFlt_regInt(InstLd &inst) = 0;
  virtual std::string extInt_posByte(InstLd &inst) = 0;
  virtual std::string extInt_negByte(InstLd &inst) = 0;
  virtual std::string extInt_posWord(InstLd &inst) = 0;
  virtual std::string extInt_negWord(InstLd &inst) = 0;
  virtual std::string extInt_regInt(InstLd &inst) = 0;
  virtual std::string extStr_immStr(InstLd &inst) = 0;
  virtual std::string extStr_regStr(InstLd &inst) = 0;
  virtual std::string indFlt_posByte(InstLd &inst) = 0;
  virtual std::string indFlt_negByte(InstLd &inst) = 0;
  virtual std::string indFlt_posWord(InstLd &inst) = 0;
  virtual std::string indFlt_negWord(InstLd &inst) = 0;
  virtual std::string indFlt_regFlt(InstLd &inst) = 0;
  virtual std::string indFlt_regInt(InstLd &inst) = 0;
  virtual std::string indInt_posByte(InstLd &inst) = 0;
  virtual std::string indInt_negByte(InstLd &inst) = 0;
  virtual std::string indInt_posWord(InstLd &inst) = 0;
  virtual std::string indInt_negWord(InstLd &inst) = 0;
  virtual std::string indInt_regInt(InstLd &inst) = 0;
  virtual std::string indStr_immStr(InstLd &inst) = 0;
  virtual std::string indStr_regStr(InstLd &inst) = 0;

  virtual std::string regStr_regStr(InstStrInit &inst) = 0;
  virtual std::string regStr_extStr(InstStrInit &inst) = 0;
  virtual std::string regStr_immStr(InstStrInit &inst) = 0;

  virtual std::string regStr_regStr_regStr(InstStrCat &inst) = 0;
  virtual std::string regStr_regStr_extStr(InstStrCat &inst) = 0;
  virtual std::string regStr_regStr_immStr(InstStrCat &inst) = 0;

  virtual std::string regStr(InstInkey &inst) = 0;
  virtual std::string regInt(InstMem &inst) = 0;

  virtual std::string regInt_regInt(InstNeg &inst) = 0;
  virtual std::string regInt_extInt(InstNeg &inst) = 0;
  virtual std::string regFlt_regFlt(InstNeg &inst) = 0;
  virtual std::string regFlt_extFlt(InstNeg &inst) = 0;

  virtual std::string regInt_regInt(InstCom &inst) = 0;
  virtual std::string regInt_extInt(InstCom &inst) = 0;

  virtual std::string regInt_regInt(InstSgn &inst) = 0;
  virtual std::string regInt_regFlt(InstSgn &inst) = 0;
  virtual std::string regInt_extInt(InstSgn &inst) = 0;
  virtual std::string regInt_extFlt(InstSgn &inst) = 0;

  virtual std::string regFlt_regFlt(InstAbs &inst) = 0;
  virtual std::string regInt_regInt(InstAbs &inst) = 0;
  virtual std::string regFlt_extFlt(InstAbs &inst) = 0;
  virtual std::string regInt_extInt(InstAbs &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstOr &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstOr &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstOr &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstOr &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstOr &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstOr &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstAnd &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstAnd &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstAnd &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstAnd &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstAnd &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstAnd &inst) = 0;

  virtual std::string regInt_posByte(InstIRnd &inst) = 0;
  virtual std::string regInt_posWord(InstIRnd &inst) = 0;

  virtual std::string regFlt_posByte(InstRnd &inst) = 0;
  virtual std::string regFlt_negByte(InstRnd &inst) = 0;
  virtual std::string regFlt_posWord(InstRnd &inst) = 0;
  virtual std::string regFlt_negWord(InstRnd &inst) = 0;
  virtual std::string regFlt_regInt(InstRnd &inst) = 0;
  virtual std::string regFlt_extInt(InstRnd &inst) = 0;

  virtual std::string regFlt_regInt(InstInv &inst) = 0;
  virtual std::string regFlt_regFlt(InstInv &inst) = 0;

  virtual std::string regFlt_regInt(InstSqr &inst) = 0;
  virtual std::string regFlt_regFlt(InstSqr &inst) = 0;

  virtual std::string regFlt_regInt(InstExp &inst) = 0;
  virtual std::string regFlt_regFlt(InstExp &inst) = 0;

  virtual std::string regFlt_regInt(InstLog &inst) = 0;
  virtual std::string regFlt_regFlt(InstLog &inst) = 0;

  virtual std::string regFlt_regInt(InstSin &inst) = 0;
  virtual std::string regFlt_regFlt(InstSin &inst) = 0;

  virtual std::string regFlt_regInt(InstCos &inst) = 0;
  virtual std::string regFlt_regFlt(InstCos &inst) = 0;

  virtual std::string regFlt_regInt(InstTan &inst) = 0;
  virtual std::string regFlt_regFlt(InstTan &inst) = 0;

  virtual std::string regInt_regStr(InstAsc &inst) = 0;
  virtual std::string regInt_extStr(InstAsc &inst) = 0;

  virtual std::string regInt_regStr(InstLen &inst) = 0;
  virtual std::string regInt_extStr(InstLen &inst) = 0;

  virtual std::string regStr_regInt(InstChr &inst) = 0;
  virtual std::string regStr_extInt(InstChr &inst) = 0;

  virtual std::string regStr_regInt(InstStr &inst) = 0;
  virtual std::string regStr_regFlt(InstStr &inst) = 0;
  virtual std::string regStr_extInt(InstStr &inst) = 0;
  virtual std::string regStr_extFlt(InstStr &inst) = 0;

  virtual std::string regFlt_regStr(InstVal &inst) = 0;
  virtual std::string regFlt_extStr(InstVal &inst) = 0;

  virtual std::string regStr_regStr_regInt(InstLeft &inst) = 0;
  virtual std::string regStr_regStr_extInt(InstLeft &inst) = 0;
  virtual std::string regStr_regStr_posByte(InstLeft &inst) = 0;

  virtual std::string regStr_regStr_regInt(InstMid &inst) = 0;
  virtual std::string regStr_regStr_extInt(InstMid &inst) = 0;
  virtual std::string regStr_regStr_posByte(InstMid &inst) = 0;

  virtual std::string regStr_regStr_regInt(InstMidT &inst) = 0;
  virtual std::string regStr_regStr_extInt(InstMidT &inst) = 0;
  virtual std::string regStr_regStr_posByte(InstMidT &inst) = 0;

  virtual std::string regStr_regStr_regInt(InstRight &inst) = 0;
  virtual std::string regStr_regStr_extInt(InstRight &inst) = 0;
  virtual std::string regStr_regStr_posByte(InstRight &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_regFlt(InstLdEq &inst) = 0;
  virtual std::string regInt_regInt_extFlt(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_posByte(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_negByte(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_posWord(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_negWord(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_regInt(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_extInt(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_regFlt(InstLdEq &inst) = 0;
  virtual std::string regInt_regFlt_extFlt(InstLdEq &inst) = 0;
  virtual std::string regInt_regStr_regStr(InstLdEq &inst) = 0;
  virtual std::string regInt_regStr_extStr(InstLdEq &inst) = 0;
  virtual std::string regInt_regStr_immStr(InstLdEq &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_regFlt(InstLdNe &inst) = 0;
  virtual std::string regInt_regInt_extFlt(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_posByte(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_negByte(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_posWord(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_negWord(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_regInt(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_extInt(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_regFlt(InstLdNe &inst) = 0;
  virtual std::string regInt_regFlt_extFlt(InstLdNe &inst) = 0;
  virtual std::string regInt_regStr_regStr(InstLdNe &inst) = 0;
  virtual std::string regInt_regStr_extStr(InstLdNe &inst) = 0;
  virtual std::string regInt_regStr_immStr(InstLdNe &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_regFlt(InstLdLt &inst) = 0;
  virtual std::string regInt_regInt_extFlt(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_posByte(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_negByte(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_posWord(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_negWord(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_regInt(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_extInt(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_regFlt(InstLdLt &inst) = 0;
  virtual std::string regInt_regFlt_extFlt(InstLdLt &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_regFlt(InstLdGe &inst) = 0;
  virtual std::string regInt_regInt_extFlt(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_posByte(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_negByte(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_posWord(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_negWord(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_regInt(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_extInt(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_regFlt(InstLdGe &inst) = 0;
  virtual std::string regInt_regFlt_extFlt(InstLdGe &inst) = 0;

  virtual std::string regInt_regStr_regStr(InstLdLo &inst) = 0;
  virtual std::string regInt_regStr_extStr(InstLdLo &inst) = 0;
  virtual std::string regInt_regStr_immStr(InstLdLo &inst) = 0;
  virtual std::string regInt_regStr_regStr(InstLdHs &inst) = 0;
  virtual std::string regInt_regStr_extStr(InstLdHs &inst) = 0;
  virtual std::string regInt_regStr_immStr(InstLdHs &inst) = 0;

  virtual std::string regInt_regInt(InstPeek &inst) = 0;
  virtual std::string regInt_extInt(InstPeek &inst) = 0;
  virtual std::string regInt_posWord(InstPeek &inst) = 0;
  virtual std::string regInt_posByte(InstPeek &inst) = 0;

  virtual std::string posByte_regInt(InstPoke &inst) = 0;
  virtual std::string posByte_extInt(InstPoke &inst) = 0;
  virtual std::string posWord_regInt(InstPoke &inst) = 0;
  virtual std::string posWord_extInt(InstPoke &inst) = 0;
  virtual std::string regInt_posByte(InstPoke &inst) = 0;
  virtual std::string regInt_regInt(InstPoke &inst) = 0;
  virtual std::string regInt_extInt(InstPoke &inst) = 0;
  virtual std::string extInt_posByte(InstPoke &inst) = 0;
  virtual std::string extInt_regInt(InstPoke &inst) = 0;

  virtual std::string extInt_posByte(InstFor &inst) = 0;
  virtual std::string extInt_negByte(InstFor &inst) = 0;
  virtual std::string extInt_posWord(InstFor &inst) = 0;
  virtual std::string extInt_negWord(InstFor &inst) = 0;
  virtual std::string extInt_regInt(InstFor &inst) = 0;
  virtual std::string extFlt_posByte(InstFor &inst) = 0;
  virtual std::string extFlt_negByte(InstFor &inst) = 0;
  virtual std::string extFlt_posWord(InstFor &inst) = 0;
  virtual std::string extFlt_negWord(InstFor &inst) = 0;
  virtual std::string extFlt_regInt(InstFor &inst) = 0;
  virtual std::string extFlt_regFlt(InstFor &inst) = 0;

  virtual std::string ptrInt_posByte(InstTo &inst) = 0;
  virtual std::string ptrInt_negByte(InstTo &inst) = 0;
  virtual std::string ptrInt_posWord(InstTo &inst) = 0;
  virtual std::string ptrInt_negWord(InstTo &inst) = 0;
  virtual std::string ptrInt_regInt(InstTo &inst) = 0;
  virtual std::string ptrInt_extInt(InstTo &inst) = 0;
  virtual std::string ptrInt_regFlt(InstTo &inst) = 0;
  virtual std::string ptrInt_extFlt(InstTo &inst) = 0;
  virtual std::string ptrFlt_posByte(InstTo &inst) = 0;
  virtual std::string ptrFlt_negByte(InstTo &inst) = 0;
  virtual std::string ptrFlt_posWord(InstTo &inst) = 0;
  virtual std::string ptrFlt_negWord(InstTo &inst) = 0;
  virtual std::string ptrFlt_regInt(InstTo &inst) = 0;
  virtual std::string ptrFlt_extInt(InstTo &inst) = 0;
  virtual std::string ptrFlt_regFlt(InstTo &inst) = 0;
  virtual std::string ptrFlt_extFlt(InstTo &inst) = 0;

  virtual std::string regInt_immLbls(InstOnGoTo &inst) = 0;
  virtual std::string regInt_immLbls(InstOnGoSub &inst) = 0;

  virtual std::string immStr(InstPr &inst) = 0;
  virtual std::string regStr(InstPr &inst) = 0;
  virtual std::string extStr(InstPr &inst) = 0;

  virtual std::string posByte(InstPrAt &inst) = 0;
  virtual std::string posWord(InstPrAt &inst) = 0;
  virtual std::string regInt(InstPrAt &inst) = 0;
  virtual std::string extInt(InstPrAt &inst) = 0;

  virtual std::string posByte(InstPrTab &inst) = 0;
  virtual std::string regInt(InstPrTab &inst) = 0;
  virtual std::string extInt(InstPrTab &inst) = 0;

  virtual std::string regInt_posByte(InstSet &inst) = 0;
  virtual std::string regInt_regInt(InstSet &inst) = 0;
  virtual std::string regInt_extInt(InstSet &inst) = 0;

  virtual std::string regInt_regInt_posByte(InstSetC &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstSetC &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstSetC &inst) = 0;

  virtual std::string regInt_regInt_regInt(InstPoint &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstPoint &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstPoint &inst) = 0;

  virtual std::string regInt_posByte(InstReset &inst) = 0;
  virtual std::string regInt_regInt(InstReset &inst) = 0;
  virtual std::string regInt_extInt(InstReset &inst) = 0;

  virtual std::string posByte(InstClsN &inst) = 0;
  virtual std::string regInt(InstClsN &inst) = 0;
  virtual std::string extInt(InstClsN &inst) = 0;

  virtual std::string extFlt(InstReadBuf &inst) = 0;
  virtual std::string indFlt(InstReadBuf &inst) = 0;
  virtual std::string extStr(InstReadBuf &inst) = 0;
  virtual std::string indStr(InstReadBuf &inst) = 0;

  virtual std::string indInt(InstRead &inst) = 0;
  virtual std::string indFlt(InstRead &inst) = 0;
  virtual std::string indStr(InstRead &inst) = 0;
  virtual std::string extInt(InstRead &inst) = 0;
  virtual std::string extFlt(InstRead &inst) = 0;
  virtual std::string extStr(InstRead &inst) = 0;

  virtual std::string regInt_regInt(InstSound &inst) = 0;

  virtual std::string indFlt_indFlt_regFlt(InstAdd &inst) = 0;
  virtual std::string indFlt_indFlt_regInt(InstAdd &inst) = 0;
  virtual std::string indFlt_indFlt_posByte(InstAdd &inst) = 0;
  virtual std::string indFlt_indFlt_negByte(InstAdd &inst) = 0;
  virtual std::string indFlt_indFlt_posWord(InstAdd &inst) = 0;
  virtual std::string indFlt_indFlt_negWord(InstAdd &inst) = 0;
  virtual std::string indInt_indInt_regInt(InstAdd &inst) = 0;
  virtual std::string indInt_indInt_posByte(InstAdd &inst) = 0;
  virtual std::string indInt_indInt_negByte(InstAdd &inst) = 0;
  virtual std::string indInt_indInt_posWord(InstAdd &inst) = 0;
  virtual std::string indInt_indInt_negWord(InstAdd &inst) = 0;
  virtual std::string extFlt_extFlt_regFlt(InstAdd &inst) = 0;
  virtual std::string extFlt_extFlt_regInt(InstAdd &inst) = 0;
  virtual std::string extFlt_extFlt_posByte(InstAdd &inst) = 0;
  virtual std::string extFlt_extFlt_negByte(InstAdd &inst) = 0;
  virtual std::string extFlt_extFlt_posWord(InstAdd &inst) = 0;
  virtual std::string extFlt_extFlt_negWord(InstAdd &inst) = 0;
  virtual std::string extInt_extInt_regInt(InstAdd &inst) = 0;
  virtual std::string extInt_extInt_posByte(InstAdd &inst) = 0;
  virtual std::string extInt_extInt_negByte(InstAdd &inst) = 0;
  virtual std::string extInt_extInt_posWord(InstAdd &inst) = 0;
  virtual std::string extInt_extInt_negWord(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_regFlt(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_regInt(InstAdd &inst) = 0;
  virtual std::string regFlt_regInt_regFlt(InstAdd &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_extFlt(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_extInt(InstAdd &inst) = 0;
  virtual std::string regFlt_regInt_extFlt(InstAdd &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_posByte(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_negByte(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_posWord(InstAdd &inst) = 0;
  virtual std::string regFlt_regFlt_negWord(InstAdd &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstAdd &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstAdd &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstAdd &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstAdd &inst) = 0;
  virtual std::string regFlt_extFlt_posByte(InstAdd &inst) = 0;
  virtual std::string regFlt_extFlt_negByte(InstAdd &inst) = 0;
  virtual std::string regFlt_extFlt_posWord(InstAdd &inst) = 0;
  virtual std::string regFlt_extFlt_negWord(InstAdd &inst) = 0;
  virtual std::string regInt_extInt_posByte(InstAdd &inst) = 0;
  virtual std::string regInt_extInt_negByte(InstAdd &inst) = 0;
  virtual std::string regInt_extInt_posWord(InstAdd &inst) = 0;
  virtual std::string regInt_extInt_negWord(InstAdd &inst) = 0;
  virtual std::string regFlt_posByte_extFlt(InstAdd &inst) = 0;
  virtual std::string regFlt_negByte_extFlt(InstAdd &inst) = 0;
  virtual std::string regFlt_posWord_extFlt(InstAdd &inst) = 0;
  virtual std::string regFlt_negWord_extFlt(InstAdd &inst) = 0;
  virtual std::string regInt_posByte_extInt(InstAdd &inst) = 0;
  virtual std::string regInt_negByte_extInt(InstAdd &inst) = 0;
  virtual std::string regInt_posWord_extInt(InstAdd &inst) = 0;
  virtual std::string regInt_negWord_extInt(InstAdd &inst) = 0;

  virtual std::string indFlt_indFlt_regFlt(InstSub &inst) = 0;
  virtual std::string indFlt_indFlt_regInt(InstSub &inst) = 0;
  virtual std::string indFlt_indFlt_posByte(InstSub &inst) = 0;
  virtual std::string indFlt_indFlt_negByte(InstSub &inst) = 0;
  virtual std::string indFlt_indFlt_posWord(InstSub &inst) = 0;
  virtual std::string indFlt_indFlt_negWord(InstSub &inst) = 0;
  virtual std::string indInt_indInt_regInt(InstSub &inst) = 0;
  virtual std::string indInt_indInt_posByte(InstSub &inst) = 0;
  virtual std::string indInt_indInt_negByte(InstSub &inst) = 0;
  virtual std::string indInt_indInt_posWord(InstSub &inst) = 0;
  virtual std::string indInt_indInt_negWord(InstSub &inst) = 0;
  virtual std::string extFlt_extFlt_regFlt(InstSub &inst) = 0;
  virtual std::string extFlt_extFlt_regInt(InstSub &inst) = 0;
  virtual std::string extFlt_extFlt_posByte(InstSub &inst) = 0;
  virtual std::string extFlt_extFlt_negByte(InstSub &inst) = 0;
  virtual std::string extFlt_extFlt_posWord(InstSub &inst) = 0;
  virtual std::string extFlt_extFlt_negWord(InstSub &inst) = 0;
  virtual std::string extInt_extInt_regInt(InstSub &inst) = 0;
  virtual std::string extInt_extInt_posByte(InstSub &inst) = 0;
  virtual std::string extInt_extInt_negByte(InstSub &inst) = 0;
  virtual std::string extInt_extInt_posWord(InstSub &inst) = 0;
  virtual std::string extInt_extInt_negWord(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_regFlt(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_regInt(InstSub &inst) = 0;
  virtual std::string regFlt_regInt_regFlt(InstSub &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_extFlt(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_extInt(InstSub &inst) = 0;
  virtual std::string regFlt_regInt_extFlt(InstSub &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_posByte(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_negByte(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_posWord(InstSub &inst) = 0;
  virtual std::string regFlt_regFlt_negWord(InstSub &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstSub &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstSub &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstSub &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstSub &inst) = 0;
  virtual std::string regFlt_extFlt_posByte(InstSub &inst) = 0;
  virtual std::string regFlt_extFlt_negByte(InstSub &inst) = 0;
  virtual std::string regFlt_extFlt_posWord(InstSub &inst) = 0;
  virtual std::string regFlt_extFlt_negWord(InstSub &inst) = 0;
  virtual std::string regInt_extInt_posByte(InstSub &inst) = 0;
  virtual std::string regInt_extInt_negByte(InstSub &inst) = 0;
  virtual std::string regInt_extInt_posWord(InstSub &inst) = 0;
  virtual std::string regInt_extInt_negWord(InstSub &inst) = 0;
  virtual std::string regFlt_posByte_extFlt(InstSub &inst) = 0;
  virtual std::string regFlt_negByte_extFlt(InstSub &inst) = 0;
  virtual std::string regFlt_posWord_extFlt(InstSub &inst) = 0;
  virtual std::string regFlt_negWord_extFlt(InstSub &inst) = 0;
  virtual std::string regInt_posByte_extInt(InstSub &inst) = 0;
  virtual std::string regInt_negByte_extInt(InstSub &inst) = 0;
  virtual std::string regInt_posWord_extInt(InstSub &inst) = 0;
  virtual std::string regInt_negWord_extInt(InstSub &inst) = 0;

  virtual std::string regFlt_regFlt_regFlt(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_extFlt(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_regInt(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_extInt(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_posByte(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_negByte(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_posWord(InstMul &inst) = 0;
  virtual std::string regFlt_regFlt_negWord(InstMul &inst) = 0;
  virtual std::string regFlt_regInt_regFlt(InstMul &inst) = 0;
  virtual std::string regFlt_regInt_extFlt(InstMul &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstMul &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstMul &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstMul &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstMul &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstMul &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstMul &inst) = 0;

  virtual std::string regFlt_regFlt_regFlt(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_extFlt(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_regInt(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_extInt(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_posByte(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_negByte(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_posWord(InstDiv &inst) = 0;
  virtual std::string regFlt_regFlt_negWord(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_regFlt(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_extFlt(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_regInt(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_extInt(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_posByte(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_negByte(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_posWord(InstDiv &inst) = 0;
  virtual std::string regFlt_regInt_negWord(InstDiv &inst) = 0;

  virtual std::string regInt_regFlt_regFlt(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_extFlt(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_regInt(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_extInt(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_posByte(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_negByte(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_posWord(InstIDiv &inst) = 0;
  virtual std::string regInt_regFlt_negWord(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_regFlt(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_extFlt(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_regInt(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_extInt(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_negByte(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstIDiv &inst) = 0;
  virtual std::string regInt_regInt_negWord(InstIDiv &inst) = 0;

  virtual std::string regInt_regInt(InstIDiv3 &inst) = 0;
  virtual std::string regInt_extInt(InstIDiv3 &inst) = 0;
  virtual std::string regInt_regInt(InstIDiv5 &inst) = 0;
  virtual std::string regInt_extInt(InstIDiv5 &inst) = 0;

  virtual std::string regFlt_regFlt_regFlt(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_extFlt(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_regInt(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_extInt(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_posByte(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_negByte(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_posWord(InstPow &inst) = 0;
  virtual std::string regFlt_regFlt_negWord(InstPow &inst) = 0;
  virtual std::string regFlt_regInt_regFlt(InstPow &inst) = 0;
  virtual std::string regFlt_regInt_extFlt(InstPow &inst) = 0;
  virtual std::string regFlt_regInt_regInt(InstPow &inst) = 0;
  virtual std::string regFlt_regInt_extInt(InstPow &inst) = 0;
  virtual std::string regInt_regInt_posByte(InstPow &inst) = 0;
  virtual std::string regFlt_regInt_negByte(InstPow &inst) = 0;
  virtual std::string regInt_regInt_posWord(InstPow &inst) = 0;
  virtual std::string regFlt_regInt_negWord(InstPow &inst) = 0;
};
#endif
