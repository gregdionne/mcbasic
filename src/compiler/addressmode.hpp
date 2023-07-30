// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPILER_ADDRESSMODE_HPP
#define COMPILER_ADDRESSMODE_HPP

#include "utils/memutils.hpp"
#include <memory>
#include <string>
#include <vector>

#include "datatype.hpp"
#include "mcbasic/constants.hpp"

// Class that governs the various address modes for our Instruction set.
//  TODO: refactor Lin, Lbl, and Stk for line number, label, and labels.
//        disambiguate immediate string constant.

class AddressMode {
public:
  enum class ModeType {
    Inh, // inherent         (no operand)
    Imm, // immediate int    (posByte, negByte, posWord, negWord)
    Lin, // linenumber value (used when creating a line number)
    Lbl, // linenumber label (used when referencing a line number)
    Ext, // extended         (variable, 3+ byte constant, array value)
    Dex, // double-extension (additional extended argument)
    Ind, // indirect         (assignment via letptr)
    Reg, // register         (result in five-byte register)
    Ptr, // memory location  (used in TO and STEP.  implies result on stack)
    Stk, // stack            (trailing labels for ON..GO or string constant)
  };

  AddressMode(ModeType mt, DataType dt) : modeType(mt), dataType(dt) {}
  AddressMode(const AddressMode &) = delete;
  AddressMode(AddressMode &&) = default;
  AddressMode &operator=(const AddressMode &) = delete;
  AddressMode &operator=(AddressMode &&) = default;
  virtual ~AddressMode() = default;
  virtual std::string operation() { return ""; }
  virtual std::string operand() { return ""; }
  virtual std::string label() { return ""; }
  virtual std::string directive() { return ""; }
  virtual std::string doperand() { return ""; }
  virtual std::string sbyte() { return ""; }
  virtual std::string hbyte() { return ""; }
  virtual std::string lbyte() { return ""; }
  virtual std::string lword() { return ""; }
  virtual std::string fract() { return ""; }
  virtual std::string hfrac() { return ""; }
  virtual std::string lfrac() { return ""; }
  virtual std::string postoperation() { return ""; }
  virtual std::string postoperands() { return ""; }
  virtual std::string suffix() { return ""; }
  virtual std::string vsymbol() { return ""; }
  virtual bool isPosByte() { return false; }
  virtual bool isNegByte() { return false; }
  virtual bool isPosWord() { return false; }
  virtual bool isNegWord() { return false; }
  virtual bool isByte() { return false; }
  virtual bool isWord() { return false; }
  virtual int getRegister() { return 0; }
  virtual up<AddressMode> clone() = 0;
  virtual std::string modeStr() = 0;

  bool isInteger() { return dataType == DataType::Int; }
  bool isFloat() { return dataType == DataType::Flt; }
  bool isString() { return dataType == DataType::Str; }

  bool isInherent() { return modeType == ModeType::Inh; }
  bool isImmediate() { return modeType == ModeType::Imm; }
  bool isImmLbl() { return modeType == ModeType::Lbl; }
  bool isImmLin() { return modeType == ModeType::Lin; }
  bool isExtended() { return modeType == ModeType::Ext; }
  bool isDoubleEx() { return modeType == ModeType::Dex; }
  bool isIndirect() { return modeType == ModeType::Ind; }
  bool isRegister() { return modeType == ModeType::Reg; }
  bool isStack() { return modeType == ModeType::Stk; }
  bool isPointer() { return modeType == ModeType::Ptr; }

  bool isImmStr() { return isStack() && isString(); }
  bool isImmLbls() { return isStack() && isInteger(); }

  bool isPtrInt() { return isPointer() && isInteger(); }
  bool isPtrFlt() { return isPointer() && isFloat(); }
  bool isPtrStr() { return isPointer() && isString(); }
  bool isRegInt() { return isRegister() && isInteger(); }
  bool isRegFlt() { return isRegister() && isFloat(); }
  bool isRegStr() { return isRegister() && isString(); }
  bool isExtInt() { return isExtended() && isInteger(); }
  bool isExtFlt() { return isExtended() && isFloat(); }
  bool isExtStr() { return isExtended() && isString(); }
  bool isDexInt() { return isDoubleEx() && isInteger(); }
  bool isDexFlt() { return isDoubleEx() && isFloat(); }
  bool isDexStr() { return isDoubleEx() && isString(); }
  bool isIndInt() { return isIndirect() && isInteger(); }
  bool isIndFlt() { return isIndirect() && isFloat(); }
  bool isIndStr() { return isIndirect() && isString(); }

  bool exists() { return !isInherent(); }
  void castToInt() {
    if (dataType == DataType::Flt) {
      dataType = DataType::Int;
    }
  }
  std::string dataTypeStr() const {
    return dataType == DataType::Int   ? "i"
           : dataType == DataType::Flt ? "f"
           : dataType == DataType::Str ? "s"
                                       : "x";
  }

  ModeType modeType;
  DataType dataType;
};

