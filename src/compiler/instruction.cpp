// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "instruction.hpp"

// ELPTR = ARRAYREF STARTREG, ARRDESC, COUNT
void InstArrayRef1::arrayArg() {
  result = makeup<AddressModeInd>(arg2->dataType, "letptr");
}

// STARTREG = ARRAYVAL STARTREG, ARRDESC, COUNT
void InstArrayVal1::arrayArg() {
  result = arg1->clone();
  result->dataType = arg2->dataType;
}

// ELPTR = ARRAYREF STARTREG, ARRDESC, COUNT
void InstArrayRef2::arrayArg() {
  result = makeup<AddressModeInd>(arg2->dataType, "letptr");
}

// STARTREG = ARRAYVAL STARTREG, ARRDESC, COUNT
void InstArrayVal2::arrayArg() {
  result = arg1->clone();
  result->dataType = arg2->dataType;
}

// ELPTR = ARRAYREF STARTREG, ARRDESC, COUNT
void InstArrayRef3::arrayArg() {
  result = makeup<AddressModeInd>(arg2->dataType, "letptr");
}

// STARTREG = ARRAYVAL STARTREG, ARRDESC, COUNT
void InstArrayVal3::arrayArg() {
  result = arg1->clone();
  result->dataType = arg2->dataType;
}

// ELPTR = ARRAYREF STARTREG, ARRDESC, COUNT
void InstArrayRef4::arrayArg() {
  result = makeup<AddressModeInd>(arg2->dataType, "letptr");
}

// STARTREG = ARRAYVAL STARTREG, ARRDESC, COUNT
void InstArrayVal4::arrayArg() {
  result = arg1->clone();
  result->dataType = arg2->dataType;
}

// ELPTR = ARRAYREF STARTREG, ARRDESC, COUNT
void InstArrayRef5::arrayArg() {
  result = makeup<AddressModeInd>(arg2->dataType, "letptr");
}

// STARTREG = ARRAYVAL STARTREG, ARRDESC, COUNT
void InstArrayVal5::arrayArg() {
  result = arg1->clone();
  result->dataType = arg2->dataType;
}

// ELPTR = ARRAYREF STARTREG, ARRDESC, COUNT
void InstArrayRef::arrayArg() {
  result = makeup<AddressModeInd>(arg2->dataType, "letptr");
}

// STARTREG = ARRAYVAL STARTREG, ARRDESC, COUNT
void InstArrayVal::arrayArg() {
  result = arg1->clone();
  result->dataType = arg2->dataType;
}

void Instruction::resultLet() { result = arg1->clone(); }

void Instruction::resultArg() {
  arg1->dataType = arg2->dataType;
  result = arg1->clone();
}

void Instruction::resultArg1() { result = arg1->clone(); }

void Instruction::resultInt() {
  arg1->dataType = DataType::Int;
  result = arg1->clone();
}

void Instruction::resultFlt() {
  arg1->dataType = DataType::Flt;
  result = arg1->clone();
}

void Instruction::resultPow() {
  arg1->dataType = arg2->dataType == DataType::Int &&
                           (arg3->isPosByte() || arg3->isPosWord())
                       ? DataType::Int
                       : DataType::Flt;
  result = arg1->clone();
}

void Instruction::resultShift() {
  if (arg3->isPosByte() || arg3->isPosWord()) {
    resultArg();
  } else {
    resultFlt();
  }
}

void Instruction::resultStr() {
  arg1->dataType = DataType::Str;
  result = arg1->clone();
}

void Instruction::resultPtr() {
  result = makeup<AddressModePtr>(arg1->dataType, arg1->suffix());
}

void Instruction::resultPromoteFlt() {
  arg1->dataType = arg2->isFloat()   ? DataType::Flt
                   : arg3->isFloat() ? DataType::Flt
                                     : DataType::Int;
  result = arg1->clone();
}

void Instruction::labelArg() {
  if (arg1->exists()) {
    label = arg1->label();
  }
}

std::string Instruction::callLabel() const {
  std::string lbl = mnemonic;

  if (!lbl.empty()) {
    if (arg1->exists()) {
      lbl += "_" + arg1->suffix();
    }
    if (arg2->exists()) {
      lbl += "_" + arg2->suffix();
    }
    if (arg3->exists()) {
      lbl += "_" + arg3->suffix();
    }
  }

  return lbl;
}

