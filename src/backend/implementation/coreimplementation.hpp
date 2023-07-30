// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_IMPLEMENTATION_COREIMPLEMENTATION_HPP
#define BACKEND_IMPLEMENTATION_COREIMPLEMENTATION_HPP

#include "backend/assembler/assembler.hpp"
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
  std::string inherent(InstPrComma &inst) override;
  std::string inherent(InstInputBuf &inst) override;
  std::string inherent(InstIgnoreExtra &inst) override;
  std::string inherent(InstRestore &inst) override;
  std::string inherent(InstNext &inst) override;

  std::string posByte(InstError &inst) override;

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

  std::string regFlt_regFlt_regInt(InstShift &inst) override;
  std::string regFlt_regFlt_extInt(InstShift &inst) override;
  std::string regFlt_regInt_regInt(InstShift &inst) override;
  std::string regFlt_regInt_extInt(InstShift &inst) override;
  std::string regInt_regInt_posByte(InstShift &inst) override;
  std::string regFlt_regFlt_posByte(InstShift &inst) override;
  std::string regFlt_regInt_negByte(InstShift &inst) override;
  std::string regFlt_regFlt_negByte(InstShift &inst) override;

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
  std::string dexFlt_extFlt(InstLd &inst) override;
  std::string dexFlt_extInt(InstLd &inst) override;
  std::string dexInt_extInt(InstLd &inst) override;
  std::string dexStr_extStr(InstLd &inst) override;
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
  std::string extStr(InstInkey &inst) override;
  std::string indStr(InstInkey &inst) override;

  std::string regInt(InstMem &inst) override;
  std::string regInt(InstPos &inst) override;
  std::string regInt(InstTimer &inst) override;

  std::string indFlt(InstOne &inst) override;
  std::string indInt(InstOne &inst) override;
  std::string extFlt(InstOne &inst) override;
  std::string extInt(InstOne &inst) override;

  std::string indFlt(InstTrue &inst) override;
  std::string indInt(InstTrue &inst) override;
  std::string extFlt(InstTrue &inst) override;
  std::string extInt(InstTrue &inst) override;

  std::string indFlt(InstClr &inst) override;
  std::string indInt(InstClr &inst) override;
  std::string extFlt(InstClr &inst) override;
  std::string extInt(InstClr &inst) override;

  std::string indFlt_indFlt(InstInc &inst) override;
  std::string indInt_indInt(InstInc &inst) override;
  std::string extFlt_extFlt(InstInc &inst) override;
  std::string extInt_extInt(InstInc &inst) override;
  std::string regFlt_regFlt(InstInc &inst) override;
  std::string regInt_regInt(InstInc &inst) override;
  std::string regFlt_extFlt(InstInc &inst) override;
  std::string regInt_extInt(InstInc &inst) override;

  std::string indFlt_indFlt(InstDec &inst) override;
  std::string indInt_indInt(InstDec &inst) override;
  std::string extFlt_extFlt(InstDec &inst) override;
  std::string extInt_extInt(InstDec &inst) override;
  std::string regFlt_regFlt(InstDec &inst) override;
  std::string regInt_regInt(InstDec &inst) override;
  std::string regFlt_extFlt(InstDec &inst) override;
  std::string regInt_extInt(InstDec &inst) override;

  std::string indFlt_indFlt(InstNeg &inst) override;
  std::string indInt_indInt(InstNeg &inst) override;
  std::string extFlt_extFlt(InstNeg &inst) override;
  std::string extInt_extInt(InstNeg &inst) override;
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

  std::string regFlt_regFlt(InstFract &inst) override;
  std::string regInt_regInt(InstFract &inst) override;
  std::string regFlt_extFlt(InstFract &inst) override;
  std::string regInt_extInt(InstFract &inst) override;

  std::string regFlt_regFlt(InstDbl &inst) override;
  std::string regInt_regInt(InstDbl &inst) override;
  std::string regFlt_extFlt(InstDbl &inst) override;
  std::string regInt_extInt(InstDbl &inst) override;

  std::string regFlt_regFlt(InstSq &inst) override;
  std::string regInt_regInt(InstSq &inst) override;
  std::string regFlt_extFlt(InstSq &inst) override;
  std::string regInt_extInt(InstSq &inst) override;

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

  std::string regFlt_regInt(InstHlf &inst) override;
  std::string regFlt_regFlt(InstHlf &inst) override;
  std::string regFlt_extInt(InstHlf &inst) override;
  std::string regFlt_extFlt(InstHlf &inst) override;

  std::string regFlt_regInt(InstSqr &inst) override;
  std::string regFlt_regFlt(InstSqr &inst) override;

  std::string regFlt_regInt(InstExp &inst) override;
  std::string regFlt_regFlt(InstExp &inst) override;

  std::string regFlt_regInt(InstLog &inst) override;
  std::string regFlt_regFlt(InstLog &inst) override;

  std::string regFlt_regInt(InstSin &inst) override;
  std::string regFlt_regFlt(InstSin &inst) override;

  std::string regFlt_regInt(InstCos &inst) override;
  std::string regFlt_regFlt(InstCos &inst) override;

  std::string regFlt_regInt(InstTan &inst) override;
  std::string regFlt_regFlt(InstTan &inst) override;

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
  std::string regInt_extInt_dexInt(InstLdEq &inst) override;
  std::string regInt_extInt_dexFlt(InstLdEq &inst) override;
  std::string regInt_extFlt_dexInt(InstLdEq &inst) override;
  std::string regInt_extFlt_dexFlt(InstLdEq &inst) override;
  std::string regInt_regStr_regStr(InstLdEq &inst) override;
  std::string regInt_regStr_extStr(InstLdEq &inst) override;
  std::string regInt_extStr_dexStr(InstLdEq &inst) override;
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
  std::string regInt_extInt_dexInt(InstLdNe &inst) override;
  std::string regInt_extInt_dexFlt(InstLdNe &inst) override;
  std::string regInt_extFlt_dexInt(InstLdNe &inst) override;
  std::string regInt_extFlt_dexFlt(InstLdNe &inst) override;
  std::string regInt_regStr_regStr(InstLdNe &inst) override;
  std::string regInt_regStr_extStr(InstLdNe &inst) override;
  std::string regInt_extStr_dexStr(InstLdNe &inst) override;
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
  std::string regInt_extInt_dexInt(InstLdLt &inst) override;
  std::string regInt_extInt_dexFlt(InstLdLt &inst) override;
  std::string regInt_extFlt_dexInt(InstLdLt &inst) override;
  std::string regInt_extFlt_dexFlt(InstLdLt &inst) override;

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
  std::string regInt_extInt_dexInt(InstLdGe &inst) override;
  std::string regInt_extInt_dexFlt(InstLdGe &inst) override;
  std::string regInt_extFlt_dexInt(InstLdGe &inst) override;
  std::string regInt_extFlt_dexFlt(InstLdGe &inst) override;

  std::string regInt_regStr_regStr(InstLdLt &inst) override;
  std::string regInt_regStr_extStr(InstLdLt &inst) override;
  std::string regInt_extStr_dexStr(InstLdLt &inst) override;
  std::string regInt_regStr_immStr(InstLdLt &inst) override;
  std::string regInt_regStr_regStr(InstLdGe &inst) override;
  std::string regInt_regStr_extStr(InstLdGe &inst) override;
  std::string regInt_extStr_dexStr(InstLdGe &inst) override;
  std::string regInt_regStr_immStr(InstLdGe &inst) override;

  std::string regInt_regInt(InstPeek &inst) override;
  std::string regInt_extInt(InstPeek &inst) override;
  std::string regInt_posWord(InstPeek &inst) override;
  std::string regInt_posByte(InstPeek &inst) override;

  std::string regInt_regInt(InstPeekWord &inst) override;
  std::string regInt_extInt(InstPeekWord &inst) override;
  std::string regInt_posWord(InstPeekWord &inst) override;
  std::string regInt_posByte(InstPeekWord &inst) override;

  std::string posByte_regInt(InstPoke &inst) override;
  std::string posByte_extInt(InstPoke &inst) override;
  std::string posWord_regInt(InstPoke &inst) override;
  std::string posWord_extInt(InstPoke &inst) override;
  std::string regInt_posByte(InstPoke &inst) override;
  std::string regInt_regInt(InstPoke &inst) override;
  std::string regInt_extInt(InstPoke &inst) override;
  std::string extInt_posByte(InstPoke &inst) override;
  std::string extInt_regInt(InstPoke &inst) override;
  std::string dexInt_extInt(InstPoke &inst) override;

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
  std::string dexInt_extInt(InstFor &inst) override;
  std::string dexFlt_extInt(InstFor &inst) override;
  std::string dexFlt_extFlt(InstFor &inst) override;

  std::string extFlt(InstForOne &inst) override;
  std::string extInt(InstForOne &inst) override;

  std::string extFlt(InstForTrue &inst) override;
  std::string extInt(InstForTrue &inst) override;

  std::string extFlt(InstForClr &inst) override;
  std::string extInt(InstForClr &inst) override;

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

  std::string posByte(InstExec &inst) override;
  std::string posWord(InstExec &inst) override;
  std::string regInt(InstExec &inst) override;
  std::string extInt(InstExec &inst) override;

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
  std::string regFlt_extFlt_dexFlt(InstAdd &inst) override;
  std::string regFlt_extFlt_dexInt(InstAdd &inst) override;
  std::string regFlt_extInt_dexFlt(InstAdd &inst) override;
  std::string regInt_extInt_dexInt(InstAdd &inst) override;

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
  std::string regFlt_extFlt_dexFlt(InstSub &inst) override;
  std::string regFlt_extFlt_dexInt(InstSub &inst) override;
  std::string regFlt_extInt_dexFlt(InstSub &inst) override;
  std::string regInt_extInt_dexInt(InstSub &inst) override;

  std::string indFlt_indFlt_regFlt(InstRSub &inst) override;
  std::string indFlt_indFlt_regInt(InstRSub &inst) override;
  std::string indFlt_indFlt_posByte(InstRSub &inst) override;
  std::string indFlt_indFlt_negByte(InstRSub &inst) override;
  std::string indFlt_indFlt_posWord(InstRSub &inst) override;
  std::string indFlt_indFlt_negWord(InstRSub &inst) override;
  std::string indInt_indInt_regInt(InstRSub &inst) override;
  std::string indInt_indInt_posByte(InstRSub &inst) override;
  std::string indInt_indInt_negByte(InstRSub &inst) override;
  std::string indInt_indInt_posWord(InstRSub &inst) override;
  std::string indInt_indInt_negWord(InstRSub &inst) override;
  std::string extFlt_extFlt_regFlt(InstRSub &inst) override;
  std::string extFlt_extFlt_regInt(InstRSub &inst) override;
  std::string extFlt_extFlt_posByte(InstRSub &inst) override;
  std::string extFlt_extFlt_negByte(InstRSub &inst) override;
  std::string extFlt_extFlt_posWord(InstRSub &inst) override;
  std::string extFlt_extFlt_negWord(InstRSub &inst) override;
  std::string extInt_extInt_regInt(InstRSub &inst) override;
  std::string extInt_extInt_posByte(InstRSub &inst) override;
  std::string extInt_extInt_negByte(InstRSub &inst) override;
  std::string extInt_extInt_posWord(InstRSub &inst) override;
  std::string extInt_extInt_negWord(InstRSub &inst) override;
  std::string regFlt_regFlt_regFlt(InstRSub &inst) override;
  std::string regFlt_regFlt_regInt(InstRSub &inst) override;
  std::string regFlt_regInt_regFlt(InstRSub &inst) override;
  std::string regInt_regInt_regInt(InstRSub &inst) override;
  std::string regFlt_regFlt_extFlt(InstRSub &inst) override;
  std::string regFlt_regFlt_extInt(InstRSub &inst) override;
  std::string regFlt_regInt_extFlt(InstRSub &inst) override;
  std::string regInt_regInt_extInt(InstRSub &inst) override;
  std::string regFlt_regFlt_posByte(InstRSub &inst) override;
  std::string regFlt_regFlt_negByte(InstRSub &inst) override;
  std::string regFlt_regFlt_posWord(InstRSub &inst) override;
  std::string regFlt_regFlt_negWord(InstRSub &inst) override;
  std::string regInt_regInt_posByte(InstRSub &inst) override;
  std::string regInt_regInt_negByte(InstRSub &inst) override;
  std::string regInt_regInt_posWord(InstRSub &inst) override;
  std::string regInt_regInt_negWord(InstRSub &inst) override;
  std::string regFlt_extFlt_posByte(InstRSub &inst) override;
  std::string regFlt_extFlt_negByte(InstRSub &inst) override;
  std::string regFlt_extFlt_posWord(InstRSub &inst) override;
  std::string regFlt_extFlt_negWord(InstRSub &inst) override;
  std::string regInt_extInt_posByte(InstRSub &inst) override;
  std::string regInt_extInt_negByte(InstRSub &inst) override;
  std::string regInt_extInt_posWord(InstRSub &inst) override;
  std::string regInt_extInt_negWord(InstRSub &inst) override;
  std::string regFlt_posByte_extFlt(InstRSub &inst) override;
  std::string regFlt_negByte_extFlt(InstRSub &inst) override;
  std::string regFlt_posWord_extFlt(InstRSub &inst) override;
  std::string regFlt_negWord_extFlt(InstRSub &inst) override;
  std::string regInt_posByte_extInt(InstRSub &inst) override;
  std::string regInt_negByte_extInt(InstRSub &inst) override;
  std::string regInt_posWord_extInt(InstRSub &inst) override;
  std::string regInt_negWord_extInt(InstRSub &inst) override;

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

  std::string regFlt_regFlt(InstMul3 &inst) override;
  std::string regInt_regInt(InstMul3 &inst) override;
  std::string regFlt_extFlt(InstMul3 &inst) override;
  std::string regInt_extInt(InstMul3 &inst) override;

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

  std::string regInt_regFlt_regFlt(InstIDiv &inst) override;
  std::string regInt_regFlt_extFlt(InstIDiv &inst) override;
  std::string regInt_regFlt_regInt(InstIDiv &inst) override;
  std::string regInt_regFlt_extInt(InstIDiv &inst) override;
  std::string regInt_regFlt_posByte(InstIDiv &inst) override;
  std::string regInt_regFlt_negByte(InstIDiv &inst) override;
  std::string regInt_regFlt_posWord(InstIDiv &inst) override;
  std::string regInt_regFlt_negWord(InstIDiv &inst) override;
  std::string regInt_regInt_regFlt(InstIDiv &inst) override;
  std::string regInt_regInt_extFlt(InstIDiv &inst) override;
  std::string regInt_regInt_regInt(InstIDiv &inst) override;
  std::string regInt_regInt_extInt(InstIDiv &inst) override;
  std::string regInt_regInt_posByte(InstIDiv &inst) override;
  std::string regInt_regInt_negByte(InstIDiv &inst) override;
  std::string regInt_regInt_posWord(InstIDiv &inst) override;
  std::string regInt_regInt_negWord(InstIDiv &inst) override;

  std::string regInt_regInt_posByte(InstIDiv5S &inst) override;

  std::string regInt_regInt(InstIDiv3 &inst) override;
  std::string regInt_extInt(InstIDiv3 &inst) override;
  std::string regInt_regInt(InstIDiv5 &inst) override;
  std::string regInt_extInt(InstIDiv5 &inst) override;

  std::string regFlt_regFlt_regFlt(InstPow &inst) override;
  std::string regFlt_regFlt_extFlt(InstPow &inst) override;
  std::string regFlt_regFlt_regInt(InstPow &inst) override;
  std::string regFlt_regFlt_extInt(InstPow &inst) override;
  std::string regFlt_regFlt_posByte(InstPow &inst) override;
  std::string regFlt_regFlt_negByte(InstPow &inst) override;
  std::string regFlt_regFlt_posWord(InstPow &inst) override;
  std::string regFlt_regFlt_negWord(InstPow &inst) override;
  std::string regFlt_regInt_regFlt(InstPow &inst) override;
  std::string regFlt_regInt_extFlt(InstPow &inst) override;
  std::string regFlt_regInt_regInt(InstPow &inst) override;
  std::string regFlt_regInt_extInt(InstPow &inst) override;
  std::string regInt_regInt_posByte(InstPow &inst) override;
  std::string regFlt_regInt_negByte(InstPow &inst) override;
  std::string regInt_regInt_posWord(InstPow &inst) override;
  std::string regFlt_regInt_negWord(InstPow &inst) override;

protected:
  virtual void preamble(Assembler &tasm, Instruction &inst);
};

#endif
