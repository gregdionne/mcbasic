// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_NATIVEIMPLEMENTATION_HPP
#define BACKEND_NATIVEIMPLEMENTATION_HPP

#include "coreimplementation.hpp"

// native call specific implementation of virtual instruction set
// these usually deal with items that use the "stack" address
// mode (labels, string constants) or uses the stack itself.
//
// Otherwise, preamble returns empty() as the X and ACCD registers
// are loaded explicitly by the coder; and the return address of the
// JSR is used for the next instruction.

class NativeImplementation : public CoreImplementation {
public:
  NativeImplementation() = default;
  NativeImplementation(const NativeImplementation &) = delete;
  NativeImplementation(NativeImplementation &&) = delete;
  NativeImplementation &operator=(const NativeImplementation &) = delete;
  NativeImplementation &operator=(NativeImplementation &&) = delete;
  ~NativeImplementation() override = default;

  std::string regInt_immLbl(InstJmpIfEqual &inst) override;
  std::string regFlt_immLbl(InstJmpIfEqual &inst) override;
  std::string regInt_immLbl(InstJmpIfNotEqual &inst) override;
  std::string regFlt_immLbl(InstJmpIfNotEqual &inst) override;

  std::string regInt_immLbl(InstJsrIfEqual &inst) override;
  std::string regFlt_immLbl(InstJsrIfEqual &inst) override;
  std::string regInt_immLbl(InstJsrIfNotEqual &inst) override;
  std::string regFlt_immLbl(InstJsrIfNotEqual &inst) override;

  std::string immLbl(InstGoTo &inst) override;
  std::string immLbl(InstGoSub &inst) override;

  std::string regStr_immStr(InstLd &inst) override;
  std::string extStr_immStr(InstLd &inst) override;
  std::string indStr_immStr(InstLd &inst) override;

  std::string regStr_immStr(InstStrInit &inst) override;

  std::string regStr_regStr_immStr(InstStrCat &inst) override;

  std::string regInt_regStr_immStr(InstLdEq &inst) override;
  std::string regInt_regStr_immStr(InstLdNe &inst) override;
  std::string regInt_regStr_immStr(InstLdLo &inst) override;
  std::string regInt_regStr_immStr(InstLdHs &inst) override;

  std::string ptrInt_posByte(InstTo &inst) override;
  std::string ptrInt_negByte(InstTo &inst) override;
  std::string ptrInt_posWord(InstTo &inst) override;
  std::string ptrInt_negWord(InstTo &inst) override;
  std::string ptrInt_regInt(InstTo &inst) override;
  std::string ptrInt_extInt(InstTo &inst) override;
  std::string ptrInt_regFlt(InstTo &inst) override;
  std::string ptrInt_extFlt(InstTo &inst) override;
  std::string ptrFlt_posByte(InstTo &inst) override;
  std::string ptrFlt_negByte(InstTo &inst) override;
  std::string ptrFlt_posWord(InstTo &inst) override;
  std::string ptrFlt_negWord(InstTo &inst) override;
  std::string ptrFlt_regInt(InstTo &inst) override;
  std::string ptrFlt_extInt(InstTo &inst) override;
  std::string ptrFlt_regFlt(InstTo &inst) override;
  std::string ptrFlt_extFlt(InstTo &inst) override;

  std::string extInt(InstNextVar &inst) override;
  std::string extFlt(InstNextVar &inst) override;

  std::string inherent(InstNext &inst) override;

  std::string ptrInt_regInt(InstStep &inst) override;
  std::string ptrFlt_regInt(InstStep &inst) override;
  std::string ptrFlt_regFlt(InstStep &inst) override;

  std::string inherent(InstReturn &inst) override;
  std::string regInt_immLbls(InstOnGoTo &inst) override;
  std::string regInt_immLbls(InstOnGoSub &inst) override;

  std::string immStr(InstPr &inst) override;

  std::string inherent(InstInputBuf &inst) override;
  std::string extFlt(InstReadBuf &inst) override;
  std::string indFlt(InstReadBuf &inst) override;
  std::string extStr(InstReadBuf &inst) override;
  std::string indStr(InstReadBuf &inst) override;
};

#endif
