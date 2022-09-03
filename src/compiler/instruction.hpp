// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPILER_INSTRUCTION_HPP
#define COMPILER_INSTRUCTION_HPP

#include "utils/memutils.hpp"
#include <set>

#include "addressmode.hpp"

class Instruction;
class InstComment;
class InstLabel;
class InstArrayDim1;
class InstArrayRef1;
class InstArrayVal1;
class InstArrayDim2;
class InstArrayRef2;
class InstArrayVal2;
class InstArrayDim3;
class InstArrayRef3;
class InstArrayVal3;
class InstArrayDim4;
class InstArrayRef4;
class InstArrayVal4;
class InstArrayDim5;
class InstArrayRef5;
class InstArrayVal5;
class InstArrayDim;
class InstArrayRef;
class InstArrayVal;
class InstLd;
class InstOne;
class InstTrue;
class InstClr;
class InstInc;
class InstDec;
class InstAbs;
class InstFract;
class InstDbl;
class InstHlf;
class InstSq;
class InstShift;
class InstNeg;
class InstCom;
class InstSgn;
class InstPeek;
class InstPeekWord;
class InstSqr;
class InstInv;
class InstLog;
class InstExp;
class InstSin;
class InstCos;
class InstTan;
class InstIRnd;
class InstRnd;
class InstStr;
class InstVal;
class InstAsc;
class InstLen;
class InstChr;
class InstInkey;
class InstMem;
class InstPos;
class InstTimer;
class InstAdd;
class InstSub;
class InstRSub;
class InstMul;
class InstMul3;
class InstDiv;
class InstIDiv;
class InstIDiv3;
class InstIDiv5;
class InstIDiv5S;
class InstPow;
class InstLdEq;
class InstLdNe;
class InstLdLt;
class InstLdLt;
class InstLdGe;
class InstLdGe;
class InstAnd;
class InstOr;
class InstPoint;
class InstStrInit;
class InstStrCat;
class InstLeft;
class InstRight;
class InstMid;
class InstMidT;
class InstPrTab;
class InstPrComma;
class InstPrSpace;
class InstPrCR;
class InstPrAt;
class InstPr;
class InstFor;
class InstForOne;
class InstForTrue;
class InstForClr;
class InstTo;
class InstStep;
class InstNext;
class InstNextVar;
class InstGoTo;
class InstGoSub;
class InstOnGoTo;
class InstOnGoSub;
class InstJsrIfEqual;
class InstJsrIfNotEqual;
class InstJmpIfEqual;
class InstJmpIfNotEqual;
class InstInputBuf;
class InstReadBuf;
class InstIgnoreExtra;
class InstRead;
class InstRestore;
class InstReturn;
class InstClear;
class InstCls;
class InstClsN;
class InstSet;
class InstSetC;
class InstReset;
class InstStop;
class InstPoke;
class InstSound;
class InstExec;
class InstError;
class InstBegin;
class InstEnd;

class InstructionOp {
public:
  InstructionOp() = default;
  InstructionOp(const InstructionOp &) = delete;
  InstructionOp(InstructionOp &&) = delete;
  InstructionOp &operator=(const InstructionOp &) = delete;
  InstructionOp &operator=(InstructionOp &&) = delete;
  virtual ~InstructionOp() = default;

