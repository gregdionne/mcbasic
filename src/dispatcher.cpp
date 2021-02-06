// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "dispatcher.hpp"

std::string Dispatcher::operate(Instruction &inst) {
  return implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstComment &inst) {
  return inst.arg1->isInherent() ? implementation->inherent(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLabel &inst) {
  return inst.arg1->isImmLin() ? implementation->immLin(inst)
                               : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayDim1 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayDim2 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayDim3 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayDim4 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayDim5 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayRef1 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayRef2 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayRef3 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayRef4 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayRef5 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayVal1 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayVal2 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayVal3 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayVal4 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayVal5 &inst) {
  return inst.isRegInt_extInt()   ? implementation->regInt_extInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstArrayDim &inst) {
  return implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstArrayRef &inst) {
  return implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstArrayVal &inst) {
  return implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstShift &inst) {
  return inst.isRegFlt_regFlt_regInt()
             ? implementation->regFlt_regFlt_regInt(inst)
         : inst.isRegFlt_regFlt_extInt()
             ? implementation->regFlt_regFlt_extInt(inst)
         : inst.isRegFlt_regInt_regInt()
             ? implementation->regFlt_regInt_regInt(inst)
         : inst.isRegFlt_regInt_extInt()
             ? implementation->regFlt_regInt_extInt(inst)
         : inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegFlt_regFlt_posByte()
             ? implementation->regFlt_regFlt_posByte(inst)
         : inst.isRegFlt_regInt_negByte()
             ? implementation->regFlt_regInt_negByte(inst)
         : inst.isRegFlt_regFlt_negByte()
             ? implementation->regFlt_regFlt_negByte(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLd &inst) {
  return inst.isRegFlt_posByte()   ? implementation->regFlt_posByte(inst)
         : inst.isRegFlt_negByte() ? implementation->regFlt_negByte(inst)
         : inst.isRegFlt_posWord() ? implementation->regFlt_posWord(inst)
         : inst.isRegFlt_negWord() ? implementation->regFlt_negWord(inst)
         : inst.isRegFlt_extFlt()  ? implementation->regFlt_extFlt(inst)
         : inst.isRegFlt_extInt()  ? implementation->regFlt_extInt(inst)
         : inst.isRegInt_posByte() ? implementation->regInt_posByte(inst)
         : inst.isRegInt_negByte() ? implementation->regInt_negByte(inst)
         : inst.isRegInt_posWord() ? implementation->regInt_posWord(inst)
         : inst.isRegInt_negWord() ? implementation->regInt_negWord(inst)
         : inst.isRegInt_extInt()  ? implementation->regInt_extInt(inst)
         : inst.isRegStr_immStr()  ? implementation->regStr_immStr(inst)
         : inst.isRegStr_extStr()  ? implementation->regStr_extStr(inst)
         : inst.isExtFlt_posByte() ? implementation->extFlt_posByte(inst)
         : inst.isExtFlt_negByte() ? implementation->extFlt_negByte(inst)
         : inst.isExtFlt_posWord() ? implementation->extFlt_posWord(inst)
         : inst.isExtFlt_negWord() ? implementation->extFlt_negWord(inst)
         : inst.isExtFlt_regFlt()  ? implementation->extFlt_regFlt(inst)
         : inst.isExtFlt_regInt()  ? implementation->extFlt_regInt(inst)
         : inst.isExtInt_posByte() ? implementation->extInt_posByte(inst)
         : inst.isExtInt_negByte() ? implementation->extInt_negByte(inst)
         : inst.isExtInt_posWord() ? implementation->extInt_posWord(inst)
         : inst.isExtInt_negWord() ? implementation->extInt_negWord(inst)
         : inst.isExtInt_regInt()  ? implementation->extInt_regInt(inst)
         : inst.isExtStr_immStr()  ? implementation->extStr_immStr(inst)
         : inst.isExtStr_regStr()  ? implementation->extStr_regStr(inst)
         : inst.isIndFlt_posByte() ? implementation->indFlt_posByte(inst)
         : inst.isIndFlt_negByte() ? implementation->indFlt_negByte(inst)
         : inst.isIndFlt_posWord() ? implementation->indFlt_posWord(inst)
         : inst.isIndFlt_negWord() ? implementation->indFlt_negWord(inst)
         : inst.isIndFlt_regFlt()  ? implementation->indFlt_regFlt(inst)
         : inst.isIndFlt_regInt()  ? implementation->indFlt_regInt(inst)
         : inst.isIndInt_posByte() ? implementation->indInt_posByte(inst)
         : inst.isIndInt_negByte() ? implementation->indInt_negByte(inst)
         : inst.isIndInt_posWord() ? implementation->indInt_posWord(inst)
         : inst.isIndInt_negWord() ? implementation->indInt_negWord(inst)
         : inst.isIndInt_regInt()  ? implementation->indInt_regInt(inst)
         : inst.isIndStr_immStr()  ? implementation->indStr_immStr(inst)
         : inst.isIndStr_regStr()  ? implementation->indStr_regStr(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstAbs &inst) {
  return inst.isRegFlt_regFlt()   ? implementation->regFlt_regFlt(inst)
         : inst.isRegInt_regInt() ? implementation->regInt_regInt(inst)
         : inst.isRegFlt_extFlt() ? implementation->regFlt_extFlt(inst)
         : inst.isRegInt_extInt() ? implementation->regInt_extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstNeg &inst) {
  return inst.isRegFlt_regFlt()   ? implementation->regFlt_regFlt(inst)
         : inst.isRegInt_regInt() ? implementation->regInt_regInt(inst)
         : inst.isRegFlt_extFlt() ? implementation->regFlt_extFlt(inst)
         : inst.isRegInt_extInt() ? implementation->regInt_extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstCom &inst) {
  return inst.isRegInt_regInt()   ? implementation->regInt_regInt(inst)
         : inst.isRegInt_extInt() ? implementation->regInt_extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstSgn &inst) {
  return inst.isRegInt_regFlt()   ? implementation->regInt_regFlt(inst)
         : inst.isRegInt_regInt() ? implementation->regInt_regInt(inst)
         : inst.isRegInt_extFlt() ? implementation->regInt_extFlt(inst)
         : inst.isRegInt_extInt() ? implementation->regInt_extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPeek &inst) {
  return inst.isRegInt_regInt()    ? implementation->regInt_regInt(inst)
         : inst.isRegInt_extInt()  ? implementation->regInt_extInt(inst)
         : inst.isRegInt_posByte() ? implementation->regInt_posByte(inst)
         : inst.isRegInt_posWord() ? implementation->regInt_posWord(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstInv &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstSqr &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstExp &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLog &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstSin &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstCos &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstTan &inst) {
  return inst.isRegFlt_regInt()   ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_regFlt() ? implementation->regFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstIRnd &inst) {
  return inst.isRegInt_posByte()   ? implementation->regInt_posByte(inst)
         : inst.isRegInt_posWord() ? implementation->regInt_posWord(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstRnd &inst) {
  return inst.isRegFlt_posByte()   ? implementation->regFlt_posByte(inst)
         : inst.isRegFlt_negByte() ? implementation->regFlt_negByte(inst)
         : inst.isRegFlt_posWord() ? implementation->regFlt_posWord(inst)
         : inst.isRegFlt_negWord() ? implementation->regFlt_negWord(inst)
         : inst.isRegFlt_posWord() ? implementation->regFlt_posWord(inst)
         : inst.isRegFlt_regInt()  ? implementation->regFlt_regInt(inst)
         : inst.isRegFlt_extInt()  ? implementation->regFlt_extInt(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstStr &inst) {
  return inst.isRegStr_regInt()   ? implementation->regStr_regInt(inst)
         : inst.isRegStr_regFlt() ? implementation->regStr_regFlt(inst)
         : inst.isRegStr_extInt() ? implementation->regStr_extInt(inst)
         : inst.isRegStr_extFlt() ? implementation->regStr_extFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstVal &inst) {
  return inst.isRegFlt_regStr()   ? implementation->regFlt_regStr(inst)
         : inst.isRegFlt_extStr() ? implementation->regFlt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstAsc &inst) {
  return inst.isRegInt_regStr()   ? implementation->regInt_regStr(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLen &inst) {
  return inst.isRegInt_regStr()   ? implementation->regInt_regStr(inst)
         : inst.isRegInt_extStr() ? implementation->regInt_extStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstChr &inst) {
  return inst.isRegStr_regInt()   ? implementation->regStr_regInt(inst)
         : inst.isRegStr_extInt() ? implementation->regStr_extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstInkey &inst) {
  return inst.arg1->isRegStr() ? implementation->regStr(inst)
                               : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstAdd &inst) {

  return inst.isIndFlt_indFlt_regFlt()
             ? implementation->indFlt_indFlt_regFlt(inst)
         : inst.isIndFlt_indFlt_regInt()
             ? implementation->indFlt_indFlt_regInt(inst)
         : inst.isIndFlt_indFlt_posByte()
             ? implementation->indFlt_indFlt_posByte(inst)
         : inst.isIndFlt_indFlt_negByte()
             ? implementation->indFlt_indFlt_negByte(inst)
         : inst.isIndFlt_indFlt_posWord()
             ? implementation->indFlt_indFlt_posWord(inst)
         : inst.isIndFlt_indFlt_negWord()
             ? implementation->indFlt_indFlt_negWord(inst)
         : inst.isIndInt_indInt_regInt()
             ? implementation->indInt_indInt_regInt(inst)
         : inst.isIndInt_indInt_posByte()
             ? implementation->indInt_indInt_posByte(inst)
         : inst.isIndInt_indInt_negByte()
             ? implementation->indInt_indInt_negByte(inst)
         : inst.isIndInt_indInt_posWord()
             ? implementation->indInt_indInt_posWord(inst)
         : inst.isIndInt_indInt_negWord()
             ? implementation->indInt_indInt_negWord(inst)
         : inst.isExtFlt_extFlt_regFlt()
             ? implementation->extFlt_extFlt_regFlt(inst)
         : inst.isExtFlt_extFlt_regInt()
             ? implementation->extFlt_extFlt_regInt(inst)
         : inst.isExtFlt_extFlt_posByte()
             ? implementation->extFlt_extFlt_posByte(inst)
         : inst.isExtFlt_extFlt_negByte()
             ? implementation->extFlt_extFlt_negByte(inst)
         : inst.isExtFlt_extFlt_posWord()
             ? implementation->extFlt_extFlt_posWord(inst)
         : inst.isExtFlt_extFlt_negWord()
             ? implementation->extFlt_extFlt_negWord(inst)
         : inst.isExtInt_extInt_regInt()
             ? implementation->extInt_extInt_regInt(inst)
         : inst.isExtInt_extInt_posByte()
             ? implementation->extInt_extInt_posByte(inst)
         : inst.isExtInt_extInt_negByte()
             ? implementation->extInt_extInt_negByte(inst)
         : inst.isExtInt_extInt_posWord()
             ? implementation->extInt_extInt_posWord(inst)
         : inst.isExtInt_extInt_negWord()
             ? implementation->extInt_extInt_negWord(inst)
         : inst.isRegFlt_regFlt_regFlt()
             ? implementation->regFlt_regFlt_regFlt(inst)
         : inst.isRegFlt_regFlt_regInt()
             ? implementation->regFlt_regFlt_regInt(inst)
         : inst.isRegFlt_regInt_regFlt()
             ? implementation->regFlt_regInt_regFlt(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegFlt_regFlt_extFlt()
             ? implementation->regFlt_regFlt_extFlt(inst)
         : inst.isRegFlt_regFlt_extInt()
             ? implementation->regFlt_regFlt_extInt(inst)
         : inst.isRegFlt_regInt_extFlt()
             ? implementation->regFlt_regInt_extFlt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegFlt_regFlt_posByte()
             ? implementation->regFlt_regFlt_posByte(inst)
         : inst.isRegFlt_regFlt_negByte()
             ? implementation->regFlt_regFlt_negByte(inst)
         : inst.isRegFlt_regFlt_posWord()
             ? implementation->regFlt_regFlt_posWord(inst)
         : inst.isRegFlt_regFlt_negWord()
             ? implementation->regFlt_regFlt_negWord(inst)
         : inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegFlt_extFlt_posByte()
             ? implementation->regFlt_extFlt_posByte(inst)
         : inst.isRegFlt_extFlt_negByte()
             ? implementation->regFlt_extFlt_negByte(inst)
         : inst.isRegFlt_extFlt_posWord()
             ? implementation->regFlt_extFlt_posWord(inst)
         : inst.isRegFlt_extFlt_negWord()
             ? implementation->regFlt_extFlt_negWord(inst)
         : inst.isRegInt_extInt_posByte()
             ? implementation->regInt_extInt_posByte(inst)
         : inst.isRegInt_extInt_negByte()
             ? implementation->regInt_extInt_negByte(inst)
         : inst.isRegInt_extInt_posWord()
             ? implementation->regInt_extInt_posWord(inst)
         : inst.isRegInt_extInt_negWord()
             ? implementation->regInt_extInt_negWord(inst)
         : inst.isRegFlt_posByte_extFlt()
             ? implementation->regFlt_posByte_extFlt(inst)
         : inst.isRegFlt_negByte_extFlt()
             ? implementation->regFlt_negByte_extFlt(inst)
         : inst.isRegFlt_posWord_extFlt()
             ? implementation->regFlt_posWord_extFlt(inst)
         : inst.isRegFlt_negWord_extFlt()
             ? implementation->regFlt_negWord_extFlt(inst)
         : inst.isRegInt_posByte_extInt()
             ? implementation->regInt_posByte_extInt(inst)
         : inst.isRegInt_negByte_extInt()
             ? implementation->regInt_negByte_extInt(inst)
         : inst.isRegInt_posWord_extInt()
             ? implementation->regInt_posWord_extInt(inst)
         : inst.isRegInt_negWord_extInt()
             ? implementation->regInt_negWord_extInt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstSub &inst) {
  return inst.isIndFlt_indFlt_regFlt()
             ? implementation->indFlt_indFlt_regFlt(inst)
         : inst.isIndFlt_indFlt_regInt()
             ? implementation->indFlt_indFlt_regInt(inst)
         : inst.isIndFlt_indFlt_posByte()
             ? implementation->indFlt_indFlt_posByte(inst)
         : inst.isIndFlt_indFlt_negByte()
             ? implementation->indFlt_indFlt_negByte(inst)
         : inst.isIndFlt_indFlt_posWord()
             ? implementation->indFlt_indFlt_posWord(inst)
         : inst.isIndFlt_indFlt_negWord()
             ? implementation->indFlt_indFlt_negWord(inst)
         : inst.isIndInt_indInt_regInt()
             ? implementation->indInt_indInt_regInt(inst)
         : inst.isIndInt_indInt_posByte()
             ? implementation->indInt_indInt_posByte(inst)
         : inst.isIndInt_indInt_negByte()
             ? implementation->indInt_indInt_negByte(inst)
         : inst.isIndInt_indInt_posWord()
             ? implementation->indInt_indInt_posWord(inst)
         : inst.isIndInt_indInt_negWord()
             ? implementation->indInt_indInt_negWord(inst)
         : inst.isExtFlt_extFlt_regFlt()
             ? implementation->extFlt_extFlt_regFlt(inst)
         : inst.isExtFlt_extFlt_regInt()
             ? implementation->extFlt_extFlt_regInt(inst)
         : inst.isExtFlt_extFlt_posByte()
             ? implementation->extFlt_extFlt_posByte(inst)
         : inst.isExtFlt_extFlt_negByte()
             ? implementation->extFlt_extFlt_negByte(inst)
         : inst.isExtFlt_extFlt_posWord()
             ? implementation->extFlt_extFlt_posWord(inst)
         : inst.isExtFlt_extFlt_negWord()
             ? implementation->extFlt_extFlt_negWord(inst)
         : inst.isExtInt_extInt_regInt()
             ? implementation->extInt_extInt_regInt(inst)
         : inst.isExtInt_extInt_posByte()
             ? implementation->extInt_extInt_posByte(inst)
         : inst.isExtInt_extInt_negByte()
             ? implementation->extInt_extInt_negByte(inst)
         : inst.isExtInt_extInt_posWord()
             ? implementation->extInt_extInt_posWord(inst)
         : inst.isExtInt_extInt_negWord()
             ? implementation->extInt_extInt_negWord(inst)
         : inst.isRegFlt_regFlt_regFlt()
             ? implementation->regFlt_regFlt_regFlt(inst)
         : inst.isRegFlt_regFlt_regInt()
             ? implementation->regFlt_regFlt_regInt(inst)
         : inst.isRegFlt_regInt_regFlt()
             ? implementation->regFlt_regInt_regFlt(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegFlt_regFlt_extFlt()
             ? implementation->regFlt_regFlt_extFlt(inst)
         : inst.isRegFlt_regFlt_extInt()
             ? implementation->regFlt_regFlt_extInt(inst)
         : inst.isRegFlt_regInt_extFlt()
             ? implementation->regFlt_regInt_extFlt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegFlt_regFlt_posByte()
             ? implementation->regFlt_regFlt_posByte(inst)
         : inst.isRegFlt_regFlt_negByte()
             ? implementation->regFlt_regFlt_negByte(inst)
         : inst.isRegFlt_regFlt_posWord()
             ? implementation->regFlt_regFlt_posWord(inst)
         : inst.isRegFlt_regFlt_negWord()
             ? implementation->regFlt_regFlt_negWord(inst)
         : inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegFlt_extFlt_posByte()
             ? implementation->regFlt_extFlt_posByte(inst)
         : inst.isRegFlt_extFlt_negByte()
             ? implementation->regFlt_extFlt_negByte(inst)
         : inst.isRegFlt_extFlt_posWord()
             ? implementation->regFlt_extFlt_posWord(inst)
         : inst.isRegFlt_extFlt_negWord()
             ? implementation->regFlt_extFlt_negWord(inst)
         : inst.isRegInt_extInt_posByte()
             ? implementation->regInt_extInt_posByte(inst)
         : inst.isRegInt_extInt_negByte()
             ? implementation->regInt_extInt_negByte(inst)
         : inst.isRegInt_extInt_posWord()
             ? implementation->regInt_extInt_posWord(inst)
         : inst.isRegInt_extInt_negWord()
             ? implementation->regInt_extInt_negWord(inst)
         : inst.isRegFlt_posByte_extFlt()
             ? implementation->regFlt_posByte_extFlt(inst)
         : inst.isRegFlt_negByte_extFlt()
             ? implementation->regFlt_negByte_extFlt(inst)
         : inst.isRegFlt_posWord_extFlt()
             ? implementation->regFlt_posWord_extFlt(inst)
         : inst.isRegFlt_negWord_extFlt()
             ? implementation->regFlt_negWord_extFlt(inst)
         : inst.isRegInt_posByte_extInt()
             ? implementation->regInt_posByte_extInt(inst)
         : inst.isRegInt_negByte_extInt()
             ? implementation->regInt_negByte_extInt(inst)
         : inst.isRegInt_posWord_extInt()
             ? implementation->regInt_posWord_extInt(inst)
         : inst.isRegInt_negWord_extInt()
             ? implementation->regInt_negWord_extInt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstMul &inst) {
  return inst.isRegFlt_regFlt_regFlt()
             ? implementation->regFlt_regFlt_regFlt(inst)
         : inst.isRegFlt_regFlt_extFlt()
             ? implementation->regFlt_regFlt_extFlt(inst)
         : inst.isRegFlt_regFlt_regInt()
             ? implementation->regFlt_regFlt_regInt(inst)
         : inst.isRegFlt_regFlt_extInt()
             ? implementation->regFlt_regFlt_extInt(inst)
         : inst.isRegFlt_regFlt_posByte()
             ? implementation->regFlt_regFlt_posByte(inst)
         : inst.isRegFlt_regFlt_negByte()
             ? implementation->regFlt_regFlt_negByte(inst)
         : inst.isRegFlt_regFlt_posWord()
             ? implementation->regFlt_regFlt_posWord(inst)
         : inst.isRegFlt_regFlt_negWord()
             ? implementation->regFlt_regFlt_negWord(inst)
         : inst.isRegFlt_regInt_regFlt()
             ? implementation->regFlt_regInt_regFlt(inst)
         : inst.isRegFlt_regInt_extFlt()
             ? implementation->regFlt_regInt_extFlt(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstDiv &inst) {
  return inst.isRegFlt_regFlt_regFlt()
             ? implementation->regFlt_regFlt_regFlt(inst)
         : inst.isRegFlt_regFlt_extFlt()
             ? implementation->regFlt_regFlt_extFlt(inst)
         : inst.isRegFlt_regFlt_regInt()
             ? implementation->regFlt_regFlt_regInt(inst)
         : inst.isRegFlt_regFlt_extInt()
             ? implementation->regFlt_regFlt_extInt(inst)
         : inst.isRegFlt_regFlt_posByte()
             ? implementation->regFlt_regFlt_posByte(inst)
         : inst.isRegFlt_regFlt_negByte()
             ? implementation->regFlt_regFlt_negByte(inst)
         : inst.isRegFlt_regFlt_posWord()
             ? implementation->regFlt_regFlt_posWord(inst)
         : inst.isRegFlt_regFlt_negWord()
             ? implementation->regFlt_regFlt_negWord(inst)
         : inst.isRegFlt_regInt_regFlt()
             ? implementation->regFlt_regInt_regFlt(inst)
         : inst.isRegFlt_regInt_extFlt()
             ? implementation->regFlt_regInt_extFlt(inst)
         : inst.isRegFlt_regInt_regInt()
             ? implementation->regFlt_regInt_regInt(inst)
         : inst.isRegFlt_regInt_extInt()
             ? implementation->regFlt_regInt_extInt(inst)
         : inst.isRegFlt_regInt_posByte()
             ? implementation->regFlt_regInt_posByte(inst)
         : inst.isRegFlt_regInt_negByte()
             ? implementation->regFlt_regInt_negByte(inst)
         : inst.isRegFlt_regInt_posWord()
             ? implementation->regFlt_regInt_posWord(inst)
         : inst.isRegFlt_regInt_negWord()
             ? implementation->regFlt_regInt_negWord(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPow &inst) {
  return inst.isRegFlt_regFlt_regFlt()
             ? implementation->regFlt_regFlt_regFlt(inst)
         : inst.isRegFlt_regFlt_extFlt()
             ? implementation->regFlt_regFlt_extFlt(inst)
         : inst.isRegFlt_regFlt_regInt()
             ? implementation->regFlt_regFlt_regInt(inst)
         : inst.isRegFlt_regFlt_extInt()
             ? implementation->regFlt_regFlt_extInt(inst)
         : inst.isRegFlt_regFlt_posByte()
             ? implementation->regFlt_regFlt_posByte(inst)
         : inst.isRegFlt_regFlt_negByte()
             ? implementation->regFlt_regFlt_negByte(inst)
         : inst.isRegFlt_regFlt_posWord()
             ? implementation->regFlt_regFlt_posWord(inst)
         : inst.isRegFlt_regFlt_negWord()
             ? implementation->regFlt_regFlt_negWord(inst)
         : inst.isRegFlt_regInt_regFlt()
             ? implementation->regFlt_regInt_regFlt(inst)
         : inst.isRegFlt_regInt_extFlt()
             ? implementation->regFlt_regInt_extFlt(inst)
         : inst.isRegFlt_regInt_regInt()
             ? implementation->regFlt_regInt_regInt(inst)
         : inst.isRegFlt_regInt_extInt()
             ? implementation->regFlt_regInt_extInt(inst)
         : inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegFlt_regInt_negByte()
             ? implementation->regFlt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegFlt_regInt_negWord()
             ? implementation->regFlt_regInt_negWord(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLdEq &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegInt_regInt_regFlt()
             ? implementation->regInt_regInt_regFlt(inst)
         : inst.isRegInt_regInt_extFlt()
             ? implementation->regInt_regInt_extFlt(inst)
         : inst.isRegInt_regFlt_posByte()
             ? implementation->regInt_regFlt_posByte(inst)
         : inst.isRegInt_regFlt_negByte()
             ? implementation->regInt_regFlt_negByte(inst)
         : inst.isRegInt_regFlt_posWord()
             ? implementation->regInt_regFlt_posWord(inst)
         : inst.isRegInt_regFlt_negWord()
             ? implementation->regInt_regFlt_negWord(inst)
         : inst.isRegInt_regFlt_regInt()
             ? implementation->regInt_regFlt_regInt(inst)
         : inst.isRegInt_regFlt_extInt()
             ? implementation->regInt_regFlt_extInt(inst)
         : inst.isRegInt_regFlt_regFlt()
             ? implementation->regInt_regFlt_regFlt(inst)
         : inst.isRegInt_regFlt_extFlt()
             ? implementation->regInt_regFlt_extFlt(inst)
         : inst.isRegInt_regStr_regStr()
             ? implementation->regInt_regStr_regStr(inst)
         : inst.isRegInt_regStr_extStr()
             ? implementation->regInt_regStr_extStr(inst)
         : inst.isRegInt_regStr_immStr()
             ? implementation->regInt_regStr_immStr(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLdNe &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegInt_regInt_regFlt()
             ? implementation->regInt_regInt_regFlt(inst)
         : inst.isRegInt_regInt_extFlt()
             ? implementation->regInt_regInt_extFlt(inst)
         : inst.isRegInt_regFlt_posByte()
             ? implementation->regInt_regFlt_posByte(inst)
         : inst.isRegInt_regFlt_negByte()
             ? implementation->regInt_regFlt_negByte(inst)
         : inst.isRegInt_regFlt_posWord()
             ? implementation->regInt_regFlt_posWord(inst)
         : inst.isRegInt_regFlt_negWord()
             ? implementation->regInt_regFlt_negWord(inst)
         : inst.isRegInt_regFlt_regInt()
             ? implementation->regInt_regFlt_regInt(inst)
         : inst.isRegInt_regFlt_extInt()
             ? implementation->regInt_regFlt_extInt(inst)
         : inst.isRegInt_regFlt_regFlt()
             ? implementation->regInt_regFlt_regFlt(inst)
         : inst.isRegInt_regFlt_extFlt()
             ? implementation->regInt_regFlt_extFlt(inst)
         : inst.isRegInt_regStr_regStr()
             ? implementation->regInt_regStr_regStr(inst)
         : inst.isRegInt_regStr_extStr()
             ? implementation->regInt_regStr_extStr(inst)
         : inst.isRegInt_regStr_immStr()
             ? implementation->regInt_regStr_immStr(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLdLo &inst) {
  return inst.isRegInt_regStr_regStr()
             ? implementation->regInt_regStr_regStr(inst)
         : inst.isRegInt_regStr_extStr()
             ? implementation->regInt_regStr_extStr(inst)
         : inst.isRegInt_regStr_immStr()
             ? implementation->regInt_regStr_immStr(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLdHs &inst) {
  return inst.isRegInt_regStr_regStr()
             ? implementation->regInt_regStr_regStr(inst)
         : inst.isRegInt_regStr_extStr()
             ? implementation->regInt_regStr_extStr(inst)
         : inst.isRegInt_regStr_immStr()
             ? implementation->regInt_regStr_immStr(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLdLt &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegInt_regInt_regFlt()
             ? implementation->regInt_regInt_regFlt(inst)
         : inst.isRegInt_regInt_extFlt()
             ? implementation->regInt_regInt_extFlt(inst)
         : inst.isRegInt_regFlt_posByte()
             ? implementation->regInt_regFlt_posByte(inst)
         : inst.isRegInt_regFlt_negByte()
             ? implementation->regInt_regFlt_negByte(inst)
         : inst.isRegInt_regFlt_posWord()
             ? implementation->regInt_regFlt_posWord(inst)
         : inst.isRegInt_regFlt_negWord()
             ? implementation->regInt_regFlt_negWord(inst)
         : inst.isRegInt_regFlt_regInt()
             ? implementation->regInt_regFlt_regInt(inst)
         : inst.isRegInt_regFlt_extInt()
             ? implementation->regInt_regFlt_extInt(inst)
         : inst.isRegInt_regFlt_regFlt()
             ? implementation->regInt_regFlt_regFlt(inst)
         : inst.isRegInt_regFlt_extFlt()
             ? implementation->regInt_regFlt_extFlt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLdGe &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
         : inst.isRegInt_regInt_regFlt()
             ? implementation->regInt_regInt_regFlt(inst)
         : inst.isRegInt_regInt_extFlt()
             ? implementation->regInt_regInt_extFlt(inst)
         : inst.isRegInt_regFlt_posByte()
             ? implementation->regInt_regFlt_posByte(inst)
         : inst.isRegInt_regFlt_negByte()
             ? implementation->regInt_regFlt_negByte(inst)
         : inst.isRegInt_regFlt_posWord()
             ? implementation->regInt_regFlt_posWord(inst)
         : inst.isRegInt_regFlt_negWord()
             ? implementation->regInt_regFlt_negWord(inst)
         : inst.isRegInt_regFlt_regInt()
             ? implementation->regInt_regFlt_regInt(inst)
         : inst.isRegInt_regFlt_extInt()
             ? implementation->regInt_regFlt_extInt(inst)
         : inst.isRegInt_regFlt_regFlt()
             ? implementation->regInt_regFlt_regFlt(inst)
         : inst.isRegInt_regFlt_extFlt()
             ? implementation->regInt_regFlt_extFlt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstAnd &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstOr &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_negByte()
             ? implementation->regInt_regInt_negByte(inst)
         : inst.isRegInt_regInt_posWord()
             ? implementation->regInt_regInt_posWord(inst)
         : inst.isRegInt_regInt_negWord()
             ? implementation->regInt_regInt_negWord(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstStrInit &inst) {
  return inst.isRegStr_regStr()   ? implementation->regStr_regStr(inst)
         : inst.isRegStr_extStr() ? implementation->regStr_extStr(inst)
         : inst.isRegStr_immStr() ? implementation->regStr_immStr(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstStrCat &inst) {
  return inst.isRegStr_regStr_regStr()
             ? implementation->regStr_regStr_regStr(inst)
         : inst.isRegStr_regStr_extStr()
             ? implementation->regStr_regStr_extStr(inst)
         : inst.isRegStr_regStr_immStr()
             ? implementation->regStr_regStr_immStr(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstLeft &inst) {
  return inst.isRegStr_regStr_regInt()
             ? implementation->regStr_regStr_regInt(inst)
         : inst.isRegStr_regStr_extInt()
             ? implementation->regStr_regStr_extInt(inst)
         : inst.isRegStr_regStr_posByte()
             ? implementation->regStr_regStr_posByte(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstRight &inst) {
  return inst.isRegStr_regStr_regInt()
             ? implementation->regStr_regStr_regInt(inst)
         : inst.isRegStr_regStr_extInt()
             ? implementation->regStr_regStr_extInt(inst)
         : inst.isRegStr_regStr_posByte()
             ? implementation->regStr_regStr_posByte(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstMid &inst) {
  return inst.isRegStr_regStr_regInt()
             ? implementation->regStr_regStr_regInt(inst)
         : inst.isRegStr_regStr_extInt()
             ? implementation->regStr_regStr_extInt(inst)
         : inst.isRegStr_regStr_posByte()
             ? implementation->regStr_regStr_posByte(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstMidT &inst) {
  return inst.isRegStr_regStr_regInt()
             ? implementation->regStr_regStr_regInt(inst)
         : inst.isRegStr_regStr_extInt()
             ? implementation->regStr_regStr_extInt(inst)
         : inst.isRegStr_regStr_posByte()
             ? implementation->regStr_regStr_posByte(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPrComma &inst) {
  return implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstPrSpace &inst) {
  return implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstPrCR &inst) {
  return implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPrAt &inst) {
  return inst.arg1->isPosByte()   ? implementation->posByte(inst)
         : inst.arg1->isPosWord() ? implementation->posWord(inst)
         : inst.arg1->isRegInt()  ? implementation->regInt(inst)
         : inst.arg1->isExtInt()  ? implementation->extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPr &inst) {
  return inst.arg1->isImmStr()   ? implementation->immStr(inst)
         : inst.arg1->isRegStr() ? implementation->regStr(inst)
         : inst.arg1->isExtStr() ? implementation->extStr(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPrTab &inst) {
  return inst.arg1->isPosByte()  ? implementation->posByte(inst)
         : inst.arg1->isRegInt() ? implementation->regInt(inst)
         : inst.arg1->isExtInt() ? implementation->extInt(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstFor &inst) {
  return inst.isExtInt_posByte()   ? implementation->extInt_posByte(inst)
         : inst.isExtInt_negByte() ? implementation->extInt_negByte(inst)
         : inst.isExtInt_posWord() ? implementation->extInt_posWord(inst)
         : inst.isExtInt_negWord() ? implementation->extInt_negWord(inst)
         : inst.isExtInt_regInt()  ? implementation->extInt_regInt(inst)
         : inst.isExtFlt_posByte() ? implementation->extFlt_posByte(inst)
         : inst.isExtFlt_negByte() ? implementation->extFlt_negByte(inst)
         : inst.isExtFlt_posWord() ? implementation->extFlt_posWord(inst)
         : inst.isExtFlt_negWord() ? implementation->extFlt_negWord(inst)
         : inst.isExtFlt_regInt()  ? implementation->extFlt_regInt(inst)
         : inst.isExtFlt_regFlt()  ? implementation->extFlt_regFlt(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstTo &inst) {
  return inst.isPtrInt_posByte()   ? implementation->ptrInt_posByte(inst)
         : inst.isPtrInt_negByte() ? implementation->ptrInt_negByte(inst)
         : inst.isPtrInt_posWord() ? implementation->ptrInt_posWord(inst)
         : inst.isPtrInt_negWord() ? implementation->ptrInt_negWord(inst)
         : inst.isPtrInt_regInt()  ? implementation->ptrInt_regInt(inst)
         : inst.isPtrInt_extInt()  ? implementation->ptrInt_extInt(inst)
         : inst.isPtrFlt_posByte() ? implementation->ptrFlt_posByte(inst)
         : inst.isPtrFlt_negByte() ? implementation->ptrFlt_negByte(inst)
         : inst.isPtrFlt_posWord() ? implementation->ptrFlt_posWord(inst)
         : inst.isPtrFlt_negWord() ? implementation->ptrFlt_negWord(inst)
         : inst.isPtrFlt_regInt()  ? implementation->ptrFlt_regInt(inst)
         : inst.isPtrFlt_extInt()  ? implementation->ptrFlt_extInt(inst)
         : inst.isPtrFlt_regFlt()  ? implementation->ptrFlt_regFlt(inst)
         : inst.isPtrFlt_extFlt()  ? implementation->ptrFlt_extFlt(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstStep &inst) {
  return inst.isPtrInt_regInt()   ? implementation->ptrInt_regInt(inst)
         : inst.isPtrFlt_regInt() ? implementation->ptrFlt_regInt(inst)
         : inst.isPtrFlt_regFlt() ? implementation->ptrFlt_regFlt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstNext &inst) {
  return implementation->inherent(inst);
}
std::string Dispatcher::operate(InstNextVar &inst) {
  return inst.arg1->isExtInt()   ? implementation->extInt(inst)
         : inst.arg1->isExtFlt() ? implementation->extFlt(inst)
                                 : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstGoTo &inst) {
  return inst.arg1->isImmLbl() ? implementation->immLbl(inst)
                               : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstGoSub &inst) {
  return inst.arg1->isImmLbl() ? implementation->immLbl(inst)
                               : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstOnGoTo &inst) {
  return inst.isRegInt_immLbls() ? implementation->regInt_immLbls(inst)
                                 : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstOnGoSub &inst) {
  return inst.isRegInt_immLbls() ? implementation->regInt_immLbls(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstJsrIfEqual &inst) {
  return inst.isRegInt_immLbl()   ? implementation->regInt_immLbl(inst)
         : inst.isRegFlt_immLbl() ? implementation->regFlt_immLbl(inst)
                                  : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstJsrIfNotEqual &inst) {
  return inst.isRegInt_immLbl()   ? implementation->regInt_immLbl(inst)
         : inst.isRegFlt_immLbl() ? implementation->regFlt_immLbl(inst)
                                  : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstJmpIfEqual &inst) {
  return inst.isRegInt_immLbl()   ? implementation->regInt_immLbl(inst)
         : inst.isRegFlt_immLbl() ? implementation->regFlt_immLbl(inst)
                                  : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstJmpIfNotEqual &inst) {
  return inst.isRegInt_immLbl()   ? implementation->regInt_immLbl(inst)
         : inst.isRegFlt_immLbl() ? implementation->regFlt_immLbl(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstInputBuf &inst) {
  return implementation->inherent(inst);
}

std::string Dispatcher::operate(InstReadBuf &inst) {
  return inst.arg1->isExtFlt()   ? implementation->extFlt(inst)
         : inst.arg1->isIndFlt() ? implementation->indFlt(inst)
         : inst.arg1->isExtStr() ? implementation->extStr(inst)
         : inst.arg1->isIndStr() ? implementation->indStr(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstRead &inst) {
  return inst.arg1->isIndInt()   ? implementation->indInt(inst)
         : inst.arg1->isIndFlt() ? implementation->indFlt(inst)
         : inst.arg1->isIndStr() ? implementation->indStr(inst)
         : inst.arg1->isExtInt() ? implementation->extInt(inst)
         : inst.arg1->isExtFlt() ? implementation->extFlt(inst)
         : inst.arg1->isExtStr() ? implementation->extStr(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstIgnoreExtra &inst) {
  return implementation->inherent(inst);
}

std::string Dispatcher::operate(InstRestore &inst) {
  return implementation->inherent(inst);
}
std::string Dispatcher::operate(InstReturn &inst) {
  return implementation->inherent(inst);
}
std::string Dispatcher::operate(InstClear &inst) {
  return implementation->inherent(inst);
}
std::string Dispatcher::operate(InstCls &inst) {
  return implementation->inherent(inst);
}

std::string Dispatcher::operate(InstClsN &inst) {
  return inst.arg1->isPosByte()  ? implementation->posByte(inst)
         : inst.arg1->isRegInt() ? implementation->regInt(inst)
         : inst.arg1->isExtInt() ? implementation->extInt(inst)
                                 : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstSet &inst) {
  return inst.isRegInt_posByte()  ? implementation->regInt_posByte(inst)
         : inst.isRegInt_regInt() ? implementation->regInt_regInt(inst)
         : inst.isRegInt_extInt() ? implementation->regInt_extInt(inst)
                                  : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstReset &inst) {
  return inst.isRegInt_posByte()  ? implementation->regInt_posByte(inst)
         : inst.isRegInt_regInt() ? implementation->regInt_regInt(inst)
         : inst.isRegInt_extInt() ? implementation->regInt_extInt(inst)
                                  : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstPoint &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
             : implementation->unimplemented(inst);
}
std::string Dispatcher::operate(InstSetC &inst) {
  return inst.isRegInt_regInt_posByte()
             ? implementation->regInt_regInt_posByte(inst)
         : inst.isRegInt_regInt_regInt()
             ? implementation->regInt_regInt_regInt(inst)
         : inst.isRegInt_regInt_extInt()
             ? implementation->regInt_regInt_extInt(inst)
             : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstStop &inst) {
  return implementation->inherent(inst);
}

std::string Dispatcher::operate(InstPoke &inst) {
  return inst.isPosByte_regInt()   ? implementation->posByte_regInt(inst)
         : inst.isPosByte_extInt() ? implementation->posByte_extInt(inst)
         : inst.isPosWord_regInt() ? implementation->posWord_regInt(inst)
         : inst.isPosWord_extInt() ? implementation->posWord_extInt(inst)
         : inst.isRegInt_posByte() ? implementation->regInt_posByte(inst)
         : inst.isRegInt_regInt()  ? implementation->regInt_regInt(inst)
         : inst.isRegInt_extInt()  ? implementation->regInt_extInt(inst)
         : inst.isExtInt_posByte() ? implementation->extInt_posByte(inst)
         : inst.isExtInt_regInt()  ? implementation->extInt_regInt(inst)
                                   : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstSound &inst) {
  return inst.isRegInt_regInt() ? implementation->regInt_regInt(inst)
                                : implementation->unimplemented(inst);
}

std::string Dispatcher::operate(InstBegin &inst) {
  return implementation->inherent(inst);
}
std::string Dispatcher::operate(InstEnd &inst) {
  return implementation->inherent(inst);
}