class AddressModeInh : public AddressMode {
public:
  AddressModeInh() : AddressMode(AddressMode::ModeType::Inh, DataType::Null) {}

  std::string modeStr() override { return "inh"; }
  up<AddressMode> clone() override { return makeup<AddressModeInh>(); }
};

class AddressModeImm : public AddressMode {
public:
  AddressModeImm(bool isNeg_in, int word_in)
      : AddressMode(AddressMode::ModeType::Imm, DataType::Int), isNeg(isNeg_in),
        word(word_in) {}

  std::string modeStr() override { return "imm"; }
  std::string operation() override { return isByte() ? "ldab" : "ldd"; }
  std::string operand() override { return "#" + doperand(); }
  std::string directive() override { return isByte() ? ".byte" : ".word"; }
  std::string doperand() override {
    return std::to_string(word) + (isByte() && word < -128 ? "&$ff"
                                   : word < -32768         ? "&$ffff"
                                                           : "");
  }
  std::string sbyte() override { return isNeg ? "#-1" : "#0"; }
  std::string lword() override { return "#" + doperand(); }
  std::string fract() override { return "#0"; }
  std::string hfrac() override { return "#0"; }
  std::string lfrac() override { return "#0"; }
  std::string suffix() override {
    return std::string(isNeg ? "n" : "p") + (isByte() ? "b" : "w");
  }
  up<AddressMode> clone() override {
    return makeup<AddressModeImm>(isNeg, word);
  }
  bool isByte() override { return -word < 256 && word < 256; }
  bool isWord() override { return !isByte(); }
  bool isPosByte() override { return word < 256 && !isNeg; }
  bool isNegByte() override { return -word < 256 && isNeg; }
  bool isPosWord() override { return !isNeg; }
  bool isNegWord() override { return isNeg; }
private:
  bool isNeg;
  int word;
};

class AddressModeLbl : public AddressMode {
public:
  explicit AddressModeLbl(int ln)
      : AddressMode(AddressMode::ModeType::Lbl, DataType::Int), lineNumber(ln) {
  }

  std::string modeStr() override { return "lbl"; }
  std::string operation() override { return "ldx"; }
  std::string operand() override { return "#" + symbol(); }
  std::string directive() override { return ".word"; }
  std::string doperand() override { return symbol(); }
  std::string sbyte() override { return "0,x"; }
  std::string hbyte() override { return "1,x"; }
  std::string lbyte() override { return "2,x"; }
  std::string lword() override { return "1,x"; }
  std::string suffix() override { return dataTypeStr() + "x"; }
  up<AddressMode> clone() override {
    return makeup<AddressModeLbl>(lineNumber);
  }
  std::string symbol() const {
    return lineNumber == constants::lastLineNumber ? std::string("LLAST")
           : lineNumber == constants::unlistedLineNumber
               ? std::string("LUNLIST")
               : "LINE_" + std::to_string(lineNumber);
  }
  int lineNumber;
};

class AddressModeLin : public AddressMode {
public:
  explicit AddressModeLin(int ln)
      : AddressMode(AddressMode::ModeType::Lin, DataType::Int), lineNumber(ln) {
  }

  std::string modeStr() override { return "lin"; }
  std::string label() override {
    AddressModeLbl lbl(lineNumber);
    return lbl.doperand();
  }
  std::string operation() override { return "ldx"; }
  std::string operand() override { return "#" + symbol(); }
  std::string directive() override { return ".word"; }
  std::string doperand() override { return symbol(); }
  std::string sbyte() override { return "0,x"; }
  std::string hbyte() override { return "1,x"; }
  std::string lbyte() override { return "2,x"; }
  std::string lword() override { return "1,x"; }
  std::string suffix() override { return dataTypeStr() + "x"; }
  up<AddressMode> clone() override {
    return makeup<AddressModeLin>(lineNumber);
  }
  std::string symbol() const { return std::to_string(lineNumber); }
  int lineNumber;
};

class AddressModeExt : public AddressMode {
public:
  AddressModeExt(DataType dt, std::string symb_in)
      : AddressMode(AddressMode::ModeType::Ext, dt), symbol(mv(symb_in)) {}

  std::string modeStr() override { return "ext"; }
  std::string operation() override { return "ldx"; }
  std::string operand() override { return "#" + symbol; }
  std::string directive() override { return ".byte"; }
  std::string doperand() override { return "bytecode_" + symbol; }
  std::string sbyte() override { return "0,x"; }
  std::string hbyte() override { return "1,x"; }
  std::string lbyte() override { return "2,x"; }
  std::string lword() override { return "1,x"; }
  std::string fract() override {
    return dataType == DataType::Int ? std::string("#0") : "3,x";
  }
  std::string hfrac() override {
    return dataType == DataType::Int ? std::string("#0") : "3,x";
  }
  std::string lfrac() override {
    return dataType == DataType::Int ? std::string("#0") : "4,x";
  }
  std::string suffix() override { return dataTypeStr() + "x"; }
  std::string vsymbol() override { return symbol; }
  up<AddressMode> clone() override {
    return makeup<AddressModeExt>(dataType, symbol);
  }
  std::string symbol;
};