  virtual std::string operate(Instruction &inst) = 0;
  virtual std::string operate(InstComment &inst) = 0;
  virtual std::string operate(InstLabel &inst) = 0;
  virtual std::string operate(InstArrayDim1 &inst) = 0;
  virtual std::string operate(InstArrayRef1 &inst) = 0;
  virtual std::string operate(InstArrayVal1 &inst) = 0;
  virtual std::string operate(InstArrayDim2 &inst) = 0;
  virtual std::string operate(InstArrayRef2 &inst) = 0;
  virtual std::string operate(InstArrayVal2 &inst) = 0;
  virtual std::string operate(InstArrayDim3 &inst) = 0;
  virtual std::string operate(InstArrayRef3 &inst) = 0;
  virtual std::string operate(InstArrayVal3 &inst) = 0;
  virtual std::string operate(InstArrayDim4 &inst) = 0;
  virtual std::string operate(InstArrayRef4 &inst) = 0;
  virtual std::string operate(InstArrayVal4 &inst) = 0;
  virtual std::string operate(InstArrayDim5 &inst) = 0;
  virtual std::string operate(InstArrayRef5 &inst) = 0;
  virtual std::string operate(InstArrayVal5 &inst) = 0;
  virtual std::string operate(InstArrayDim &inst) = 0;
  virtual std::string operate(InstArrayRef &inst) = 0;
  virtual std::string operate(InstArrayVal &inst) = 0;
  virtual std::string operate(InstLd &inst) = 0;
  virtual std::string operate(InstOne &inst) = 0;
  virtual std::string operate(InstTrue &inst) = 0;
  virtual std::string operate(InstClr &inst) = 0;
  virtual std::string operate(InstInc &inst) = 0;
  virtual std::string operate(InstDec &inst) = 0;
  virtual std::string operate(InstAbs &inst) = 0;
  virtual std::string operate(InstFract &inst) = 0;
  virtual std::string operate(InstDbl &inst) = 0;
  virtual std::string operate(InstHlf &inst) = 0;
  virtual std::string operate(InstSq &inst) = 0;
  virtual std::string operate(InstShift &inst) = 0;
  virtual std::string operate(InstNeg &inst) = 0;
  virtual std::string operate(InstCom &inst) = 0;
  virtual std::string operate(InstSgn &inst) = 0;
  virtual std::string operate(InstPeek &inst) = 0;
  virtual std::string operate(InstPeekWord &inst) = 0;
  virtual std::string operate(InstSqr &inst) = 0;
  virtual std::string operate(InstInv &inst) = 0;
  virtual std::string operate(InstLog &inst) = 0;
  virtual std::string operate(InstExp &inst) = 0;
  virtual std::string operate(InstSin &inst) = 0;
  virtual std::string operate(InstCos &inst) = 0;
  virtual std::string operate(InstTan &inst) = 0;
  virtual std::string operate(InstIRnd &inst) = 0;
  virtual std::string operate(InstRnd &inst) = 0;
  virtual std::string operate(InstStr &inst) = 0;
  virtual std::string operate(InstVal &inst) = 0;
  virtual std::string operate(InstAsc &inst) = 0;
  virtual std::string operate(InstLen &inst) = 0;
  virtual std::string operate(InstChr &inst) = 0;
  virtual std::string operate(InstInkey &inst) = 0;
  virtual std::string operate(InstMem &inst) = 0;
  virtual std::string operate(InstPos &inst) = 0;
  virtual std::string operate(InstTimer &inst) = 0;
  virtual std::string operate(InstAdd &inst) = 0;
  virtual std::string operate(InstSub &inst) = 0;
  virtual std::string operate(InstRSub &inst) = 0;
  virtual std::string operate(InstMul &inst) = 0;
  virtual std::string operate(InstMul3 &inst) = 0;
  virtual std::string operate(InstDiv &inst) = 0;
  virtual std::string operate(InstIDiv &inst) = 0;
  virtual std::string operate(InstIDiv3 &inst) = 0;
  virtual std::string operate(InstIDiv5 &inst) = 0;
  virtual std::string operate(InstIDiv5S &inst) = 0;
  virtual std::string operate(InstPow &inst) = 0;
  virtual std::string operate(InstLdEq &inst) = 0;
  virtual std::string operate(InstLdNe &inst) = 0;
  virtual std::string operate(InstLdLt &inst) = 0;
  virtual std::string operate(InstLdGe &inst) = 0;
  virtual std::string operate(InstAnd &inst) = 0;
  virtual std::string operate(InstOr &inst) = 0;
  virtual std::string operate(InstPoint &inst) = 0;
  virtual std::string operate(InstStrInit &inst) = 0;
  virtual std::string operate(InstStrCat &inst) = 0;
  virtual std::string operate(InstLeft &inst) = 0;
  virtual std::string operate(InstRight &inst) = 0;
  virtual std::string operate(InstMid &inst) = 0;
  virtual std::string operate(InstMidT &inst) = 0;
  virtual std::string operate(InstPrTab &inst) = 0;
  virtual std::string operate(InstPrComma &inst) = 0;
  virtual std::string operate(InstPrSpace &inst) = 0;
  virtual std::string operate(InstPrCR &inst) = 0;
  virtual std::string operate(InstPrAt &inst) = 0;
  virtual std::string operate(InstPr &inst) = 0;
  virtual std::string operate(InstFor &inst) = 0;
  virtual std::string operate(InstForOne &inst) = 0;
  virtual std::string operate(InstForTrue &inst) = 0;
  virtual std::string operate(InstForClr &inst) = 0;
  virtual std::string operate(InstTo &inst) = 0;
  virtual std::string operate(InstStep &inst) = 0;
  virtual std::string operate(InstNext &inst) = 0;
  virtual std::string operate(InstNextVar &inst) = 0;
  virtual std::string operate(InstGoTo &inst) = 0;
  virtual std::string operate(InstGoSub &inst) = 0;
  virtual std::string operate(InstOnGoTo &inst) = 0;
  virtual std::string operate(InstOnGoSub &inst) = 0;
  virtual std::string operate(InstJsrIfEqual &inst) = 0;
  virtual std::string operate(InstJsrIfNotEqual &inst) = 0;
  virtual std::string operate(InstJmpIfEqual &inst) = 0;
  virtual std::string operate(InstJmpIfNotEqual &inst) = 0;
  virtual std::string operate(InstInputBuf &inst) = 0;
  virtual std::string operate(InstReadBuf &inst) = 0;
  virtual std::string operate(InstIgnoreExtra &inst) = 0;
  virtual std::string operate(InstRead &inst) = 0;
  virtual std::string operate(InstRestore &inst) = 0;
  virtual std::string operate(InstReturn &inst) = 0;
  virtual std::string operate(InstClear &inst) = 0;
  virtual std::string operate(InstCls &inst) = 0;
  virtual std::string operate(InstClsN &inst) = 0;
  virtual std::string operate(InstSet &inst) = 0;
  virtual std::string operate(InstSetC &inst) = 0;
  virtual std::string operate(InstReset &inst) = 0;
  virtual std::string operate(InstStop &inst) = 0;
  virtual std::string operate(InstPoke &inst) = 0;
  virtual std::string operate(InstSound &inst) = 0;
  virtual std::string operate(InstExec &inst) = 0;
  virtual std::string operate(InstError &inst) = 0;
  virtual std::string operate(InstBegin &inst) = 0;
  virtual std::string operate(InstEnd &inst) = 0;
};