bool Instruction::isIndFlt() const { return arg1->isIndFlt(); }
bool Instruction::isIndInt() const { return arg1->isIndInt(); }
bool Instruction::isExtFlt() const { return arg1->isExtFlt(); }
bool Instruction::isExtInt() const { return arg1->isExtInt(); }

bool Instruction::isExtFlt_extFlt() const {
  return arg1->isExtFlt() && arg2->isExtFlt();
}
bool Instruction::isExtFlt_negByte() const {
  return arg1->isExtFlt() && arg2->isNegByte();
}
bool Instruction::isExtFlt_negWord() const {
  return arg1->isExtFlt() && arg2->isNegWord();
}
bool Instruction::isExtFlt_posByte() const {
  return arg1->isExtFlt() && arg2->isPosByte();
}
bool Instruction::isExtFlt_posWord() const {
  return arg1->isExtFlt() && arg2->isPosWord();
}
bool Instruction::isExtFlt_regFlt() const {
  return arg1->isExtFlt() && arg2->isRegFlt();
}
bool Instruction::isExtFlt_regInt() const {
  return arg1->isExtFlt() && arg2->isRegInt();
}
bool Instruction::isExtInt_extInt() const {
  return arg1->isExtInt() && arg2->isExtInt();
}
bool Instruction::isExtInt_negByte() const {
  return arg1->isExtInt() && arg2->isNegByte();
}
bool Instruction::isExtInt_negWord() const {
  return arg1->isExtInt() && arg2->isNegWord();
}
bool Instruction::isExtInt_posByte() const {
  return arg1->isExtInt() && arg2->isPosByte();
}
bool Instruction::isExtInt_posWord() const {
  return arg1->isExtInt() && arg2->isPosWord();
}
bool Instruction::isExtInt_regInt() const {
  return arg1->isExtInt() && arg2->isRegInt();
}
bool Instruction::isExtStr_immStr() const {
  return arg1->isExtStr() && arg2->isImmStr();
}
bool Instruction::isExtStr_regStr() const {
  return arg1->isExtStr() && arg2->isRegStr();
}
bool Instruction::isDexFlt_extFlt() const {
  return arg1->isDexFlt() && arg2->isExtFlt();
}
bool Instruction::isDexFlt_extInt() const {
  return arg1->isDexFlt() && arg2->isExtInt();
}
bool Instruction::isDexInt_extInt() const {
  return arg1->isDexInt() && arg2->isExtInt();
}
bool Instruction::isDexStr_extStr() const {
  return arg1->isDexStr() && arg2->isExtStr();
}
bool Instruction::isIndFlt_indFlt() const {
  return arg1->isIndFlt() && arg2->isIndFlt();
}
bool Instruction::isIndFlt_negByte() const {
  return arg1->isIndFlt() && arg2->isNegByte();
}
bool Instruction::isIndFlt_negWord() const {
  return arg1->isIndFlt() && arg2->isNegWord();
}
bool Instruction::isIndFlt_posByte() const {
  return arg1->isIndFlt() && arg2->isPosByte();
}
bool Instruction::isIndFlt_posWord() const {
  return arg1->isIndFlt() && arg2->isPosWord();
}
bool Instruction::isIndFlt_regFlt() const {
  return arg1->isIndFlt() && arg2->isRegFlt();
}
bool Instruction::isIndFlt_regInt() const {
  return arg1->isIndFlt() && arg2->isRegInt();
}
bool Instruction::isIndInt_indInt() const {
  return arg1->isIndInt() && arg2->isIndInt();
}
bool Instruction::isIndInt_negByte() const {
  return arg1->isIndInt() && arg2->isNegByte();
}
bool Instruction::isIndInt_negWord() const {
  return arg1->isIndInt() && arg2->isNegWord();
}
bool Instruction::isIndInt_posByte() const {
  return arg1->isIndInt() && arg2->isPosByte();
}
bool Instruction::isIndInt_posWord() const {
  return arg1->isIndInt() && arg2->isPosWord();
}
bool Instruction::isIndInt_regInt() const {
  return arg1->isIndInt() && arg2->isRegInt();
}
bool Instruction::isIndStr_immStr() const {
  return arg1->isIndStr() && arg2->isImmStr();
}
bool Instruction::isIndStr_regStr() const {
  return arg1->isIndStr() && arg2->isRegStr();
}
bool Instruction::isPosByte_extInt() const {
  return arg1->isPosByte() && arg2->isExtInt();
}
bool Instruction::isPosByte_regInt() const {
  return arg1->isPosByte() && arg2->isRegInt();
}
bool Instruction::isPosWord_extInt() const {
  return arg1->isPosWord() && arg2->isExtInt();
}
bool Instruction::isPosWord_regInt() const {
  return arg1->isPosWord() && arg2->isRegInt();
}
bool Instruction::isPtrFlt_extFlt() const {
  return arg1->isPtrFlt() && arg2->isExtFlt();
}
bool Instruction::isPtrFlt_extInt() const {
  return arg1->isPtrFlt() && arg2->isExtInt();
}
bool Instruction::isPtrFlt_negByte() const {
  return arg1->isPtrFlt() && arg2->isNegByte();
}
bool Instruction::isPtrFlt_negWord() const {
  return arg1->isPtrFlt() && arg2->isNegWord();
}
bool Instruction::isPtrFlt_posByte() const {
  return arg1->isPtrFlt() && arg2->isPosByte();
}
bool Instruction::isPtrFlt_posWord() const {
  return arg1->isPtrFlt() && arg2->isPosWord();
}
bool Instruction::isPtrFlt_regFlt() const {
  return arg1->isPtrFlt() && arg2->isRegFlt();
}
bool Instruction::isPtrFlt_regInt() const {
  return arg1->isPtrFlt() && arg2->isRegInt();
}
bool Instruction::isPtrInt_extInt() const {
  return arg1->isPtrInt() && arg2->isExtInt();
}
bool Instruction::isPtrInt_negByte() const {
  return arg1->isPtrInt() && arg2->isNegByte();
}
bool Instruction::isPtrInt_negWord() const {
  return arg1->isPtrInt() && arg2->isNegWord();
}
bool Instruction::isPtrInt_posByte() const {
  return arg1->isPtrInt() && arg2->isPosByte();
}
bool Instruction::isPtrInt_posWord() const {
  return arg1->isPtrInt() && arg2->isPosWord();
}
bool Instruction::isPtrInt_regInt() const {
  return arg1->isPtrInt() && arg2->isRegInt();
}
bool Instruction::isPtrInt_regFlt() const {
  return arg1->isPtrInt() && arg2->isRegFlt();
}
bool Instruction::isPtrInt_extFlt() const {
  return arg1->isPtrInt() && arg2->isExtFlt();
}
bool Instruction::isRegFlt_extFlt() const {
  return arg1->isRegFlt() && arg2->isExtFlt();
}
bool Instruction::isRegFlt_extInt() const {
  return arg1->isRegFlt() && arg2->isExtInt();
}
bool Instruction::isRegFlt_extStr() const {
  return arg1->isRegFlt() && arg2->isExtStr();
}
bool Instruction::isRegFlt_immLbl() const {
  return arg1->isRegFlt() && arg2->isImmLbl();
}
bool Instruction::isRegFlt_negByte() const {
  return arg1->isRegFlt() && arg2->isNegByte();
}
bool Instruction::isRegFlt_negWord() const {
  return arg1->isRegFlt() && arg2->isNegWord();
}
bool Instruction::isRegFlt_posByte() const {
  return arg1->isRegFlt() && arg2->isPosByte();
}
bool Instruction::isRegFlt_posWord() const {
  return arg1->isRegFlt() && arg2->isPosWord();
}
bool Instruction::isRegFlt_regFlt() const {
  return arg1->isRegFlt() && arg2->isRegFlt();
}
bool Instruction::isRegFlt_regInt() const {
  return arg1->isRegFlt() && arg2->isRegInt();
}
bool Instruction::isRegFlt_regStr() const {
  return arg1->isRegFlt() && arg2->isRegStr();
}
bool Instruction::isRegInt_extFlt() const {
  return arg1->isRegInt() && arg2->isExtFlt();
}
bool Instruction::isRegInt_extInt() const {
  return arg1->isRegInt() && arg2->isExtInt();
}
bool Instruction::isRegInt_extStr() const {
  return arg1->isRegInt() && arg2->isExtStr();
}
bool Instruction::isRegInt_immLbl() const {
  return arg1->isRegInt() && arg2->isImmLbl();
}
bool Instruction::isRegInt_immLbls() const {
  return arg1->isRegInt() && arg2->isImmLbls();
}
bool Instruction::isRegInt_negByte() const {
  return arg1->isRegInt() && arg2->isNegByte();
}
bool Instruction::isRegInt_negWord() const {
  return arg1->isRegInt() && arg2->isNegWord();
}
bool Instruction::isRegInt_posByte() const {
  return arg1->isRegInt() && arg2->isPosByte();
}
bool Instruction::isRegInt_posWord() const {
  return arg1->isRegInt() && arg2->isPosWord();
}
bool Instruction::isRegInt_regFlt() const {
  return arg1->isRegInt() && arg2->isRegFlt();
}
bool Instruction::isRegInt_regInt() const {
  return arg1->isRegInt() && arg2->isRegInt();
}
bool Instruction::isRegInt_regStr() const {
  return arg1->isRegInt() && arg2->isRegStr();
}
bool Instruction::isRegStr_extFlt() const {
  return arg1->isRegStr() && arg2->isExtFlt();
}
bool Instruction::isRegStr_extInt() const {
  return arg1->isRegStr() && arg2->isExtInt();
}
bool Instruction::isRegStr_extStr() const {
  return arg1->isRegStr() && arg2->isExtStr();
}
bool Instruction::isRegStr_immStr() const {
  return arg1->isRegStr() && arg2->isImmStr();
}
bool Instruction::isRegStr_regFlt() const {
  return arg1->isRegStr() && arg2->isRegFlt();
}
bool Instruction::isRegStr_regInt() const {
  return arg1->isRegStr() && arg2->isRegInt();
}
bool Instruction::isRegStr_regStr() const {
  return arg1->isRegStr() && arg2->isRegStr();
}

