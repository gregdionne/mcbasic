// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef LIBRARY_HPP
#define LIBRARY_HPP

#include <map>
#include <set>
#include <string>

#include "instqueue.hpp"

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
  explicit Library(InstQueue &queue_in) : queue(queue_in) { makeFoundation(); }

  // implementation calls
  std::map<std::string, Lib> calls;

  // calls from within the library
  std::map<std::string, Lib> foundation;

  // required library modules
  std::map<std::string, std::string> modules;

  // queue reference
  InstQueue &queue;

  // make calls (by bytecode or native coder)
  void assemble(InstructionOp *implementation);

private:
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
  static std::string mdMul12();
  static std::string mdMulFlt();
  static std::string mdMulHlf();
  static std::string mdMulInt();
  static std::string mdShlInt();
  static std::string mdShlFlt();
  static std::string mdShrFlt();
  static std::string mdInvFlt();
  static std::string mdDivFlt();
  static std::string mdModFlt();
  static std::string mdDivMod();
  static std::string mdSin();
  static std::string mdCos();
  static std::string mdTan();
  static std::string mdPrAt();
  static std::string mdPrint();
  static std::string mdPrTab();
  static std::string mdSet();
  static std::string mdSetC();
  static std::string mdPoint();
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
