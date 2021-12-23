// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPILER_INSTRUCTION_HPP
#define COMPILER_INSTRUCTION_HPP

#include <set>
#include <utility>

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
class InstAbs;
class InstShift;
class InstNeg;
class InstCom;
class InstSgn;
class InstPeek;
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
class InstAdd;
class InstSub;
class InstMul;
class InstDiv;
class InstIDiv;
class InstIDiv3;
class InstIDiv5;
class InstPow;
class InstLdEq;
class InstLdNe;
class InstLdLo;
class InstLdLt;
class InstLdHs;
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
class InstError;
class InstBegin;
class InstEnd;

class InstructionOp {
public:
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
  virtual std::string operate(InstAbs &inst) = 0;
  virtual std::string operate(InstShift &inst) = 0;
  virtual std::string operate(InstNeg &inst) = 0;
  virtual std::string operate(InstCom &inst) = 0;
  virtual std::string operate(InstSgn &inst) = 0;
  virtual std::string operate(InstPeek &inst) = 0;
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
  virtual std::string operate(InstAdd &inst) = 0;
  virtual std::string operate(InstSub &inst) = 0;
  virtual std::string operate(InstMul &inst) = 0;
  virtual std::string operate(InstDiv &inst) = 0;
  virtual std::string operate(InstIDiv &inst) = 0;
  virtual std::string operate(InstIDiv3 &inst) = 0;
  virtual std::string operate(InstIDiv5 &inst) = 0;
  virtual std::string operate(InstPow &inst) = 0;
  virtual std::string operate(InstLdEq &inst) = 0;
  virtual std::string operate(InstLdNe &inst) = 0;
  virtual std::string operate(InstLdLo &inst) = 0;
  virtual std::string operate(InstLdLt &inst) = 0;
  virtual std::string operate(InstLdHs &inst) = 0;
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
  virtual std::string operate(InstError &inst) = 0;
  virtual std::string operate(InstBegin &inst) = 0;
  virtual std::string operate(InstEnd &inst) = 0;
};

class Instruction {
public:
  explicit Instruction(std::string mnem)
      : mnemonic(std::move(mnem)), arg1(std::make_unique<AddressModeInh>()),
        arg2(std::make_unique<AddressModeInh>()),
        arg3(std::make_unique<AddressModeInh>()),
        result(std::make_unique<AddressModeInh>()) {}
  Instruction(std::string mnem, std::unique_ptr<AddressMode> arg1_in)
      : mnemonic(std::move(mnem)), arg1(std::move(arg1_in)),
        arg2(std::make_unique<AddressModeInh>()),
        arg3(std::make_unique<AddressModeInh>()),
        result(std::make_unique<AddressModeInh>()) {}
  Instruction(std::string mnem, std::unique_ptr<AddressMode> arg1_in,
              std::unique_ptr<AddressMode> arg2_in)
      : mnemonic(std::move(mnem)), arg1(std::move(arg1_in)),
        arg2(std::move(arg2_in)), arg3(std::make_unique<AddressModeInh>()),
        result(std::make_unique<AddressModeInh>()) {}
  Instruction(std::string mnem, std::unique_ptr<AddressMode> arg1_in,
              std::unique_ptr<AddressMode> arg2_in,
              std::unique_ptr<AddressMode> arg3_in)
      : mnemonic(std::move(mnem)), arg1(std::move(arg1_in)),
        arg2(std::move(arg2_in)), arg3(std::move(arg3_in)),
        result(std::make_unique<AddressModeInh>()) {}

  Instruction() = delete;
  Instruction(const Instruction &) = delete;
  Instruction(Instruction &&) = delete;
  Instruction &operator=(const Instruction &) = delete;
  Instruction &operator=(Instruction &&) = delete;
  virtual ~Instruction() = default;

  virtual std::string operate(InstructionOp * /*inst*/) {
    return "\t!unimplemented\n";
  }

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
  std::unique_ptr<AddressMode> arg1;
  std::unique_ptr<AddressMode> arg2;
  std::unique_ptr<AddressMode> arg3;
  std::unique_ptr<AddressMode> result;
  std::set<std::string> dependencies;
};

