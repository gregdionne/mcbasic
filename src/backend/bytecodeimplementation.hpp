// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_BYTECODEIMPLEMENTATION_HPP
#define BACKEND_BYTECODEIMPLEMENTATION_HPP

#include "coreimplementation.hpp"

// bytecode-specific implementation of virtual instruction set
// these usually deal with items that use the "stack" address
// mode (labels, string constants) or uses the stack itself.
//
// Otherwise, the core implementation will call preamble() to manage
// fetching data into the X and ACCD registers and adjust the next
// instruction pointer (nxtinst) before executing.

class ByteCodeImplementation : public CoreImplementation {
public:
  ByteCodeImplementation() = default;
  ByteCodeImplementation(const ByteCodeImplementation &) = delete;
  ByteCodeImplementation(ByteCodeImplementation &&) = delete;
  ByteCodeImplementation &operator=(const ByteCodeImplementation &) = delete;
  ByteCodeImplementation &operator=(ByteCodeImplementation &&) = delete;
  ~ByteCodeImplementation() override = default;

  std::string inherent(InstBegin &inst) override;

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

  std::string regInt_immLbls(InstOnGoTo &inst) override;
  std::string regInt_immLbls(InstOnGoSub &inst) override;

  std::string inherent(InstReturn &inst) override;

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

  std::string ptrInt_regInt(InstStep &inst) override;
  std::string ptrFlt_regInt(InstStep &inst) override;
  std::string ptrFlt_regFlt(InstStep &inst) override;

  std::string inherent(InstNext &inst) override;

  std::string extInt(InstNextVar &inst) override;
  std::string extFlt(InstNextVar &inst) override;

  std::string immStr(InstPr &inst) override;

  std::string inherent(InstInputBuf &inst) override;
  std::string extFlt(InstReadBuf &inst) override;
  std::string indFlt(InstReadBuf &inst) override;
  std::string extStr(InstReadBuf &inst) override;
  std::string indStr(InstReadBuf &inst) override;

protected:
  // hook for core implementation to implement bytecode interpreter
  void preamble(Assembler &tasm, Instruction &inst) override;

private:
  // hints for preamble() to call various address modes
  // "stack" address modes are excepted from these routines
  // and have bytecode-specific implementation
  static bool isGetAddr(Instruction &inst);
  static bool isExtend(Instruction &inst);
  static bool isGetByte(Instruction &inst);
  static bool isGetWord(Instruction &inst);
  static bool isExtByte(Instruction &inst);
  static bool isExtWord(Instruction &inst);
  static bool isByteExt(Instruction &inst);
  static bool isWordExt(Instruction &inst);
  static bool isNoArgs(Instruction &inst);
};

#endif