class Instruction {
public:
  explicit Instruction(std::string mnem)
      : mnemonic(mv(mnem)), arg1(makeup<AddressModeInh>()),
        arg2(makeup<AddressModeInh>()), arg3(makeup<AddressModeInh>()),
        result(makeup<AddressModeInh>()) {}
  Instruction(std::string mnem, up<AddressMode> arg1_in)
      : mnemonic(mv(mnem)), arg1(mv(arg1_in)), arg2(makeup<AddressModeInh>()),
        arg3(makeup<AddressModeInh>()), result(makeup<AddressModeInh>()) {}
  Instruction(std::string mnem, up<AddressMode> arg1_in,
              up<AddressMode> arg2_in)
      : mnemonic(mv(mnem)), arg1(mv(arg1_in)), arg2(mv(arg2_in)),
        arg3(makeup<AddressModeInh>()), result(makeup<AddressModeInh>()) {}
  Instruction(std::string mnem, up<AddressMode> arg1_in,
              up<AddressMode> arg2_in, up<AddressMode> arg3_in)
      : mnemonic(mv(mnem)), arg1(mv(arg1_in)), arg2(mv(arg2_in)),
        arg3(mv(arg3_in)), result(makeup<AddressModeInh>()) {}

  Instruction() = delete;
  Instruction(const Instruction &) = delete;
  Instruction(Instruction &&) = delete;
  Instruction &operator=(const Instruction &) = delete;
  Instruction &operator=(Instruction &&) = delete;
  virtual ~Instruction() = default;

  virtual std::string operate(InstructionOp * /*inst*/) {
    return "\t!unimplemented\n";
  }

  bool isIndFlt() const;
  bool isIndInt() const;
  bool isExtFlt() const;
  bool isExtInt() const;
  bool isExtFlt_extFlt() const;
  bool isExtFlt_negByte() const;
  bool isExtFlt_negWord() const;
  bool isExtFlt_posByte() const;
  bool isExtFlt_posWord() const;
  bool isExtFlt_regFlt() const;
  bool isExtFlt_regInt() const;
  bool isExtInt_extInt() const;
  bool isExtInt_negByte() const;
  bool isExtInt_negWord() const;
  bool isExtInt_posByte() const;
  bool isExtInt_posWord() const;
  bool isExtInt_regInt() const;
  bool isExtStr_immStr() const;
  bool isExtStr_regStr() const;
  bool isDexFlt_extFlt() const;
  bool isDexFlt_extInt() const;
  bool isDexInt_extInt() const;
  bool isDexStr_extStr() const;
  bool isIndFlt_indFlt() const;
  bool isIndFlt_negByte() const;
  bool isIndFlt_negWord() const;
  bool isIndFlt_posByte() const;
  bool isIndFlt_posWord() const;
  bool isIndFlt_regFlt() const;
  bool isIndFlt_regInt() const;
  bool isIndInt_indInt() const;
  bool isIndInt_negByte() const;
  bool isIndInt_negWord() const;
  bool isIndInt_posByte() const;
  bool isIndInt_posWord() const;
  bool isIndInt_regInt() const;
  bool isIndStr_immStr() const;
  bool isIndStr_regStr() const;
  bool isPosByte_extInt() const;
  bool isPosByte_regInt() const;
  bool isPosWord_extInt() const;
  bool isPosWord_regInt() const;
  bool isPtrFlt_extFlt() const;
  bool isPtrFlt_extInt() const;
  bool isPtrFlt_negByte() const;
  bool isPtrFlt_negWord() const;
  bool isPtrFlt_posByte() const;
  bool isPtrFlt_posWord() const;
  bool isPtrFlt_regFlt() const;
  bool isPtrFlt_regInt() const;
  bool isPtrInt_extInt() const;
  bool isPtrInt_negByte() const;
  bool isPtrInt_negWord() const;
  bool isPtrInt_posByte() const;
  bool isPtrInt_posWord() const;
  bool isPtrInt_regInt() const;
  bool isPtrInt_regFlt() const;
  bool isPtrInt_extFlt() const;
  bool isRegFlt_extFlt() const;
  bool isRegFlt_extInt() const;
  bool isRegFlt_extStr() const;
  bool isRegFlt_immLbl() const;
  bool isRegFlt_negByte() const;
  bool isRegFlt_negWord() const;
  bool isRegFlt_posByte() const;
  bool isRegFlt_posWord() const;
  bool isRegFlt_regFlt() const;
  bool isRegFlt_regInt() const;
  bool isRegFlt_regStr() const;
  bool isRegInt_extFlt() const;
  bool isRegInt_extInt() const;
  bool isRegInt_extStr() const;
  bool isRegInt_immLbl() const;
  bool isRegInt_immLbls() const;
  bool isRegInt_negByte() const;
  bool isRegInt_negWord() const;
  bool isRegInt_posByte() const;
  bool isRegInt_posWord() const;
  bool isRegInt_regFlt() const;
  bool isRegInt_regInt() const;
  bool isRegInt_regStr() const;
  bool isRegStr_extFlt() const;
  bool isRegStr_extInt() const;
  bool isRegStr_extStr() const;
  bool isRegStr_immStr() const;
  bool isRegStr_regFlt() const;
  bool isRegStr_regInt() const;
  bool isRegStr_regStr() const;