template <typename T> class OperableInstruction : public Instruction {
public:
  explicit OperableInstruction(std::string mnem)
      : Instruction(std::move(mnem)) {}

  OperableInstruction(std::string mnem, std::unique_ptr<AddressMode> arg1_in)
      : Instruction(std::move(mnem), std::move(arg1_in)) {}

  OperableInstruction(std::string mnem, std::unique_ptr<AddressMode> arg1_in,
                      std::unique_ptr<AddressMode> arg2_in)
      : Instruction(std::move(mnem), std::move(arg1_in), std::move(arg2_in)) {}

  OperableInstruction(std::string mnem, std::unique_ptr<AddressMode> arg1_in,
                      std::unique_ptr<AddressMode> arg2_in,
                      std::unique_ptr<AddressMode> arg3_in)
      : Instruction(std::move(mnem), std::move(arg1_in), std::move(arg2_in),
                    std::move(arg3_in)) {}

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
  InstLabel(std::unique_ptr<AddressMode> lineNum, bool g)
      : OperableInstruction(g ? "label" : "", std::move(lineNum)),
        generateLines(g) {
    labelArg();
  }
  bool generateLines;
};

class InstArrayDim1 : public OperableInstruction<InstArrayDim1> {
public:
  InstArrayDim1(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrdim1", std::move(firstArg),
                            std::move(arraySymbol)) {}
};