bool Instruction::isExtFlt_extFlt_negByte() const {
  return arg1->isExtFlt() && arg2->isExtFlt() && arg3->isNegByte();
}
bool Instruction::isExtFlt_extFlt_negWord() const {
  return arg1->isExtFlt() && arg2->isExtFlt() && arg3->isNegWord();
}
bool Instruction::isExtFlt_extFlt_posByte() const {
  return arg1->isExtFlt() && arg2->isExtFlt() && arg3->isPosByte();
}
bool Instruction::isExtFlt_extFlt_posWord() const {
  return arg1->isExtFlt() && arg2->isExtFlt() && arg3->isPosWord();
}
bool Instruction::isExtFlt_extFlt_regFlt() const {
  return arg1->isExtFlt() && arg2->isExtFlt() && arg3->isRegFlt();
}
bool Instruction::isExtFlt_extFlt_regInt() const {
  return arg1->isExtFlt() && arg2->isExtFlt() && arg3->isRegInt();
}
bool Instruction::isExtInt_extInt_negByte() const {
  return arg1->isExtInt() && arg2->isExtInt() && arg3->isNegByte();
}
bool Instruction::isExtInt_extInt_negWord() const {
  return arg1->isExtInt() && arg2->isExtInt() && arg3->isNegWord();
}
bool Instruction::isExtInt_extInt_posByte() const {
  return arg1->isExtInt() && arg2->isExtInt() && arg3->isPosByte();
}
bool Instruction::isExtInt_extInt_posWord() const {
  return arg1->isExtInt() && arg2->isExtInt() && arg3->isPosWord();
}
bool Instruction::isExtInt_extInt_regInt() const {
  return arg1->isExtInt() && arg2->isExtInt() && arg3->isRegInt();
}
bool Instruction::isIndFlt_indFlt_negByte() const {
  return arg1->isIndFlt() && arg2->isIndFlt() && arg3->isNegByte();
}
bool Instruction::isIndFlt_indFlt_negWord() const {
  return arg1->isIndFlt() && arg2->isIndFlt() && arg3->isNegWord();
}
bool Instruction::isIndFlt_indFlt_posByte() const {
  return arg1->isIndFlt() && arg2->isIndFlt() && arg3->isPosByte();
}
bool Instruction::isIndFlt_indFlt_posWord() const {
  return arg1->isIndFlt() && arg2->isIndFlt() && arg3->isPosWord();
}
bool Instruction::isIndFlt_indFlt_regFlt() const {
  return arg1->isIndFlt() && arg2->isIndFlt() && arg3->isRegFlt();
}
bool Instruction::isIndFlt_indFlt_regInt() const {
  return arg1->isIndFlt() && arg2->isIndFlt() && arg3->isRegInt();
}
bool Instruction::isIndInt_indInt_negByte() const {
  return arg1->isIndInt() && arg2->isIndInt() && arg3->isNegByte();
}
bool Instruction::isIndInt_indInt_negWord() const {
  return arg1->isIndInt() && arg2->isIndInt() && arg3->isNegWord();
}
bool Instruction::isIndInt_indInt_posByte() const {
  return arg1->isIndInt() && arg2->isIndInt() && arg3->isPosByte();
}
bool Instruction::isIndInt_indInt_posWord() const {
  return arg1->isIndInt() && arg2->isIndInt() && arg3->isPosWord();
}
bool Instruction::isIndInt_indInt_regInt() const {
  return arg1->isIndInt() && arg2->isIndInt() && arg3->isRegInt();
}
bool Instruction::isRegFlt_extFlt_negByte() const {
  return arg1->isRegFlt() && arg2->isExtFlt() && arg3->isNegByte();
}
bool Instruction::isRegFlt_extFlt_negWord() const {
  return arg1->isRegFlt() && arg2->isExtFlt() && arg3->isNegWord();
}
bool Instruction::isRegFlt_extFlt_posByte() const {
  return arg1->isRegFlt() && arg2->isExtFlt() && arg3->isPosByte();
}
bool Instruction::isRegFlt_extFlt_posWord() const {
  return arg1->isRegFlt() && arg2->isExtFlt() && arg3->isPosWord();
}
bool Instruction::isRegFlt_negByte_extFlt() const {
  return arg1->isRegFlt() && arg2->isNegByte() && arg3->isExtFlt();
}
bool Instruction::isRegFlt_negWord_extFlt() const {
  return arg1->isRegFlt() && arg2->isNegWord() && arg3->isExtFlt();
}
bool Instruction::isRegFlt_posByte_extFlt() const {
  return arg1->isRegFlt() && arg2->isPosByte() && arg3->isExtFlt();
}
bool Instruction::isRegFlt_posWord_extFlt() const {
  return arg1->isRegFlt() && arg2->isPosWord() && arg3->isExtFlt();
}
bool Instruction::isRegFlt_regFlt_extFlt() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isExtFlt();
}
bool Instruction::isRegFlt_regFlt_extInt() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isExtInt();
}
bool Instruction::isRegFlt_regFlt_negByte() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isNegByte();
}
bool Instruction::isRegFlt_regFlt_negWord() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isNegWord();
}
bool Instruction::isRegFlt_regFlt_posByte() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isPosByte();
}
bool Instruction::isRegFlt_regFlt_posWord() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isPosWord();
}
bool Instruction::isRegFlt_regFlt_regFlt() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isRegFlt();
}
bool Instruction::isRegFlt_regFlt_regInt() const {
  return arg1->isRegFlt() && arg2->isRegFlt() && arg3->isRegInt();
}
bool Instruction::isRegFlt_regInt_extFlt() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isExtFlt();
}
bool Instruction::isRegFlt_regInt_extInt() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isExtInt();
}
bool Instruction::isRegFlt_regInt_negByte() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isNegByte();
}
bool Instruction::isRegFlt_regInt_negWord() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isNegWord();
}
bool Instruction::isRegFlt_regInt_posByte() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isPosByte();
}
bool Instruction::isRegFlt_regInt_posWord() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isPosWord();
}
bool Instruction::isRegFlt_regInt_regFlt() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isRegFlt();
}
bool Instruction::isRegFlt_regInt_regInt() const {
  return arg1->isRegFlt() && arg2->isRegInt() && arg3->isRegInt();
}
bool Instruction::isRegFlt_extFlt_dexFlt() const {
  return arg1->isRegFlt() && arg2->isExtFlt() && arg3->isDexFlt();
}
bool Instruction::isRegFlt_extFlt_dexInt() const {
  return arg1->isRegFlt() && arg2->isExtFlt() && arg3->isDexInt();
}
bool Instruction::isRegFlt_extInt_dexFlt() const {
  return arg1->isRegFlt() && arg2->isExtInt() && arg3->isDexFlt();
}
bool Instruction::isRegInt_extInt_dexInt() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isDexInt();
}
bool Instruction::isRegInt_extFlt_posByte() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isPosByte();
}
bool Instruction::isRegInt_extFlt_negByte() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isNegByte();
}
bool Instruction::isRegInt_extFlt_posWord() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isPosWord();
}
bool Instruction::isRegInt_extFlt_negWord() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isNegWord();
}
bool Instruction::isRegInt_extFlt_dexFlt() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isDexFlt();
}
bool Instruction::isRegInt_extFlt_dexInt() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isDexInt();
}
bool Instruction::isRegInt_extInt_dexFlt() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isDexFlt();
}
bool Instruction::isRegInt_extStr_immStr() const {
  return arg1->isRegInt() && arg2->isExtStr() && arg3->isImmStr();
}
bool Instruction::isRegInt_extStr_dexStr() const {
  return arg1->isRegInt() && arg2->isExtStr() && arg3->isDexStr();
}
bool Instruction::isRegInt_extStr_regInt() const {
  return arg1->isRegInt() && arg2->isExtStr() && arg3->isRegInt();
}
bool Instruction::isRegInt_extInt_negByte() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isNegByte();
}
bool Instruction::isRegInt_extInt_negWord() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isNegWord();
}
bool Instruction::isRegInt_extInt_posByte() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isPosByte();
}
bool Instruction::isRegInt_extInt_posWord() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isPosWord();
}
bool Instruction::isRegInt_negByte_extInt() const {
  return arg1->isRegInt() && arg2->isNegByte() && arg3->isExtInt();
}
bool Instruction::isRegInt_negWord_extInt() const {
  return arg1->isRegInt() && arg2->isNegWord() && arg3->isExtInt();
}
bool Instruction::isRegInt_posByte_extInt() const {
  return arg1->isRegInt() && arg2->isPosByte() && arg3->isExtInt();
}
bool Instruction::isRegInt_posWord_extInt() const {
  return arg1->isRegInt() && arg2->isPosWord() && arg3->isExtInt();
}
bool Instruction::isRegInt_regFlt_extFlt() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isExtFlt();
}
bool Instruction::isRegInt_regFlt_extInt() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isExtInt();
}
bool Instruction::isRegInt_regFlt_negByte() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isNegByte();
}
bool Instruction::isRegInt_regFlt_negWord() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isNegWord();
}
bool Instruction::isRegInt_regFlt_posByte() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isPosByte();
}
bool Instruction::isRegInt_regFlt_posWord() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isPosWord();
}
bool Instruction::isRegInt_regFlt_regFlt() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isRegFlt();
}
bool Instruction::isRegInt_regFlt_regInt() const {
  return arg1->isRegInt() && arg2->isRegFlt() && arg3->isRegInt();
}
bool Instruction::isRegInt_regInt_extFlt() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isExtFlt();
}
bool Instruction::isRegInt_regInt_extInt() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isExtInt();
}
bool Instruction::isRegInt_regInt_negByte() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isNegByte();
}
bool Instruction::isRegInt_regInt_negWord() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isNegWord();
}
bool Instruction::isRegInt_regInt_posByte() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isPosByte();
}
bool Instruction::isRegInt_regInt_posWord() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isPosWord();
}
bool Instruction::isRegInt_regInt_regFlt() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isRegFlt();
}
bool Instruction::isRegInt_regInt_regInt() const {
  return arg1->isRegInt() && arg2->isRegInt() && arg3->isRegInt();
}
bool Instruction::isRegInt_regStr_extStr() const {
  return arg1->isRegInt() && arg2->isRegStr() && arg3->isExtStr();
}
bool Instruction::isRegInt_regStr_immStr() const {
  return arg1->isRegInt() && arg2->isRegStr() && arg3->isImmStr();
}
bool Instruction::isRegInt_regStr_regStr() const {
  return arg1->isRegInt() && arg2->isRegStr() && arg3->isRegStr();
}
bool Instruction::isRegStr_regStr_extInt() const {
  return arg1->isRegStr() && arg2->isRegStr() && arg3->isExtInt();
}
bool Instruction::isRegStr_regStr_extStr() const {
  return arg1->isRegStr() && arg2->isRegStr() && arg3->isExtStr();
}
bool Instruction::isRegStr_regStr_immStr() const {
  return arg1->isRegStr() && arg2->isRegStr() && arg3->isImmStr();
}
bool Instruction::isRegStr_regStr_posByte() const {
  return arg1->isRegStr() && arg2->isRegStr() && arg3->isPosByte();
}
bool Instruction::isRegStr_regStr_regInt() const {
  return arg1->isRegStr() && arg2->isRegStr() && arg3->isRegInt();
}
bool Instruction::isRegStr_regStr_regStr() const {
  return arg1->isRegStr() && arg2->isRegStr() && arg3->isRegStr();
}