class AddressModeDex : public AddressMode {
public:
  AddressModeDex(DataType dt, std::string symb_in)
      : AddressMode(AddressMode::ModeType::Dex, dt), symbol(mv(symb_in)) {}

  std::string modeStr() override { return "dex"; }
  std::string operation() override { return "ldd"; }
  std::string operand() override { return "#" + symbol; }
  std::string directive() override { return ".byte"; }
  std::string doperand() override { return "bytecode_" + symbol; }
  std::string sbyte() override { return "0,x"; }
  std::string hbyte() override { return "1,x"; }
  std::string lbyte() override { return "2,x"; }
  std::string lword() override { return "1,x"; }
  std::string fract() override {
    return dataType == DataType::Int ? std::string("#0") : "3,x";
  }
  std::string hfrac() override {
    return dataType == DataType::Int ? std::string("#0") : "3,x";
  }
  std::string lfrac() override {
    return dataType == DataType::Int ? std::string("#0") : "4,x";
  }
  std::string suffix() override { return dataTypeStr() + "d"; }
  std::string vsymbol() override { return symbol; }
  up<AddressMode> clone() override {
    return makeup<AddressModeDex>(dataType, symbol);
  }
  std::string symbol;
};

class AddressModeInd : public AddressMode {
public:
  AddressModeInd(DataType dt, std::string symb_in)
      : AddressMode(AddressMode::ModeType::Ind, dt), symbol(mv(symb_in)) {}

  std::string modeStr() override { return "ind"; }
  std::string sbyte() override { return "0,x"; }
  std::string hbyte() override { return "1,x"; }
  std::string lbyte() override { return "2,x"; }
  std::string lword() override { return "1,x"; }
  std::string fract() override {
    return dataType == DataType::Int ? std::string("#0") : "3,x";
  }
  std::string hfrac() override {
    return dataType == DataType::Int ? std::string("#0") : "3,x";
  }
  std::string lfrac() override {
    return dataType == DataType::Int ? std::string("#0") : "4,x";
  }
  std::string suffix() override { return dataTypeStr() + "p"; };
  up<AddressMode> clone() override {
    return makeup<AddressModeInd>(dataType, symbol);
  }
  std::string symbol;
};

class AddressModeReg : public AddressMode {
public:
  AddressModeReg(int regnum, DataType dt)
      : AddressMode(AddressMode::ModeType::Reg, dt), registerNumber(regnum) {}

  std::string modeStr() override { return "reg"; }
  std::string suffix() override {
    return dataTypeStr() + "r" + std::to_string(registerNumber);
  };
  std::string sbyte() override { return "r" + std::to_string(registerNumber); }
  std::string hbyte() override {
    return "r" + std::to_string(registerNumber) + "+1";
  }
  std::string lbyte() override {
    return "r" + std::to_string(registerNumber) + "+2";
  }
  std::string lword() override {
    return "r" + std::to_string(registerNumber) + "+1";
  }
  std::string fract() override {
    return dataType == DataType::Int
               ? std::string("#0")
               : "r" + std::to_string(registerNumber) + "+3";
  }
  std::string hfrac() override {
    return dataType == DataType::Int
               ? std::string("#0")
               : "r" + std::to_string(registerNumber) + "+3";
  }
  std::string lfrac() override {
    return dataType == DataType::Int
               ? std::string("#0")
               : "r" + std::to_string(registerNumber) + "+4";
  }
  up<AddressMode> clone() override {
    return makeup<AddressModeReg>(registerNumber, dataType);
  }
  int getRegister() override { return registerNumber; }

  int registerNumber; // register is a reserved word
};

class AddressModeStk : public AddressMode {
public:
  explicit AddressModeStk(std::vector<int> labels_in)
      : AddressMode(AddressMode::ModeType::Stk, DataType::Int),
        labels(mv(labels_in)) {}

  explicit AddressModeStk(std::string text_in)
      : AddressMode(AddressMode::ModeType::Stk, DataType::Str),
        text(mv(text_in)) {}

  std::string modeStr() override { return "stk"; }

  std::string suffix() override {
    return dataType == DataType::Int ? "is" : "ss";
  }
  std::string postoperation() override {
    return dataType == DataType::Int ? ".byte" : ".text";
  }
  std::string postoperands() override;

  up<AddressMode> clone() override {
    return dataType == DataType::Int ? makeup<AddressModeStk>(labels)
                                     : makeup<AddressModeStk>(text);
  }
  std::vector<int> labels;
  std::string text;
};

class AddressModePtr : public AddressMode {
public:
  AddressModePtr(DataType dt, std::string symb_in)
      : AddressMode(AddressMode::ModeType::Ptr, dt), symbol(mv(symb_in)) {}

  std::string modeStr() override { return "ptr"; }
  std::string suffix() override { return dataTypeStr() + "p"; }
  up<AddressMode> clone() override {
    return makeup<AddressModePtr>(dataType, symbol);
  }
  std::string symbol;
};
#endif