  bool isExtFlt_extFlt_negByte() const;
  bool isExtFlt_extFlt_negWord() const;
  bool isExtFlt_extFlt_posByte() const;
  bool isExtFlt_extFlt_posWord() const;
  bool isExtFlt_extFlt_regFlt() const;
  bool isExtFlt_extFlt_regInt() const;
  bool isExtInt_extInt_negByte() const;
  bool isExtInt_extInt_negWord() const;
  bool isExtInt_extInt_posByte() const;
  bool isExtInt_extInt_posWord() const;
  bool isExtInt_extInt_regInt() const;
  bool isIndFlt_indFlt_negByte() const;
  bool isIndFlt_indFlt_negWord() const;
  bool isIndFlt_indFlt_posByte() const;
  bool isIndFlt_indFlt_posWord() const;
  bool isIndFlt_indFlt_regFlt() const;
  bool isIndFlt_indFlt_regInt() const;
  bool isIndInt_indInt_negByte() const;
  bool isIndInt_indInt_negWord() const;
  bool isIndInt_indInt_posByte() const;
  bool isIndInt_indInt_posWord() const;
  bool isIndInt_indInt_regInt() const;
  bool isRegFlt_extFlt_negByte() const;
  bool isRegFlt_extFlt_negWord() const;
  bool isRegFlt_extFlt_posByte() const;
  bool isRegFlt_extFlt_posWord() const;
  bool isRegFlt_negByte_extFlt() const;
  bool isRegFlt_negWord_extFlt() const;
  bool isRegFlt_posByte_extFlt() const;
  bool isRegFlt_posWord_extFlt() const;
  bool isRegFlt_regFlt_extFlt() const;
  bool isRegFlt_regFlt_extInt() const;
  bool isRegFlt_regFlt_negByte() const;
  bool isRegFlt_regFlt_negWord() const;
  bool isRegFlt_regFlt_posByte() const;
  bool isRegFlt_regFlt_posWord() const;
  bool isRegFlt_regFlt_regFlt() const;
  bool isRegFlt_regFlt_regInt() const;
  bool isRegFlt_regInt_extFlt() const;
  bool isRegFlt_regInt_extInt() const;
  bool isRegFlt_regInt_negByte() const;
  bool isRegFlt_regInt_negWord() const;
  bool isRegFlt_regInt_posByte() const;
  bool isRegFlt_regInt_posWord() const;
  bool isRegFlt_regInt_regFlt() const;
  bool isRegFlt_regInt_regInt() const;
  bool isRegFlt_extFlt_dexFlt() const;
  bool isRegFlt_extFlt_dexInt() const;
  bool isRegFlt_extInt_dexFlt() const;
  bool isRegInt_extInt_dexInt() const;
  bool isRegInt_extInt_dexFlt() const;
  bool isRegInt_extFlt_dexFlt() const;
  bool isRegInt_extFlt_dexInt() const;
  bool isRegInt_extStr_dexStr() const;
  bool isRegInt_extInt_negByte() const;
  bool isRegInt_extInt_negWord() const;
  bool isRegInt_extInt_posByte() const;
  bool isRegInt_extInt_posWord() const;
  bool isRegInt_negByte_extInt() const;
  bool isRegInt_negWord_extInt() const;
  bool isRegInt_posByte_extInt() const;
  bool isRegInt_posWord_extInt() const;
  bool isRegInt_regFlt_extFlt() const;
  bool isRegInt_regFlt_extInt() const;
  bool isRegInt_regFlt_negByte() const;
  bool isRegInt_regFlt_negWord() const;
  bool isRegInt_regFlt_posByte() const;
  bool isRegInt_regFlt_posWord() const;
  bool isRegInt_regFlt_regFlt() const;
  bool isRegInt_regFlt_regInt() const;
  bool isRegInt_regInt_extFlt() const;
  bool isRegInt_regInt_extInt() const;
  bool isRegInt_regInt_negByte() const;
  bool isRegInt_regInt_negWord() const;
  bool isRegInt_regInt_posByte() const;
  bool isRegInt_regInt_posWord() const;
  bool isRegInt_regInt_regFlt() const;
  bool isRegInt_regInt_regInt() const;
  bool isRegInt_regStr_extStr() const;
  bool isRegInt_regStr_immStr() const;
  bool isRegInt_regStr_regStr() const;
  bool isRegStr_regStr_extInt() const;
  bool isRegStr_regStr_extStr() const;
  bool isRegStr_regStr_immStr() const;
  bool isRegStr_regStr_posByte() const;
  bool isRegStr_regStr_regInt() const;
  bool isRegStr_regStr_regStr() const;

  void resultArg();
  void resultLet();
  void resultArg1();
  void resultInt();
  void resultFlt();
  void resultStr();
  void resultPtr();
  void resultShift();
  void resultPromoteFlt();
  void resultPow();
  void labelArg();
  std::string callLabel() const;

  std::string comment;
  std::string label;
  std::string mnemonic;
  up<AddressMode> arg1;
  up<AddressMode> arg2;
  up<AddressMode> arg3;
  up<AddressMode> result;
  std::set<std::string> dependencies;
};

