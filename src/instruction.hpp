// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef INSTRUCTION_HPP
#define INSTRUCTION_HPP

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
class InstAdd;
class InstSub;
class InstMul;
class InstDiv;
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
  virtual std::string operate(InstAdd &inst) = 0;
  virtual std::string operate(InstSub &inst) = 0;
  virtual std::string operate(InstMul &inst) = 0;
  virtual std::string operate(InstDiv &inst) = 0;
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

class InstComment : public Instruction {
public:
  explicit InstComment(std::string const &c) : Instruction("") { comment = c; }

  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLabel : public Instruction {
public:
  InstLabel(std::unique_ptr<AddressMode> lineNum, bool g)
      : Instruction(g ? "label" : "", std::move(lineNum)), generateLines(g) {
    labelArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool generateLines;
};

class InstArrayDim1 : public Instruction {
public:
  InstArrayDim1(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrdim1", std::move(firstArg), std::move(arraySymbol)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstArrayRef1 : public Instruction {
public:
  InstArrayRef1(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrref1", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayVal1 : public Instruction {
public:
  InstArrayVal1(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrval1", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayDim2 : public Instruction {
public:
  InstArrayDim2(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrdim2", std::move(firstArg), std::move(arraySymbol)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstArrayRef2 : public Instruction {
public:
  InstArrayRef2(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrref2", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayVal2 : public Instruction {
public:
  InstArrayVal2(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrval2", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayDim3 : public Instruction {
public:
  InstArrayDim3(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrdim3", std::move(firstArg), std::move(arraySymbol)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstArrayRef3 : public Instruction {
public:
  InstArrayRef3(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrref3", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayVal3 : public Instruction {
public:
  InstArrayVal3(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrval3", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayDim4 : public Instruction {
public:
  InstArrayDim4(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrdim4", std::move(firstArg), std::move(arraySymbol)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstArrayRef4 : public Instruction {
public:
  InstArrayRef4(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrref4", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayVal4 : public Instruction {
public:
  InstArrayVal4(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrval4", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayDim5 : public Instruction {
public:
  InstArrayDim5(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrdim5", std::move(firstArg), std::move(arraySymbol)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstArrayRef5 : public Instruction {
public:
  InstArrayRef5(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrref5", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayVal5 : public Instruction {
public:
  InstArrayVal5(std::unique_ptr<AddressMode> firstArg,
                std::unique_ptr<AddressMode> arraySymbol)
      : Instruction("arrval5", std::move(firstArg), std::move(arraySymbol)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayDim : public Instruction {
public:
  InstArrayDim(std::unique_ptr<AddressMode> firstArg,
               std::unique_ptr<AddressMode> arraySymbol,
               std::unique_ptr<AddressModeImm> argCount)
      : Instruction("arrdim", std::move(firstArg), std::move(arraySymbol),
                    std::move(argCount)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstArrayRef : public Instruction {
public:
  InstArrayRef(std::unique_ptr<AddressMode> firstArg,
               std::unique_ptr<AddressMode> arraySymbol,
               std::unique_ptr<AddressModeImm> argCount)
      : Instruction("arrref", std::move(firstArg), std::move(arraySymbol),
                    std::move(argCount)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstArrayVal : public Instruction {
public:
  InstArrayVal(std::unique_ptr<AddressMode> firstArg,
               std::unique_ptr<AddressMode> arraySymbol,
               std::unique_ptr<AddressModeImm> argCount)
      : Instruction("arrval", std::move(firstArg), std::move(arraySymbol),
                    std::move(argCount)) {
    arrayArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  void arrayArg();
};

class InstShift : public Instruction {
public:
  InstShift(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
            std::unique_ptr<AddressMode> am2)
      : Instruction("shift", std::move(dest), std::move(am1), std::move(am2)) {
    resultShift();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (argument)

class InstLd : public Instruction {
public:
  InstLd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("ld", std::move(dest), std::move(am)) {
    resultLet();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstAbs : public Instruction {
public:
  InstAbs(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("abs", std::move(dest), std::move(am)) {
    resultArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstNeg : public Instruction {
public:
  InstNeg(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("neg", std::move(dest), std::move(am)) {
    resultArg();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (integer)

class InstCom : public Instruction {
public:
  InstCom(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("com", std::move(dest), std::move(am)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstSgn : public Instruction {
public:
  InstSgn(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("sgn", std::move(dest), std::move(am)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPeek : public Instruction {
public:
  InstPeek(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("peek", std::move(dest), std::move(am)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (float)

class InstSqr : public Instruction {
public:
  InstSqr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("sqr", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstInv : public Instruction {
public:
  InstInv(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("inv", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLog : public Instruction {
public:
  InstLog(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("log", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstExp : public Instruction {
public:
  InstExp(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("exp", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstSin : public Instruction {
public:
  InstSin(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("sin", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstCos : public Instruction {
public:
  InstCos(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("cos", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstTan : public Instruction {
public:
  InstTan(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("tan", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (float int if arg != 0, implicit int)

class InstIRnd : public Instruction {
public:
  InstIRnd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("irnd", std::move(dest), std::move(am)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstRnd : public Instruction {
public:
  InstRnd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("rnd", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (string)
class InstStr : public Instruction {
public:
  InstStr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("str", std::move(dest), std::move(am)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (float)
class InstVal : public Instruction {
public:
  InstVal(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("val", std::move(dest), std::move(am)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (int)
class InstAsc : public Instruction {
public:
  InstAsc(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("asc", std::move(dest), std::move(am)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (int)
class InstLen : public Instruction {
public:
  InstLen(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("len", std::move(dest), std::move(am)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary (string)
class InstChr : public Instruction {
public:
  InstChr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am)
      : Instruction("chr", std::move(dest), std::move(am)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstInkey : public Instruction {
public:
  explicit InstInkey(std::unique_ptr<AddressMode> dest)
      : Instruction("inkey", std::move(dest)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary (promote float)
class InstAdd : public Instruction {
public:
  InstAdd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : Instruction("add", std::move(dest), std::move(am1), std::move(am2)) {
    resultPromoteFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstSub : public Instruction {
public:
  InstSub(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : Instruction("sub", std::move(dest), std::move(am1), std::move(am2)) {
    resultPromoteFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstMul : public Instruction {
public:
  InstMul(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : Instruction("mul", std::move(dest), std::move(am1), std::move(am2)) {
    resultPromoteFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary (float)

class InstDiv : public Instruction {
public:
  InstDiv(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : Instruction("div", std::move(dest), std::move(am1), std::move(am2)) {
    resultFlt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary compare (integer)

class InstLdEq : public Instruction {
public:
  InstLdEq(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("ldeq", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLdNe : public Instruction {
public:
  InstLdNe(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("ldne", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLdLo : public Instruction {
public:
  InstLdLo(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("ldlo", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLdLt : public Instruction {
public:
  InstLdLt(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("ldlt", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLdHs : public Instruction {
public:
  InstLdHs(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("ldhs", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstLdGe : public Instruction {
public:
  InstLdGe(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("ldge", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary bit (integer)

class InstAnd : public Instruction {
public:
  InstAnd(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : Instruction("and", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstOr : public Instruction {
public:
  InstOr(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
         std::unique_ptr<AddressMode> am2)
      : Instruction("or", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary (integer)

class InstPoint : public Instruction {
public:
  InstPoint(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
            std::unique_ptr<AddressMode> am2)
      : Instruction("point", std::move(dest), std::move(am1), std::move(am2)) {
    resultInt();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Unary init (string)

class InstStrInit : public Instruction {
public:
  InstStrInit(std::unique_ptr<AddressMode> dest,
              std::unique_ptr<AddressMode> am1)
      : Instruction("strinit", std::move(dest), std::move(am1)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary cat (string)

class InstStrCat : public Instruction {
public:
  InstStrCat(std::unique_ptr<AddressMode> dest,
             std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : Instruction("strcat", std::move(dest), std::move(am1), std::move(am2)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Binary (string)

class InstLeft : public Instruction {
public:
  InstLeft(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("left", std::move(dest), std::move(am1), std::move(am2)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstRight : public Instruction {
public:
  InstRight(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
            std::unique_ptr<AddressMode> am2)
      : Instruction("right", std::move(dest), std::move(am1), std::move(am2)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstMid : public Instruction {
public:
  InstMid(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
          std::unique_ptr<AddressMode> am2)
      : Instruction("mid", std::move(dest), std::move(am1), std::move(am2)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// Ternary
class InstMidT : public Instruction {
public:
  InstMidT(std::unique_ptr<AddressMode> dest, std::unique_ptr<AddressMode> am1,
           std::unique_ptr<AddressMode> am2)
      : Instruction("midT", std::move(dest), std::move(am1), std::move(am2)) {
    resultStr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

// print calls (void)

class InstPrTab : public Instruction {
public:
  explicit InstPrTab(std::unique_ptr<AddressMode> am)
      : Instruction("prtab", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPrComma : public Instruction {
public:
  InstPrComma() : Instruction("prtab") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPrSpace : public Instruction {
public:
  InstPrSpace() : Instruction("prspace") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPrCR : public Instruction {
public:
  InstPrCR() : Instruction("prcr") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPrAt : public Instruction {
public:
  explicit InstPrAt(std::unique_ptr<AddressMode> am)
      : Instruction("prat", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPr : public Instruction {
public:
  explicit InstPr(std::unique_ptr<AddressMode> am)
      : Instruction("pr", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstFor : public Instruction {
public:
  InstFor(std::unique_ptr<AddressMode> iter, std::unique_ptr<AddressMode> start)
      : Instruction("for", std::move(iter), std::move(start)) {
    resultPtr();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstTo : public Instruction {
public:
  InstTo(std::unique_ptr<AddressMode> iterptr, std::unique_ptr<AddressMode> to,
         bool g)
      : Instruction("to", std::move(iterptr), std::move(to)), generateLines(g) {
    resultArg1();
  }
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool generateLines;
};

class InstStep : public Instruction {
public:
  InstStep(std::unique_ptr<AddressMode> iterptr,
           std::unique_ptr<AddressMode> step)
      : Instruction("step", std::move(iterptr), std::move(step)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstNext : public Instruction {
public:
  explicit InstNext(bool g) : Instruction("next"), generateLines(g) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool generateLines;
};

class InstNextVar : public Instruction {
public:
  InstNextVar(std::unique_ptr<AddressMode> am, bool g)
      : Instruction("nextvar", std::move(am)), generateLines(g) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool generateLines;
};

class InstGoTo : public Instruction {
public:
  explicit InstGoTo(std::unique_ptr<AddressMode> am)
      : Instruction("goto", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstGoSub : public Instruction {
public:
  InstGoSub(std::unique_ptr<AddressMode> am, bool g)
      : Instruction("gosub", std::move(am)), generateLines(g) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool generateLines;
};

class InstOnGoTo : public Instruction {
public:
  InstOnGoTo(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : Instruction("ongoto", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstOnGoSub : public Instruction {
public:
  InstOnGoSub(std::unique_ptr<AddressMode> am1,
              std::unique_ptr<AddressMode> am2)
      : Instruction("ongosub", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstJsrIfEqual : public Instruction {
public:
  InstJsrIfEqual(std::unique_ptr<AddressMode> am1,
                 std::unique_ptr<AddressMode> am2)
      : Instruction("jsreq", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstJsrIfNotEqual : public Instruction {
public:
  InstJsrIfNotEqual(std::unique_ptr<AddressMode> am1,
                    std::unique_ptr<AddressMode> am2)
      : Instruction("jsrne", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstJmpIfEqual : public Instruction {
public:
  InstJmpIfEqual(std::unique_ptr<AddressMode> am1,
                 std::unique_ptr<AddressMode> am2)
      : Instruction("jmpeq", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstJmpIfNotEqual : public Instruction {
public:
  InstJmpIfNotEqual(std::unique_ptr<AddressMode> am1,
                    std::unique_ptr<AddressMode> am2)
      : Instruction("jmpne", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstInputBuf : public Instruction {
public:
  InstInputBuf() : Instruction("input") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstReadBuf : public Instruction {
public:
  explicit InstReadBuf(std::unique_ptr<AddressMode> am)
      : Instruction("readbuf", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstIgnoreExtra : public Instruction {
public:
  InstIgnoreExtra() : Instruction("ignxtra") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstRead : public Instruction {
public:
  explicit InstRead(std::unique_ptr<AddressMode> am)
      : Instruction("read", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool pureUnsigned{false};
  bool pureByte{false};
  bool pureWord{false};
  bool pureNumeric{false};
};

class InstRestore : public Instruction {
public:
  InstRestore() : Instruction("restore") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstReturn : public Instruction {
public:
  explicit InstReturn(bool g) : Instruction("return"), generateLines(g) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
  bool generateLines;
};

class InstClear : public Instruction {
public:
  InstClear() : Instruction("clear") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstCls : public Instruction {
public:
  InstCls() : Instruction("cls") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstClsN : public Instruction {
public:
  explicit InstClsN(std::unique_ptr<AddressMode> am)
      : Instruction("clsn", std::move(am)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstSet : public Instruction {
public:
  InstSet(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : Instruction("set", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstSetC : public Instruction {
public:
  InstSetC(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2,
           std::unique_ptr<AddressMode> am3)
      : Instruction("setc", std::move(am1), std::move(am2), std::move(am3)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstReset : public Instruction {
public:
  InstReset(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : Instruction("reset", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstStop : public Instruction {
public:
  InstStop() : Instruction("stop") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstPoke : public Instruction {
public:
  InstPoke(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : Instruction("poke", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstSound : public Instruction {
public:
  InstSound(std::unique_ptr<AddressMode> am1, std::unique_ptr<AddressMode> am2)
      : Instruction("sound", std::move(am1), std::move(am2)) {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstBegin : public Instruction {
public:
  InstBegin() : Instruction("progbegin") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};

class InstEnd : public Instruction {
public:
  InstEnd() : Instruction("progend") {}
  std::string operate(InstructionOp *iop) override {
    return iop->operate(*this);
  }
};
#endif
