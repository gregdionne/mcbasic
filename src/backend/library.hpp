// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BACKEND_LIBRARY_HPP
#define BACKEND_LIBRARY_HPP

#include <map>
#include <set>
#include <string>

#include "compiler/instqueue.hpp"

// a library routine
struct Lib {
  // number of times invoked from coder
  int callCount;

  // the implementation
  std::string instructions;

  // any libraries needed by this routine
  std::set<std::string> dependencies;
};

class Library {
public:
  Library(InstQueue &queue_in, bool useUndoc)
      : queue(queue_in), undoc(useUndoc) {
    makeFoundation();
  }

  // make calls (by bytecode or native coder)
  void assemble(InstructionOp *implementation);

  const std::map<std::string, Lib> &getCalls() const { return calls; }
  const std::map<std::string, std::string> &getModules() const {
    return modules;
  }

private:
  // implementation calls
  std::map<std::string, Lib> calls;

  // required library modules
  std::map<std::string, std::string> modules;

  // queue reference
  const InstQueue &queue;

  // flag to allow undoc opcodes
  const bool undoc;

  // calls from within the library
  std::map<std::string, Lib> foundation;

  void makeFoundation();
  void addDependencies(std::set<std::string> &dependencies);
  static std::string mdAlloc();
  static std::string mdArrayRef1();
  static std::string mdArrayRef2();
  static std::string mdArrayRef3();
  static std::string mdArrayRef4();
  static std::string mdArrayRef5();
  static std::string mdArrayRefInt();
  static std::string mdArrayRefFlt();
  static std::string mdStrTmp();
  static std::string mdStrPrm();
  static std::string mdStrDel();
  static std::string mdStrRel();
  static std::string mdStrFlt();
  static std::string mdStrVal();
  static std::string mdStrEqs();
  static std::string mdStrEqbs();
  static std::string mdStrEqx();
  static std::string mdStrLo();
  static std::string mdStrLos();
  static std::string mdStrLobs();
  static std::string mdStrLox();
  static std::string mdRnd();
  std::string mdNegX() const;
  static std::string mdNegTmp2XI();
  static std::string mdNegTmp2XF();
  std::string mdNegArgV() const;
  std::string mdNegTmp() const;
  static std::string mdMul12();
  static std::string mdMul3F();
  static std::string mdMul3I();
  static std::string mdMulBytF();
  static std::string mdMulBytI();
  static std::string mdMulFlt();
  static std::string mdMulHlf();
  static std::string mdMulInt();
  static std::string mdShlInt();
  static std::string mdShlFlt();
  static std::string mdShrFlt();
  static std::string mdShift();
  static std::string mdInvFlt();
  static std::string mdDivFlt();
  static std::string mdIDivFlt();
  static std::string mdModFlti();
  static std::string mdModFlt();
  static std::string mdDivMod();
  static std::string mdIModByte();
  static std::string mdIDivByte();
  static std::string mdIDiv35();
  static std::string mdIDiv5S();
  static std::string mdPowIntN();
  static std::string mdPowFltN();
  static std::string mdPowFlt();
  static std::string mdRMul315();
  static std::string mdMSBit();
  static std::string mdSetBit();
  static std::string mdTmp2XF();
  static std::string mdTmp2XI();
  static std::string mdArg2X();
  static std::string mdX2Arg();
  static std::string mdSqr();
  static std::string mdExp();
  static std::string mdLog();
  std::string mdSin() const;
  static std::string mdCos();
  static std::string mdTan();
  static std::string mdPrAt();
  static std::string mdPrint();
  static std::string mdPrTab();
  static std::string mdSet();
  static std::string mdSetC();
  static std::string mdPoint();
  static std::string mdPeek();
  static std::string mdGetEq();
  static std::string mdGetNe();
  static std::string mdGetLo();
  static std::string mdGetHs();
  static std::string mdGetLt();
  static std::string mdGetGe();
  static std::string mdInput();
  static std::string mdRdPUByte();
  static std::string mdRdPSByte();
  static std::string mdRdPUWord();
  static std::string mdRdPSWord();
  static std::string mdRdPNumbr();
  static std::string mdRdPStrng();
  static std::string mdRdNStrng();
  static std::string mdRdSUByte();
  static std::string mdRdSSByte();
  static std::string mdRdSUWord();
  static std::string mdRdSSWord();
  static std::string mdRdSNumbr();
  static std::string mdRdSStrng();
  static std::string mdTo(bool byteCode, bool genLines);
  static std::string mdToNative();
  static std::string mdToNativeGenLines();
  static std::string mdToByteCode();
  static std::string mdToByteCodeGenLines();
  static std::string mdByteCode();
};
#endif