template <typename T> class OperableInstruction : public Instruction {
public:
  explicit OperableInstruction(std::string mnem) : Instruction(mv(mnem)) {}

  OperableInstruction(std::string mnem, up<AddressMode> arg1_in)
      : Instruction(mv(mnem), mv(arg1_in)) {}

  OperableInstruction(std::string mnem, up<AddressMode> arg1_in,
                      up<AddressMode> arg2_in)
      : Instruction(mv(mnem), mv(arg1_in), mv(arg2_in)) {}

  OperableInstruction(std::string mnem, up<AddressMode> arg1_in,
                      up<AddressMode> arg2_in, up<AddressMode> arg3_in)
      : Instruction(mv(mnem), mv(arg1_in), mv(arg2_in), mv(arg3_in)) {}

  std::string operate(InstructionOp *iop) override {
    return iop->operate(*static_cast<T *>(this));
  }
};

class InstComment : public OperableInstruction<InstComment> {
public:
  explicit InstComment(std::string const &c) : OperableInstruction("") {
    comment = c;
  }
};

class InstLabel : public OperableInstruction<InstLabel> {
public:
  InstLabel(up<AddressMode> lineNum, bool g)
      : OperableInstruction(g ? "label" : "", mv(lineNum)), generateLines(g) {
    labelArg();
  }
  bool generateLines;
};