class InstArrayRef1 : public OperableInstruction<InstArrayRef1> {
public:
  InstArrayRef1(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrref1", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal1 : public OperableInstruction<InstArrayVal1> {
public:
  InstArrayVal1(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrval1", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim2 : public OperableInstruction<InstArrayDim2> {
public:
  InstArrayDim2(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrdim2", std::move(firstArg),
                            std::move(arraySymbol)) {}
};

class InstArrayRef2 : public OperableInstruction<InstArrayRef2> {
public:
  InstArrayRef2(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrref2", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal2 : public OperableInstruction<InstArrayVal2> {
public:
  InstArrayVal2(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrval2", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim3 : public OperableInstruction<InstArrayDim3> {
public:
  InstArrayDim3(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrdim3", std::move(firstArg),
                            std::move(arraySymbol)) {}
};

class InstArrayRef3 : public OperableInstruction<InstArrayRef3> {
public:
  InstArrayRef3(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrref3", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal3 : public OperableInstruction<InstArrayVal3> {
public:
  InstArrayVal3(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrval3", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim4 : public OperableInstruction<InstArrayDim4> {
public:
  InstArrayDim4(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrdim4", std::move(firstArg),
                            std::move(arraySymbol)) {}
};

class InstArrayRef4 : public OperableInstruction<InstArrayRef4> {
public:
  InstArrayRef4(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrref4", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal4 : public OperableInstruction<InstArrayVal4> {
public:
  InstArrayVal4(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrval4", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim5 : public OperableInstruction<InstArrayDim5> {
public:
  InstArrayDim5(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrdim5", std::move(firstArg),
                            std::move(arraySymbol)) {}
};

class InstArrayRef5 : public OperableInstruction<InstArrayRef5> {
public:
  InstArrayRef5(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrref5", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal5 : public OperableInstruction<InstArrayVal5> {
public:
  InstArrayVal5(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : OperableInstruction("arrval5", std::move(firstArg),
                            std::move(arraySymbol)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayDim : public OperableInstruction<InstArrayDim> {
public:
  InstArrayDim(std::unique_ptr<AddressMode> firstArg,
               std::unique_ptr<AddressMode> arraySymbol,
               std::unique_ptr<AddressModeImm> argCount)
      : OperableInstruction("arrdim", std::move(firstArg),
                            std::move(arraySymbol), std::move(argCount)) {}
};

class InstArrayRef : public OperableInstruction<InstArrayRef> {
public:
  InstArrayRef(std::unique_ptr<AddressMode> firstArg,
               std::unique_ptr<AddressMode> arraySymbol,
               std::unique_ptr<AddressModeImm> argCount)
      : OperableInstruction("arrref", std::move(firstArg),
                            std::move(arraySymbol), std::move(argCount)) {
    arrayArg();
  }
  void arrayArg();
};

class InstArrayVal : public OperableInstruction<InstArrayVal> {
public:
  InstArrayVal(std::unique_ptr<AddressMode> firstArg,
               std::unique_ptr<AddressMode> arraySymbol,
               std::unique_ptr<AddressModeImm> argCount)
      : OperableInstruction("arrval", std::move(firstArg),
                            std::move(arraySymbol), std::move(argCount)) {
    arrayArg();
  }
  void arrayArg();
};

class InstShift : public OperableInstruction<InstShift> {
public:
  InstShift(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
            std::unique_ptr<AddressMode> am2)
      : OperableInstruction("shift", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultShift();
  }
};

// Unary (argument)

class InstLd : public OperableInstruction<InstLd> {
public:
  InstLd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("ld", std::move(dest), std::move(am)) {
    resultLet();
  }
};

class InstAbs : public OperableInstruction<InstAbs> {
public:
  InstAbs(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("abs", std::move(dest), std::move(am)) {
    resultArg();
  }
};

class InstNeg : public OperableInstruction<InstNeg> {
public:
  InstNeg(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("neg", std::move(dest), std::move(am)) {
    resultArg();
  }
};

// Unary (integer)

class InstCom : public OperableInstruction<InstCom> {
public:
  InstCom(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("com", std::move(dest), std::move(am)) {
    resultInt();
  }
};

class InstSgn : public OperableInstruction<InstSgn> {
public:
  InstSgn(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("sgn", std::move(dest), std::move(am)) {
    resultInt();
  }
};

class InstPeek : public OperableInstruction<InstPeek> {
public:
  InstPeek(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("peek", std::move(dest), std::move(am)) {
    resultInt();
  }
};

// Unary (float)

class InstSqr : public OperableInstruction<InstSqr> {
public:
  InstSqr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("sqr", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

class InstInv : public OperableInstruction<InstInv> {
public:
  InstInv(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("inv", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

class InstLog : public OperableInstruction<InstLog> {
public:
  InstLog(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("log", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

class InstExp : public OperableInstruction<InstExp> {
public:
  InstExp(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("exp", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

class InstSin : public OperableInstruction<InstSin> {
public:
  InstSin(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("sin", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

class InstCos : public OperableInstruction<InstCos> {
public:
  InstCos(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("cos", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

class InstTan : public OperableInstruction<InstTan> {
public:
  InstTan(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("tan", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

// Unary (float int if arg != 0, implicit int)

class InstIRnd : public OperableInstruction<InstIRnd> {
public:
  InstIRnd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("irnd", std::move(dest), std::move(am)) {
    resultInt();
  }
};

class InstRnd : public OperableInstruction<InstRnd> {
public:
  InstRnd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("rnd", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

// Unary (string)
class InstStr : public OperableInstruction<InstStr> {
public:
  InstStr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("str", std::move(dest), std::move(am)) {
    resultStr();
  }
};

// Unary (float)
class InstVal : public OperableInstruction<InstVal> {
public:
  InstVal(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("val", std::move(dest), std::move(am)) {
    resultFlt();
  }
};

// Unary (int)
class InstAsc : public OperableInstruction<InstAsc> {
public:
  InstAsc(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("asc", std::move(dest), std::move(am)) {
    resultInt();
  }
};

// Unary (int)
class InstLen : public OperableInstruction<InstLen> {
public:
  InstLen(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("len", std::move(dest), std::move(am)) {
    resultInt();
  }
};

// Unary (string)
class InstChr : public OperableInstruction<InstChr> {
public:
  InstChr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : OperableInstruction("chr", std::move(dest), std::move(am)) {
    resultStr();
  }
};

class InstInkey : public OperableInstruction<InstInkey> {
public:
  explicit InstInkey(std::unique_ptr<AddressMode> dest)
      : OperableInstruction("inkey", std::move(dest)) {
    resultStr();
  }
};

class InstMem : public OperableInstruction<InstMem> {
public:
  explicit InstMem(std::unique_ptr<AddressMode> dest)
      : OperableInstruction("mem", std::move(dest)) {
    resultInt();
  }
};

// Binary (promote float)
class InstAdd : public OperableInstruction<InstAdd> {
public:
  InstAdd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("add", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultPromoteFlt();
  }
};

class InstSub : public OperableInstruction<InstSub> {
public:
  InstSub(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("sub", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultPromoteFlt();
  }
};

class InstMul : public OperableInstruction<InstMul> {
public:
  InstMul(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("mul", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultPromoteFlt();
  }
};

class InstPow : public OperableInstruction<InstPow> {
public:
  InstPow(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("pow", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultPow();
  }
};

// Binary (float)

class InstDiv : public OperableInstruction<InstDiv> {
public:
  InstDiv(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("div", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultFlt();
  }
};

class InstIDiv : public OperableInstruction<InstIDiv> {
public:
  InstIDiv(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("idiv", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

// Unary (int)
class InstIDiv3 : public OperableInstruction<InstIDiv3> {
public:
  InstIDiv3(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1)
      : OperableInstruction("idiv3", std::move(dest), std::move(am1)) {
    resultInt();
  }
};

class InstIDiv5 : public OperableInstruction<InstIDiv5> {
public:
  InstIDiv5(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1)
      : OperableInstruction("idiv5", std::move(dest), std::move(am1)) {
    resultInt();
  }
};

// Binary compare (integer)

class InstLdEq : public OperableInstruction<InstLdEq> {
public:
  InstLdEq(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ldeq", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

class InstLdNe : public OperableInstruction<InstLdNe> {
public:
  InstLdNe(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ldne", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

class InstLdLo : public OperableInstruction<InstLdLo> {
public:
  InstLdLo(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ldlo", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

class InstLdLt : public OperableInstruction<InstLdLt> {
public:
  InstLdLt(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ldlt", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

class InstLdHs : public OperableInstruction<InstLdHs> {
public:
  InstLdHs(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ldhs", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

class InstLdGe : public OperableInstruction<InstLdGe> {
public:
  InstLdGe(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ldge", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

// Binary bit (integer)

class InstAnd : public OperableInstruction<InstAnd> {
public:
  InstAnd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("and", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

class InstOr : public OperableInstruction<InstOr> {
public:
  InstOr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
         std::unique_ptr<AddressMode> am2)
      : OperableInstruction("or", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

// Binary (integer)

class InstPoint : public OperableInstruction<InstPoint> {
public:
  InstPoint(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
            std::unique_ptr<AddressMode> am2)
      : OperableInstruction("point", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultInt();
  }
};

// Unary init (string)

class InstStrInit : public OperableInstruction<InstStrInit> {
public:
  InstStrInit(std::unique_ptr<AddressMode> dest,
              std::unique_ptr<AddressMode> am1)
      : OperableInstruction("strinit", std::move(dest), std::move(am1)) {
    resultStr();
  }
};

// Binary cat (string)

class InstStrCat : public OperableInstruction<InstStrCat> {
public:
  InstStrCat(std::unique_ptr<AddressMode> dest,
             std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : OperableInstruction("strcat", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultStr();
  }
};

// Binary (string)

class InstLeft : public OperableInstruction<InstLeft> {
public:
  InstLeft(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("left", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultStr();
  }
};

class InstRight : public OperableInstruction<InstRight> {
public:
  InstRight(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
            std::unique_ptr<AddressMode> am2)
      : OperableInstruction("right", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultStr();
  }
};

class InstMid : public OperableInstruction<InstMid> {
public:
  InstMid(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : OperableInstruction("mid", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultStr();
  }
};

// Ternary
class InstMidT : public OperableInstruction<InstMidT> {
public:
  InstMidT(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : OperableInstruction("midT", std::move(dest), std::move(am1),
                            std::move(am2)) {
    resultStr();
  }
};

// print calls (void)

class InstPrTab : public OperableInstruction<InstPrTab> {
public:
  explicit InstPrTab(std::unique_ptr<AddressMode> am)
      : OperableInstruction("prtab", std::move(am)) {}
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
  explicit InstPrAt(std::unique_ptr<AddressMode> am)
      : OperableInstruction("prat", std::move(am)) {}
};

class InstPr : public OperableInstruction<InstPr> {
public:
  explicit InstPr(std::unique_ptr<AddressMode> am)
      : OperableInstruction("pr", std::move(am)) {}
};

class InstFor : public OperableInstruction<InstFor> {
public:
  InstFor(std::unique_ptr<AddressMode> iter, std::unique_ptr<AddressMode> start)
      : OperableInstruction("for", std::move(iter), std::move(start)) {
    resultPtr();
  }
};

class InstTo : public OperableInstruction<InstTo> {
public:
  InstTo(std::unique_ptr<AddressMode> iterptr, std::unique_ptr<AddressMode> to,
         bool g)
      : OperableInstruction("to", std::move(iterptr), std::move(to)),
        generateLines(g) {
    resultArg1();
  }
  bool generateLines;
};

class InstStep : public OperableInstruction<InstStep> {
public:
  InstStep(std::unique_ptr<AddressMode> iterptr,
           std::unique_ptr<AddressMode> step)
      : OperableInstruction("step", std::move(iterptr), std::move(step)) {}
};

class InstNext : public OperableInstruction<InstNext> {
public:
  explicit InstNext(bool g) : OperableInstruction("next"), generateLines(g) {}
  bool generateLines;
};

class InstNextVar : public OperableInstruction<InstNextVar> {
public:
  InstNextVar(std::unique_ptr<AddressMode> am, bool g)
      : OperableInstruction("nextvar", std::move(am)), generateLines(g) {}
  bool generateLines;
};

class InstGoTo : public OperableInstruction<InstGoTo> {
public:
  explicit InstGoTo(std::unique_ptr<AddressMode> am)
      : OperableInstruction("goto", std::move(am)) {}
};

class InstGoSub : public OperableInstruction<InstGoSub> {
public:
  InstGoSub(std::unique_ptr<AddressMode> am, bool g)
      : OperableInstruction("gosub", std::move(am)), generateLines(g) {}
  bool generateLines;
};

class InstOnGoTo : public OperableInstruction<InstOnGoTo> {
public:
  InstOnGoTo(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : OperableInstruction("ongoto", std::move(am1), std::move(am2)) {}
};

class InstOnGoSub : public OperableInstruction<InstOnGoSub> {
public:
  InstOnGoSub(std::unique_ptr<AddressMode> am1,
              std::unique_ptr<AddressMode> am2, bool g)
      : OperableInstruction("ongosub", std::move(am1), std::move(am2)),
        generateLines(g) {}
  bool generateLines;
};

class InstJsrIfEqual : public OperableInstruction<InstJsrIfEqual> {
public:
  InstJsrIfEqual(std::unique_ptr<AddressMode> am1,
                 std::unique_ptr<AddressMode> am2)
      : OperableInstruction("jsreq", std::move(am1), std::move(am2)) {}
};

class InstJsrIfNotEqual : public OperableInstruction<InstJsrIfNotEqual> {
public:
  InstJsrIfNotEqual(std::unique_ptr<AddressMode> am1,
                    std::unique_ptr<AddressMode> am2)
      : OperableInstruction("jsrne", std::move(am1), std::move(am2)) {}
};

class InstJmpIfEqual : public OperableInstruction<InstJmpIfEqual> {
public:
  InstJmpIfEqual(std::unique_ptr<AddressMode> am1,
                 std::unique_ptr<AddressMode> am2)
      : OperableInstruction("jmpeq", std::move(am1), std::move(am2)) {}
};

class InstJmpIfNotEqual : public OperableInstruction<InstJmpIfNotEqual> {
public:
  InstJmpIfNotEqual(std::unique_ptr<AddressMode> am1,
                    std::unique_ptr<AddressMode> am2)
      : OperableInstruction("jmpne", std::move(am1), std::move(am2)) {}
};

class InstInputBuf : public OperableInstruction<InstInputBuf> {
public:
  InstInputBuf() : OperableInstruction("input") {}
};

class InstReadBuf : public OperableInstruction<InstReadBuf> {
public:
  explicit InstReadBuf(std::unique_ptr<AddressMode> am)
      : OperableInstruction("readbuf", std::move(am)) {}
};

class InstIgnoreExtra : public OperableInstruction<InstIgnoreExtra> {
public:
  InstIgnoreExtra() : OperableInstruction("ignxtra") {}
};

class InstRead : public OperableInstruction<InstRead> {
public:
  explicit InstRead(std::unique_ptr<AddressMode> am)
      : OperableInstruction("read", std::move(am)) {}
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
  explicit InstClsN(std::unique_ptr<AddressMode> am)
      : OperableInstruction("clsn", std::move(am)) {}
};

class InstSet : public OperableInstruction<InstSet> {
public:
  InstSet(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : OperableInstruction("set", std::move(am1), std::move(am2)) {}
};

class InstSetC : public OperableInstruction<InstSetC> {
public:
  InstSetC(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2,
           std::unique_ptr<AddressMode> am3)
      : OperableInstruction("setc", std::move(am1), std::move(am2),
                            std::move(am3)) {}
};

class InstReset : public OperableInstruction<InstReset> {
public:
  InstReset(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : OperableInstruction("reset", std::move(am1), std::move(am2)) {}
};

class InstStop : public OperableInstruction<InstStop> {
public:
  InstStop() : OperableInstruction("stop") {}
};

class InstPoke : public OperableInstruction<InstPoke> {
public:
  InstPoke(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : OperableInstruction("poke", std::move(am1), std::move(am2)) {}
};

class InstSound : public OperableInstruction<InstSound> {
public:
  InstSound(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : OperableInstruction("sound", std::move(am1), std::move(am2)) {}
};

class InstError : public OperableInstruction<InstError> {
public:
  explicit InstError(std::unique_ptr<AddressMode> am)
      : OperableInstruction("error", std::move(am)) {}
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