bool Instruction::isRegInt_extFlt_regFlt() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isRegFlt();
}
bool Instruction::isRegInt_extFlt_regInt() const {
  return arg1->isRegInt() && arg2->isExtFlt() && arg3->isRegInt();
}
bool Instruction::isRegInt_extInt_regFlt() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isRegFlt();
}
bool Instruction::isRegInt_extInt_regInt() const {
  return arg1->isRegInt() && arg2->isExtInt() && arg3->isRegInt();
}
bool Instruction::isRegInt_extStr_regStr() const {
  return arg1->isRegInt() && arg2->isExtStr() && arg3->isRegStr();
}
bool Instruction::isRegInt_extStr_dexInt() const {
  return arg1->isRegInt() && arg2->isExtStr() && arg3->isDexInt();
}
bool Instruction::isRegInt_immStr_extStr() const {
  return arg1->isRegInt() && arg2->isImmStr() && arg3->isExtStr();
}
bool Instruction::isRegInt_immStr_regStr() const {
  return arg1->isRegInt() && arg2->isImmStr() && arg3->isRegStr();
}
bool Instruction::isRegInt_negByte_extFlt() const {
  return arg1->isRegInt() && arg2->isNegByte() && arg3->isExtFlt();
}
bool Instruction::isRegInt_negByte_regFlt() const {
  return arg1->isRegInt() && arg2->isNegByte() && arg3->isRegFlt();
}
bool Instruction::isRegInt_negByte_regInt() const {
  return arg1->isRegInt() && arg2->isNegByte() && arg3->isRegInt();
}
bool Instruction::isRegInt_negWord_extFlt() const {
  return arg1->isRegInt() && arg2->isNegWord() && arg3->isExtFlt();
}
bool Instruction::isRegInt_negWord_regFlt() const {
  return arg1->isRegInt() && arg2->isNegWord() && arg3->isRegFlt();
}
bool Instruction::isRegInt_negWord_regInt() const {
  return arg1->isRegInt() && arg2->isNegWord() && arg3->isRegInt();
}
bool Instruction::isRegInt_posByte_extFlt() const {
  return arg1->isRegInt() && arg2->isPosByte() && arg3->isExtFlt();
}
bool Instruction::isRegInt_posByte_regFlt() const {
  return arg1->isRegInt() && arg2->isPosByte() && arg3->isRegFlt();
}
bool Instruction::isRegInt_posByte_regInt() const {
  return arg1->isRegInt() && arg2->isPosByte() && arg3->isRegInt();
}
bool Instruction::isRegInt_posWord_extFlt() const {
  return arg1->isRegInt() && arg2->isPosWord() && arg3->isExtFlt();
}
bool Instruction::isRegInt_posWord_regFlt() const {
  return arg1->isRegInt() && arg2->isPosWord() && arg3->isRegFlt();
}
bool Instruction::isRegInt_posWord_regInt() const {
  return arg1->isRegInt() && arg2->isPosWord() && arg3->isRegInt();
}