class InstArrayDim1 : public OperableInstruction<InstArrayDim1> {
public:
  InstArrayDim1(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrdim1", mv(firstArg), mv(arraySymbol)) {}
};

class InstArrayRef1 : public OperableInstruction<InstArrayRef1> {
public:
  InstArrayRef1(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrref1", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal1 : public OperableInstruction<InstArrayVal1> {
public:
  InstArrayVal1(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrval1", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim2 : public OperableInstruction<InstArrayDim2> {
public:
  InstArrayDim2(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrdim2", mv(firstArg), mv(arraySymbol)) {}
};

class InstArrayRef2 : public OperableInstruction<InstArrayRef2> {
public:
  InstArrayRef2(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrref2", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal2 : public OperableInstruction<InstArrayVal2> {
public:
  InstArrayVal2(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrval2", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim3 : public OperableInstruction<InstArrayDim3> {
public:
  InstArrayDim3(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrdim3", mv(firstArg), mv(arraySymbol)) {}
};

class InstArrayRef3 : public OperableInstruction<InstArrayRef3> {
public:
  InstArrayRef3(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrref3", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal3 : public OperableInstruction<InstArrayVal3> {
public:
  InstArrayVal3(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrval3", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim4 : public OperableInstruction<InstArrayDim4> {
public:
  InstArrayDim4(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrdim4", mv(firstArg), mv(arraySymbol)) {}
};

class InstArrayRef4 : public OperableInstruction<InstArrayRef4> {
public:
  InstArrayRef4(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrref4", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal4 : public OperableInstruction<InstArrayVal4> {
public:
  InstArrayVal4(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrval4", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim5 : public OperableInstruction<InstArrayDim5> {
public:
  InstArrayDim5(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrdim5", mv(firstArg), mv(arraySymbol)) {}
};

class InstArrayRef5 : public OperableInstruction<InstArrayRef5> {
public:
  InstArrayRef5(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrref5", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal5 : public OperableInstruction<InstArrayVal5> {
public:
  InstArrayVal5(up<AddressMode> firstArg, up<AddressMode> arraySymbol)
      : OperableInstruction("arrval5", mv(firstArg), mv(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim : public OperableInstruction<InstArrayDim> {
public:
  InstArrayDim(up<AddressMode> firstArg, up<AddressMode> arraySymbol,
               up<AddressModeImm> argCount)
      : OperableInstruction("arrdim", mv(firstArg), mv(arraySymbol),
                            mv(argCount)) {}
};

class InstArrayRef : public OperableInstruction<InstArrayRef> {
public:
  InstArrayRef(up<AddressMode> firstArg, up<AddressMode> arraySymbol,
               up<AddressModeImm> argCount)
      : OperableInstruction("arrref", mv(firstArg), mv(arraySymbol),
                            mv(argCount)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal : public OperableInstruction<InstArrayVal> {
public:
  InstArrayVal(up<AddressMode> firstArg, up<AddressMode> arraySymbol,
               up<AddressModeImm> argCount)
      : OperableInstruction("arrval", mv(firstArg), mv(arraySymbol),
                            mv(argCount)) {
    arrayArg();
  }
  void arrayArg();
};

class InstShift : public OperableInstruction<InstShift> {
public:
  InstShift(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("shift", mv(dest), mv(am1), mv(am2)) {
    resultShift();
  }
};

// Unary (argument)

class InstLd : public OperableInstruction<InstLd> {
public:
  InstLd(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("ld", mv(dest), mv(am)) {
    resultLet();
  }
};

class InstOne : public OperableInstruction<InstOne> {
public:
  explicit InstOne(up<AddressMode> dest)
      : OperableInstruction("one", mv(dest)) {
    resultLet();
  }
};

class InstTrue : public OperableInstruction<InstTrue> {
public:
  explicit InstTrue(up<AddressMode> dest)
      : OperableInstruction("true", mv(dest)) {
    resultLet();
  }
};

class InstClr : public OperableInstruction<InstClr> {
public:
  explicit InstClr(up<AddressMode> dest)
      : OperableInstruction("clr", mv(dest)) {
    resultLet();
  }
};

class InstInc : public OperableInstruction<InstInc> {
public:
  InstInc(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("inc", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstDec : public OperableInstruction<InstDec> {
public:
  InstDec(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("dec", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstAbs : public OperableInstruction<InstAbs> {
public:
  InstAbs(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("abs", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstFract : public OperableInstruction<InstFract> {
public:
  InstFract(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("fract", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstDbl : public OperableInstruction<InstDbl> {
public:
  InstDbl(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("dbl", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstSq : public OperableInstruction<InstSq> {
public:
  InstSq(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("sq", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstNeg : public OperableInstruction<InstNeg> {
public:
  InstNeg(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("neg", mv(dest), mv(am)) {
    resultArg();
  }
};

class InstMul3 : public OperableInstruction<InstMul3> {
public:
  InstMul3(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("mul3", mv(dest), mv(am)) {
    resultArg();
  }
};

// Unary (integer)

class InstCom : public OperableInstruction<InstCom> {
public:
  InstCom(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("com", mv(dest), mv(am)) {
    resultInt();
  }
};

class InstSgn : public OperableInstruction<InstSgn> {
public:
  InstSgn(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("sgn", mv(dest), mv(am)) {
    resultInt();
  }
};

class InstPeek : public OperableInstruction<InstPeek> {
public:
  InstPeek(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("peek", mv(dest), mv(am)) {
    resultInt();
  }
};

class InstPeekWord : public OperableInstruction<InstPeekWord> {
public:
  InstPeekWord(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("peekw", mv(dest), mv(am)) {
    resultInt();
  }
};

// Unary (float)

class InstHlf : public OperableInstruction<InstHlf> {
public:
  InstHlf(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("hlf", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstSqr : public OperableInstruction<InstSqr> {
public:
  InstSqr(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("sqr", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstInv : public OperableInstruction<InstInv> {
public:
  InstInv(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("inv", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstLog : public OperableInstruction<InstLog> {
public:
  InstLog(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("log", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstExp : public OperableInstruction<InstExp> {
public:
  InstExp(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("exp", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstSin : public OperableInstruction<InstSin> {
public:
  InstSin(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("sin", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstCos : public OperableInstruction<InstCos> {
public:
  InstCos(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("cos", mv(dest), mv(am)) {
    resultFlt();
  }
};

class InstTan : public OperableInstruction<InstTan> {
public:
  InstTan(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("tan", mv(dest), mv(am)) {
    resultFlt();
  }
};

// Unary (float int if arg != 0, implicit int)

class InstIRnd : public OperableInstruction<InstIRnd> {
public:
  InstIRnd(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("irnd", mv(dest), mv(am)) {
    resultInt();
  }
};

class InstRnd : public OperableInstruction<InstRnd> {
public:
  InstRnd(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("rnd", mv(dest), mv(am)) {
    resultFlt();
  }
};

// Unary (string)
class InstStr : public OperableInstruction<InstStr> {
public:
  InstStr(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("str", mv(dest), mv(am)) {
    resultStr();
  }
};

// Unary (float)
class InstVal : public OperableInstruction<InstVal> {
public:
  InstVal(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("val", mv(dest), mv(am)) {
    resultFlt();
  }
};

// Unary (int)
class InstAsc : public OperableInstruction<InstAsc> {
public:
  InstAsc(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("asc", mv(dest), mv(am)) {
    resultInt();
  }
};

// Unary (int)
class InstLen : public OperableInstruction<InstLen> {
public:
  InstLen(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("len", mv(dest), mv(am)) {
    resultInt();
  }
};

// Unary (string)
class InstChr : public OperableInstruction<InstChr> {
public:
  InstChr(up<AddressMode> dest, up<AddressMode> am)
      : OperableInstruction("chr", mv(dest), mv(am)) {
    resultStr();
  }
};

class InstInkey : public OperableInstruction<InstInkey> {
public:
  explicit InstInkey(up<AddressMode> dest)
      : OperableInstruction("inkey", mv(dest)) {
    resultStr();
  }
};

// Inherent (int)
class InstMem : public OperableInstruction<InstMem> {
public:
  explicit InstMem(up<AddressMode> dest)
      : OperableInstruction("mem", mv(dest)) {
    resultInt();
  }
};

class InstPos : public OperableInstruction<InstPos> {
public:
  explicit InstPos(up<AddressMode> dest)
      : OperableInstruction("pos", mv(dest)) {
    resultInt();
  }
};

class InstTimer : public OperableInstruction<InstTimer> {
public:
  explicit InstTimer(up<AddressMode> dest)
      : OperableInstruction("timer", mv(dest)) {
    resultInt();
  }
};

// Binary (promote float)
class InstAdd : public OperableInstruction<InstAdd> {
public:
  InstAdd(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("add", mv(dest), mv(am1), mv(am2)) {
    resultPromoteFlt();
  }
};

class InstSub : public OperableInstruction<InstSub> {
public:
  InstSub(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("sub", mv(dest), mv(am1), mv(am2)) {
    resultPromoteFlt();
  }
};

class InstRSub : public OperableInstruction<InstRSub> {
public:
  InstRSub(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("rsub", mv(dest), mv(am1), mv(am2)) {
    resultPromoteFlt();
  }
};

class InstMul : public OperableInstruction<InstMul> {
public:
  InstMul(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("mul", mv(dest), mv(am1), mv(am2)) {
    resultPromoteFlt();
  }
};

class InstPow : public OperableInstruction<InstPow> {
public:
  InstPow(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("pow", mv(dest), mv(am1), mv(am2)) {
    resultPow();
  }
};

// Binary (float)

class InstDiv : public OperableInstruction<InstDiv> {
public:
  InstDiv(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("div", mv(dest), mv(am1), mv(am2)) {
    resultFlt();
  }
};

class InstIDiv : public OperableInstruction<InstIDiv> {
public:
  InstIDiv(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("idiv", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

class InstIDiv5S : public OperableInstruction<InstIDiv5S> {
public:
  InstIDiv5S(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("idiv5s", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

// Unary (int)
class InstIDiv3 : public OperableInstruction<InstIDiv3> {
public:
  InstIDiv3(up<AddressMode> dest, up<AddressMode> am1)
      : OperableInstruction("idiv3", mv(dest), mv(am1)) {
    resultInt();
  }
};

class InstIDiv5 : public OperableInstruction<InstIDiv5> {
public:
  InstIDiv5(up<AddressMode> dest, up<AddressMode> am1)
      : OperableInstruction("idiv5", mv(dest), mv(am1)) {
    resultInt();
  }
};

// Binary compare (integer)

class InstLdEq : public OperableInstruction<InstLdEq> {
public:
  InstLdEq(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("ldeq", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

class InstLdNe : public OperableInstruction<InstLdNe> {
public:
  InstLdNe(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("ldne", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

class InstLdLt : public OperableInstruction<InstLdLt> {
public:
  InstLdLt(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("ldlt", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

class InstLdGe : public OperableInstruction<InstLdGe> {
public:
  InstLdGe(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("ldge", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

// Binary bit (integer)

class InstAnd : public OperableInstruction<InstAnd> {
public:
  InstAnd(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("and", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

class InstOr : public OperableInstruction<InstOr> {
public:
  InstOr(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("or", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

// Binary (integer)

class InstPoint : public OperableInstruction<InstPoint> {
public:
  InstPoint(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("point", mv(dest), mv(am1), mv(am2)) {
    resultInt();
  }
};

// Unary init (string)

class InstStrInit : public OperableInstruction<InstStrInit> {
public:
  InstStrInit(up<AddressMode> dest, up<AddressMode> am1)
      : OperableInstruction("strinit", mv(dest), mv(am1)) {
    resultStr();
  }
};

// Binary cat (string)

class InstStrCat : public OperableInstruction<InstStrCat> {
public:
  InstStrCat(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("strcat", mv(dest), mv(am1), mv(am2)) {
    resultStr();
  }
};

// Binary (string)

class InstLeft : public OperableInstruction<InstLeft> {
public:
  InstLeft(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("left", mv(dest), mv(am1), mv(am2)) {
    resultStr();
  }
};

class InstRight : public OperableInstruction<InstRight> {
public:
  InstRight(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("right", mv(dest), mv(am1), mv(am2)) {
    resultStr();
  }
};

class InstMid : public OperableInstruction<InstMid> {
public:
  InstMid(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("mid", mv(dest), mv(am1), mv(am2)) {
    resultStr();
  }
};

// Ternary
class InstMidT : public OperableInstruction<InstMidT> {
public:
  InstMidT(up<AddressMode> dest, up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("midT", mv(dest), mv(am1), mv(am2)) {
    resultStr();
  }
};

// print calls (void)

class InstPrTab : public OperableInstruction<InstPrTab> {
public:
  explicit InstPrTab(up<AddressMode> am)
      : OperableInstruction("prtab", mv(am)) {}
};

class InstPrComma : public OperableInstruction<InstPrComma> {
public:
  InstPrComma() : OperableInstruction("prcomma") {}
};

class InstPrSpace : public OperableInstruction<InstPrSpace> {
public:
  InstPrSpace() : OperableInstruction("prspace") {}
};

class InstPrCR : public OperableInstruction<InstPrCR> {
public:
  InstPrCR() : OperableInstruction("prcr") {}
};

class InstPrAt : public OperableInstruction<InstPrAt> {
public:
  explicit InstPrAt(up<AddressMode> am) : OperableInstruction("prat", mv(am)) {}
};

class InstPr : public OperableInstruction<InstPr> {
public:
  explicit InstPr(up<AddressMode> am) : OperableInstruction("pr", mv(am)) {}
};

class InstFor : public OperableInstruction<InstFor> {
public:
  InstFor(up<AddressMode> iter, up<AddressMode> start)
      : OperableInstruction("for", mv(iter), mv(start)) {
    resultPtr();
  }
};

class InstForOne : public OperableInstruction<InstForOne> {
public:
  explicit InstForOne(up<AddressMode> iter)
      : OperableInstruction("forone", mv(iter)) {
    resultPtr();
  }
};

class InstForTrue : public OperableInstruction<InstForTrue> {
public:
  explicit InstForTrue(up<AddressMode> iter)
      : OperableInstruction("fortrue", mv(iter)) {
    resultPtr();
  }
};

class InstForClr : public OperableInstruction<InstForClr> {
public:
  explicit InstForClr(up<AddressMode> iter)
      : OperableInstruction("forclr", mv(iter)) {
    resultPtr();
  }
};

class InstTo : public OperableInstruction<InstTo> {
public:
  InstTo(up<AddressMode> iterptr, up<AddressMode> to, bool g)
      : OperableInstruction("to", mv(iterptr), mv(to)), generateLines(g) {
    resultArg1();
  }
  bool generateLines;
};

class InstStep : public OperableInstruction<InstStep> {
public:
  InstStep(up<AddressMode> iterptr, up<AddressMode> step)
      : OperableInstruction("step", mv(iterptr), mv(step)) {}
};

class InstNext : public OperableInstruction<InstNext> {
public:
  explicit InstNext(bool g) : OperableInstruction("next"), generateLines(g) {}
  bool generateLines;
};

class InstNextVar : public OperableInstruction<InstNextVar> {
public:
  InstNextVar(up<AddressMode> am, bool g)
      : OperableInstruction("nextvar", mv(am)), generateLines(g) {}
  bool generateLines;
};

class InstGoTo : public OperableInstruction<InstGoTo> {
public:
  explicit InstGoTo(up<AddressMode> am) : OperableInstruction("goto", mv(am)) {}
};

class InstGoSub : public OperableInstruction<InstGoSub> {
public:
  InstGoSub(up<AddressMode> am, bool g)
      : OperableInstruction("gosub", mv(am)), generateLines(g) {}
  bool generateLines;
};

class InstOnGoTo : public OperableInstruction<InstOnGoTo> {
public:
  InstOnGoTo(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("ongoto", mv(am1), mv(am2)) {}
};

class InstOnGoSub : public OperableInstruction<InstOnGoSub> {
public:
  InstOnGoSub(up<AddressMode> am1, up<AddressMode> am2, bool g)
      : OperableInstruction("ongosub", mv(am1), mv(am2)), generateLines(g) {}
  bool generateLines;
};

class InstJsrIfEqual : public OperableInstruction<InstJsrIfEqual> {
public:
  InstJsrIfEqual(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("jsreq", mv(am1), mv(am2)) {}
};

class InstJsrIfNotEqual : public OperableInstruction<InstJsrIfNotEqual> {
public:
  InstJsrIfNotEqual(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("jsrne", mv(am1), mv(am2)) {}
};

class InstJmpIfEqual : public OperableInstruction<InstJmpIfEqual> {
public:
  InstJmpIfEqual(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("jmpeq", mv(am1), mv(am2)) {}
};

class InstJmpIfNotEqual : public OperableInstruction<InstJmpIfNotEqual> {
public:
  InstJmpIfNotEqual(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("jmpne", mv(am1), mv(am2)) {}
};

class InstInputBuf : public OperableInstruction<InstInputBuf> {
public:
  InstInputBuf() : OperableInstruction("input") {}
};

class InstReadBuf : public OperableInstruction<InstReadBuf> {
public:
  explicit InstReadBuf(up<AddressMode> am)
      : OperableInstruction("readbuf", mv(am)) {}
};

class InstIgnoreExtra : public OperableInstruction<InstIgnoreExtra> {
public:
  InstIgnoreExtra() : OperableInstruction("ignxtra") {}
};

class InstRead : public OperableInstruction<InstRead> {
public:
  explicit InstRead(up<AddressMode> am) : OperableInstruction("read", mv(am)) {}
  bool pureUnsigned{false};
  bool pureByte{false};
  bool pureWord{false};
  bool pureNumeric{false};
};

class InstRestore : public OperableInstruction<InstRestore> {
public:
  InstRestore() : OperableInstruction("restore") {}
};

class InstReturn : public OperableInstruction<InstReturn> {
public:
  explicit InstReturn(bool g)
      : OperableInstruction("return"), generateLines(g) {}
  bool generateLines;
};

class InstClear : public OperableInstruction<InstClear> {
public:
  InstClear() : OperableInstruction("clear") {}
};

class InstCls : public OperableInstruction<InstCls> {
public:
  InstCls() : OperableInstruction("cls") {}
};

class InstClsN : public OperableInstruction<InstClsN> {
public:
  explicit InstClsN(up<AddressMode> am) : OperableInstruction("clsn", mv(am)) {}
};

class InstSet : public OperableInstruction<InstSet> {
public:
  InstSet(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("set", mv(am1), mv(am2)) {}
};

class InstSetC : public OperableInstruction<InstSetC> {
public:
  InstSetC(up<AddressMode> am1, up<AddressMode> am2, up<AddressMode> am3)
      : OperableInstruction("setc", mv(am1), mv(am2), mv(am3)) {}
};

class InstReset : public OperableInstruction<InstReset> {
public:
  InstReset(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("reset", mv(am1), mv(am2)) {}
};

class InstStop : public OperableInstruction<InstStop> {
public:
  InstStop() : OperableInstruction("stop") {}
};

class InstPoke : public OperableInstruction<InstPoke> {
public:
  InstPoke(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("poke", mv(am1), mv(am2)) {}
};

class InstSound : public OperableInstruction<InstSound> {
public:
  InstSound(up<AddressMode> am1, up<AddressMode> am2)
      : OperableInstruction("sound", mv(am1), mv(am2)) {}
};

class InstExec : public OperableInstruction<InstExec> {
public:
  explicit InstExec(up<AddressMode> am)
      : OperableInstruction("execn", mv(am)) {}
};

class InstError : public OperableInstruction<InstError> {
public:
  explicit InstError(up<AddressMode> am)
      : OperableInstruction("error", mv(am)) {}
};

class InstBegin : public OperableInstruction<InstBegin> {
public:
  InstBegin() : OperableInstruction("progbegin") {}
};

class InstEnd : public OperableInstruction<InstEnd> {
public:
  InstEnd() : OperableInstruction("progend") {}
};
#endif
