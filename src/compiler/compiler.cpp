// Copyright (C) 2021-2022 Greg Dionne
// Distributed under MIT License
#include "compiler.hpp"
#include "ast/lister.hpp"
#include "optimizer/constinspector.hpp"
#include "optimizer/ischar.hpp"

#include <array>
#include <utility>

template <typename T> static inline std::string list(T &t) {
  StatementLister that;
  that.generatePredicates = false;
  t.soak(&that);
  return that.result;
}

// C++ expects the return values of the ternary (conditional) operator
// to be of the same type.  We use this to simplify conditional object
// construction by casting the result to std::unique_ptr<BaseType>.

template <typename T, typename... Args>
static inline std::unique_ptr<AddressMode> makeAddrMode(Args &&...args) {
  return std::make_unique<T>(std::forward<Args>(args)...);
}

template <typename T, typename... Args>
static inline std::unique_ptr<Instruction> makeInst(Args &&...args) {
  return std::make_unique<T>(std::forward<Args>(args)...);
}

template <typename T, typename... Args>
static inline std::unique_ptr<Instruction> makeInstMove(Args &&...args) {
  return makeInst<T>(std::move<Args>(args)...);
}

// Used to determine if we can use IntDiv5S
static bool is5Smooth(int n) {

  static std::array<int, 3> p{2, 3, 5};

  for (std::size_t i = 0; i < p.size(); ++i) {
    while (n % p[i] == 0) {
      n /= p[i];
    }
  }

  return n == 1;
}

void Compiler::operate(Program &p) {
  queue.append(std::make_unique<InstBegin>());
  queue.append(std::make_unique<InstClear>());
  itCurrentLine = p.lines.begin();

  if (itCurrentLine != p.lines.end()) {
    firstLine = (*itCurrentLine)->lineNumber;
  }

  while (itCurrentLine != p.lines.end()) {
    (*itCurrentLine)->operate(this);
    ++itCurrentLine;
  }
}

void Compiler::operate(Line &l) {
  queue.append(std::make_unique<InstLabel>(
      std::make_unique<AddressModeLin>(l.lineNumber),
      generateLines && l.lineNumber != constants::unlistedLineNumber));

  StatementCompiler that(constTable, symbolTable, dataTable, queue, firstLine,
                         itCurrentLine, generateLines);

  for (auto &statement : l.statements) {
    statement->soak(&that);
  }
}

void StatementCompiler::absorb(const Rem &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
}

void StatementCompiler::absorb(const For &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  // perform LET
  queue.clearRegisters();
  ExprCompiler iter(constTable, symbolTable, queue);
  ExprCompiler from(constTable, symbolTable, queue);

  s.iter->soak(&iter); // iter.result will be extended.
  s.from->soak(&from);

  if (from.result->modeType != AddressMode::ModeType::Imm) {
    from.result = queue.load(std::move(from.result));
  }

  // check to see if we can avoid integer argument to TO if STEP is not
  // specified and FROM is an integer
  bool castToToInt = !s.step && !from.result->isFloat();

  // result (of type ptr) keeps track of int/flt iter argument
  std::unique_ptr<AddressMode> result = queue.append(
      std::make_unique<InstFor>(iter.result->clone(), std::move(from.result)));

  // get TO operand
  queue.clearRegisters();
  ExprCompiler to(constTable, symbolTable, queue);
  s.to->soak(&to);
  if (castToToInt) {
    to.result->castToInt();
  }

  queue.append(std::make_unique<InstTo>(result->clone(), std::move(to.result),
                                        generateLines));

  // get STEP operand (if any)
  if (s.step) {
    queue.clearRegisters();
    ExprCompiler step(constTable, symbolTable, queue);
    s.step->soak(&step);
    step.result = queue.load(std::move(step.result));
    queue.append(
        std::make_unique<InstStep>(std::move(result), std::move(step.result)));
  }
}

void StatementCompiler::absorb(const Go &s) {
  queue.append(std::make_unique<InstComment>(list(s)));

  auto lineNumber = std::make_unique<AddressModeLbl>(s.lineNumber);

  queue.append(s.isSub
                   ? makeInst<InstGoSub>(std::move(lineNumber), generateLines)
                   : makeInst<InstGoTo>(std::move(lineNumber)));
}

void StatementCompiler::absorb(const When &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler cond(constTable, symbolTable, queue);
  s.predicate->soak(&cond);

  auto lineNumber = std::make_unique<AddressModeLbl>(s.lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(std::move(cond.result));
  }

  queue.append(s.isSub ? makeInst<InstJsrIfNotEqual>(std::move(cond.result),
                                                     std::move(lineNumber))
                       : makeInst<InstJmpIfNotEqual>(std::move(cond.result),
                                                     std::move(lineNumber)));
}

void StatementCompiler::absorb(const If &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler cond(constTable, symbolTable, queue);
  s.predicate->soak(&cond);

  auto lineNumber =
      std::make_unique<AddressModeLbl>((*std::next(itCurrentLine))->lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(std::move(cond.result));
  }

  queue.append(std::make_unique<InstJmpIfEqual>(std::move(cond.result),
                                                std::move(lineNumber)));

  for (auto &statement : s.consequent) {
    statement->soak(this);
  }
}

void StatementCompiler::absorb(const Data & /*statement*/) {
  queue.append(std::make_unique<InstComment>("DATA ..."));
}

void StatementCompiler::absorb(const Print &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler value(constTable, symbolTable, queue);
  if (s.at) {
    queue.clearRegisters();
    s.at->soak(&value);
    value.result->castToInt(); // override
    queue.append(std::make_unique<InstPrAt>(std::move(value.result)));
  }
  for (auto &expr : s.printExpr) {
    queue.clearRegisters();
    expr->soak(&value);
    // print if not handled by PrTab or PrComma or PrCR
    if (value.result && value.result->exists()) {
      queue.append(std::make_unique<InstPr>(std::move(value.result)));
    }
  }
}

void StatementCompiler::absorb(const Input &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler value(constTable, symbolTable, queue);

  if (s.prompt) {
    s.prompt->soak(&value);
    queue.append(std::make_unique<InstPr>(std::move(value.result)));
  }

  queue.append(std::make_unique<InstInputBuf>());

  for (auto &variable : s.variables) {
    queue.clearRegisters();
    value.arrayRef = !variable->isVar();
    variable->soak(&value);
    queue.append(std::make_unique<InstReadBuf>(std::move(value.result)));
  }

  queue.append(std::make_unique<InstIgnoreExtra>());
}

void StatementCompiler::absorb(const End &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstEnd>());
}

void StatementCompiler::absorb(const On &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler value(constTable, symbolTable, queue);
  s.branchIndex->soak(&value);
  value.result = queue.load(std::move(value.result));
  value.result->castToInt(); // override
  queue.append(s.isSub ? makeInst<InstOnGoSub>(
                             std::move(value.result),
                             std::make_unique<AddressModeStk>(s.branchTable),
                             generateLines)
                       : makeInst<InstOnGoTo>(
                             std::move(value.result),
                             std::make_unique<AddressModeStk>(s.branchTable)));
}

void StatementCompiler::absorb(const Next &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  if (s.variables.empty()) {
    queue.append(std::make_unique<InstNext>(generateLines));
  } else {
    for (auto &variable : s.variables) {
      queue.clearRegisters();
      ExprCompiler var(constTable, symbolTable, queue);
      variable->soak(&var);
      queue.append(
          std::make_unique<InstNextVar>(std::move(var.result), generateLines));
      queue.append(std::make_unique<InstNext>(generateLines));
    }
  }
}

void StatementCompiler::absorb(const Dim &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  for (auto &variable : s.variables) {
    queue.clearRegisters();
    ExprCompiler var(constTable, symbolTable, queue);
    var.arrayDim = true;
    variable->soak(&var);
  }
}

void StatementCompiler::absorb(const Read &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  for (auto &variable : s.variables) {
    queue.clearRegisters();

    ExprCompiler dest(constTable, symbolTable, queue);

    dest.arrayRef = !variable->isVar();
    variable->soak(&dest); // dest.result will be either indirect or extended.

    auto inst = std::make_unique<InstRead>(std::move(dest.result));
    inst->pureUnsigned = dataTable.pureUnsigned;
    inst->pureByte = dataTable.pureByte;
    inst->pureWord = dataTable.pureWord;
    inst->pureNumeric = dataTable.pureNumeric;
    queue.append(std::move(inst));
  }
}

void StatementCompiler::absorb(const Let &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  queue.clearRegisters();
  s.rhs->soak(&value); // accum

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstLd>(std::move(dest.result),
                                        std::move(value.result)));
}

void StatementCompiler::absorb(const Inc &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  queue.clearRegisters();
  s.rhs->soak(&value); // accum

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstAdd>(
      dest.result->clone(), dest.result->clone(), std::move(value.result)));
}

void StatementCompiler::absorb(const Dec &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  queue.clearRegisters();
  s.rhs->soak(&value); // accum

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstSub>(
      dest.result->clone(), dest.result->clone(), std::move(value.result)));
}

void StatementCompiler::absorb(const Run &s) {
  auto lineNumber = std::make_unique<AddressModeLbl>(
      s.hasLineNumber ? s.lineNumber : firstLine);

  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstClear>());
  queue.append(std::make_unique<InstGoTo>(std::move(lineNumber)));
}

void StatementCompiler::absorb(const Restore &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstRestore>());
}

void StatementCompiler::absorb(const Return &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstReturn>(generateLines));
}

void StatementCompiler::absorb(const Stop &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstStop>());
}

void StatementCompiler::absorb(const Poke &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler dest(constTable, symbolTable, queue);
  s.dest->soak(&dest);
  dest.result->castToInt();

  ExprCompiler value(constTable, symbolTable, queue);
  s.val->soak(&value);
  value.result->castToInt();

  if (value.result->modeType != AddressMode::ModeType::Reg &&
      value.result->modeType == dest.result->modeType) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstPoke>(std::move(dest.result),
                                          std::move(value.result)));
}

void StatementCompiler::absorb(const Clear &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  // arguments are ignored
  queue.append(std::make_unique<InstClear>());
}

void StatementCompiler::absorb(const Set &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler x(constTable, symbolTable, queue);
  ExprCompiler y(constTable, symbolTable, queue);

  s.x->soak(&x);
  x.result->castToInt();
  x.result = queue.load(std::move(x.result));
  s.y->soak(&y);
  y.result->castToInt();
  y.result = queue.load(std::move(y.result));
  if (s.c) {
    ExprCompiler c(constTable, symbolTable, queue);
    s.c->soak(&c);
    c.result->castToInt();
    queue.append(std::make_unique<InstSetC>(
        std::move(x.result), std::move(y.result), std::move(c.result)));
  } else {
    queue.append(
        std::make_unique<InstSet>(std::move(x.result), std::move(y.result)));
  }
}

void StatementCompiler::absorb(const Reset &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler x(constTable, symbolTable, queue);
  ExprCompiler y(constTable, symbolTable, queue);

  s.x->soak(&x);
  x.result->castToInt();
  x.result = queue.load(std::move(x.result));
  s.y->soak(&y);
  y.result->castToInt();

  queue.append(
      std::make_unique<InstReset>(std::move(x.result), std::move(y.result)));
}

void StatementCompiler::absorb(const Cls &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  if (s.color) {
    queue.clearRegisters();
    ExprCompiler color(constTable, symbolTable, queue);
    s.color->soak(&color);
    color.result->castToInt();
    queue.append(std::make_unique<InstClsN>(std::move(color.result)));
  } else {
    queue.append(std::make_unique<InstCls>());
  }
}

void StatementCompiler::absorb(const Sound &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler pitch(constTable, symbolTable, queue);
  s.pitch->soak(&pitch);
  pitch.result->castToInt();
  pitch.result = queue.load(std::move(pitch.result));

  ExprCompiler duration(constTable, symbolTable, queue);
  s.duration->soak(&duration);
  duration.result->castToInt();
  duration.result = queue.load(std::move(duration.result));

  queue.append(std::make_unique<InstSound>(std::move(pitch.result),
                                           std::move(duration.result)));
}

void StatementCompiler::absorb(const Exec &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler address(constTable, symbolTable, queue);
  s.address->soak(&address);
  address.result->castToInt();
  queue.append(std::make_unique<InstExec>(std::move(address.result)));
}

void StatementCompiler::absorb(const Error &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler errorCode(constTable, symbolTable, queue);
  s.errorCode->soak(&errorCode);
  queue.append(std::make_unique<InstError>(std::move(errorCode.result)));
}

void ExprCompiler::absorb(const NumericConstantExpr &e) {
  FixedPoint f(e.value);

  result = f.isPosWord()   ? makeAddrMode<AddressModeImm>(false, f.wholenum)
           : f.isNegWord() ? makeAddrMode<AddressModeImm>(true, f.wholenum)
           : f.isInteger()
               ? makeAddrMode<AddressModeExt>(DataType::Int, f.label())
               : makeAddrMode<AddressModeExt>(DataType::Flt, f.label());
}

void ExprCompiler::absorb(const StringConstantExpr &e) {
  result = std::make_unique<AddressModeStk>(e.value);
}

void ExprCompiler::absorb(const NumericVariableExpr &e) {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto varLabel = (symbol.isFloat ? "FLTVAR_" : "INTVAR_") + e.varname;
      result = std::make_unique<AddressModeExt>(dataType, varLabel);
      return;
    }
  }

  fprintf(stderr,
          "\"%s\" not found in variable table.  Is it ever initialized?\n",
          e.varname.c_str());
  exit(1);
}

void ExprCompiler::absorb(const StringVariableExpr &e) {
  for (auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      auto dataType = DataType::Str;
      auto varLabel = "STRVAR_" + e.varname;
      result = std::make_unique<AddressModeExt>(dataType, varLabel);
      return;
    }
  }

  fprintf(stderr,
          "\"%s$\" not found in variable table.  Is it ever initialized?\n",
          e.varname.c_str());
  exit(1);
}

void ExprCompiler::absorb(const StringConcatenationExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->soak(this);
      reg = result->isRegister() ? result->clone()
                                 : std::make_unique<AddressModeReg>(
                                       queue.allocRegister(), result->dataType);
      reg = queue.append(
          std::make_unique<InstStrInit>(reg->clone(), std::move(result)));
      needLoad = false;
    } else {
      operand->soak(this);
      result = queue.append(std::make_unique<InstStrCat>(
          reg->clone(), reg->clone(), std::move(result)));
    }
  }
}

void ExprCompiler::absorb(const ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    operand->soak(this);
    result = queue.load(std::move(result));
    result->castToInt();
  }
}

void ExprCompiler::absorb(const PrintTabExpr &e) {
  e.tabstop->soak(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstPrTab>(std::move(result)));
}

void ExprCompiler::absorb(const PrintCommaExpr & /*expr*/) {
  result = queue.append(std::make_unique<InstPrComma>());
}

void ExprCompiler::absorb(const PrintSpaceExpr & /*expr*/) {
  result = queue.append(std::make_unique<InstPrSpace>());
}

void ExprCompiler::absorb(const PrintCRExpr & /*expr*/) {
  result = queue.append(std::make_unique<InstPrCR>());
}

void ExprCompiler::absorb(const NumericArrayExpr &e) {
  bool useDim(arrayDim); // save state
  bool useRef(arrayRef); // save state
  arrayRef = false;
  e.indices->soak(this);
  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      int n = static_cast<int>(e.indices->operands.size());
      auto count = std::make_unique<AddressModeImm>(false, n);

      auto firstReg = std::make_unique<AddressModeReg>(
          result->getRegister() - n + 1, DataType::Int);

      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto arrLabel = (symbol.isFloat ? "FLTARR_" : "INTARR_") + symbol.name;
      result = std::make_unique<AddressModeExt>(dataType, arrLabel);

      // Slower than using nested ternary comparison operators but
      // this is considerably easier on the eyes...

      std::string tag = useDim ? "Dim" : useRef ? "Ref" : "Val";
      tag += n < 6 ? std::to_string(n) : std::string("");

      auto inst =
          tag == "Dim1"   ? makeInstMove<InstArrayDim1>(firstReg, result)
          : tag == "Ref1" ? makeInstMove<InstArrayRef1>(firstReg, result)
          : tag == "Val1" ? makeInstMove<InstArrayVal1>(firstReg, result)
          : tag == "Dim2" ? makeInstMove<InstArrayDim2>(firstReg, result)
          : tag == "Ref2" ? makeInstMove<InstArrayRef2>(firstReg, result)
          : tag == "Val2" ? makeInstMove<InstArrayVal2>(firstReg, result)
          : tag == "Dim3" ? makeInstMove<InstArrayDim3>(firstReg, result)
          : tag == "Ref3" ? makeInstMove<InstArrayRef3>(firstReg, result)
          : tag == "Val3" ? makeInstMove<InstArrayVal3>(firstReg, result)
          : tag == "Dim4" ? makeInstMove<InstArrayDim4>(firstReg, result)
          : tag == "Ref4" ? makeInstMove<InstArrayRef4>(firstReg, result)
          : tag == "Val4" ? makeInstMove<InstArrayVal4>(firstReg, result)
          : tag == "Dim5" ? makeInstMove<InstArrayDim5>(firstReg, result)
          : tag == "Ref5" ? makeInstMove<InstArrayRef5>(firstReg, result)
          : tag == "Val5" ? makeInstMove<InstArrayVal5>(firstReg, result)
          : tag == "Dim"  ? makeInstMove<InstArrayDim>(firstReg, result, count)
          : tag == "Ref"  ? makeInstMove<InstArrayRef>(firstReg, result, count)
                          : makeInstMove<InstArrayVal>(firstReg, result, count);

      result = queue.append(std::move(inst));
      return;
    }
  }

  fprintf(stderr, "\"%s\" not found in array table.  Is it ever initialized?\n",
          e.varexp->varname.c_str());
  exit(1);
}

void ExprCompiler::absorb(const StringArrayExpr &e) {
  bool useDim(arrayDim); // save state
  bool useRef(arrayRef); // save state

  arrayRef = false;
  e.indices->soak(this);
  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {

      int n = static_cast<int>(e.indices->operands.size());
      auto count = std::make_unique<AddressModeImm>(false, n);

      auto firstReg = std::make_unique<AddressModeReg>(
          result->getRegister() - n + 1, DataType::Int);

      auto dataType = DataType::Str;
      auto arrLabel = "STRARR_" + symbol.name;
      result = std::make_unique<AddressModeExt>(dataType, arrLabel);

      // Slower than using nested ternary comparison operators but
      // this is considerably easier on the eyes...

      std::string tag = useDim ? "Dim" : useRef ? "Ref" : "Val";
      tag += n < 6 ? std::to_string(n) : std::string("");

      auto inst =
          tag == "Dim1"   ? makeInstMove<InstArrayDim1>(firstReg, result)
          : tag == "Ref1" ? makeInstMove<InstArrayRef1>(firstReg, result)
          : tag == "Val1" ? makeInstMove<InstArrayVal1>(firstReg, result)
          : tag == "Dim2" ? makeInstMove<InstArrayDim2>(firstReg, result)
          : tag == "Ref2" ? makeInstMove<InstArrayRef2>(firstReg, result)
          : tag == "Val2" ? makeInstMove<InstArrayVal2>(firstReg, result)
          : tag == "Dim3" ? makeInstMove<InstArrayDim3>(firstReg, result)
          : tag == "Ref3" ? makeInstMove<InstArrayRef3>(firstReg, result)
          : tag == "Val3" ? makeInstMove<InstArrayVal3>(firstReg, result)
          : tag == "Dim4" ? makeInstMove<InstArrayDim4>(firstReg, result)
          : tag == "Ref4" ? makeInstMove<InstArrayRef4>(firstReg, result)
          : tag == "Val4" ? makeInstMove<InstArrayVal4>(firstReg, result)
          : tag == "Dim5" ? makeInstMove<InstArrayDim5>(firstReg, result)
          : tag == "Ref5" ? makeInstMove<InstArrayRef5>(firstReg, result)
          : tag == "Val5" ? makeInstMove<InstArrayVal5>(firstReg, result)
          : tag == "Dim"  ? makeInstMove<InstArrayDim>(firstReg, result, count)
          : tag == "Ref"  ? makeInstMove<InstArrayRef>(firstReg, result, count)
                          : makeInstMove<InstArrayVal>(firstReg, result, count);

      result = queue.append(std::move(inst));
      return;
    }
  }

  fprintf(stderr,
          "\"%s$\" not found in array table.  Is it ever initialized?\n",
          e.varexp->varname.c_str());
  exit(1);
}

void ExprCompiler::absorb(const ShiftExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));

  ConstInspector constInspector;
  if (!constInspector.isEqual(e.count.get(), 0)) {
    auto dest = result->clone();
    e.count->soak(this);
    result = queue.append(std::make_unique<InstShift>(
        dest->clone(), dest->clone(), std::move(result)));
  }
}

void ExprCompiler::absorb(const NegatedExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstNeg>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const ComplementedExpr &e) {
  e.expr->soak(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstCom>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const SgnExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstSgn>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const IntExpr &e) {
  e.expr->soak(this);
  result->castToInt();
}

void ExprCompiler::absorb(const AbsExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstAbs>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const SqrExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstSqr>(std::move(dest), std::move(result)));
  queue.reserve(2); // allocate two phantom regs for guess and division
}

void ExprCompiler::absorb(const ExpExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstExp>(std::move(dest), std::move(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::absorb(const LogExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstLog>(std::move(dest), std::move(result)));
  queue.reserve(3); // allocate three phantom regs for target and exp
}

void ExprCompiler::absorb(const SinExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstSin>(std::move(dest), std::move(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::absorb(const CosExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstCos>(std::move(dest), std::move(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::absorb(const TanExpr &e) {
  e.expr->soak(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstTan>(std::move(dest), std::move(result)));
  queue.reserve(2); // allocate two phantom regs for sin and cos.
}

void ExprCompiler::absorb(const RndExpr &e) {
  e.expr->soak(this);
  result->castToInt();

  // make result int when result is integer greater than 0.
  ConstInspector constInspector;
  if (constInspector.isPositive(e.expr.get())) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(
        std::make_unique<InstIRnd>(std::move(dest), std::move(result)));
  } else {
    auto dest = queue.alloc(result->clone());
    result = queue.append(
        std::make_unique<InstRnd>(std::move(dest), std::move(result)));
  }
}

void ExprCompiler::absorb(const PeekExpr &e) {
  e.expr->soak(this);

  result->castToInt();

  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstPeek>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const LenExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstLen>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const StrExpr &e) {
  e.expr->soak(this);
  auto reg = std::make_unique<AddressModeReg>(
      result->isRegister() ? result->getRegister() : queue.allocRegister(),
      DataType::Str);
  result = queue.append(
      std::make_unique<InstStr>(std::move(reg), std::move(result)));
}

void ExprCompiler::absorb(const ValExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstVal>(std::move(dest), std::move(result)));

  IsChar isChar;
  if (e.expr->inspect(&isChar)) {
    result->castToInt();
  }
}

void ExprCompiler::absorb(const AscExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstAsc>(std::move(dest), std::move(result)));
}

void ExprCompiler::absorb(const ChrExpr &e) {
  e.expr->soak(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstChr>(std::move(dest), std::move(result)));
  if (result->dataType != DataType::Str) {
    exit(1);
  }
}

void ExprCompiler::absorb(const RelationalExpr &e) {
  if (e.comparator == "<" || e.comparator == ">=" || e.comparator == "=>") {
    e.lhs->soak(this);
    auto reg = queue.load(std::move(result));
    auto dst = reg->clone();
    e.rhs->soak(this);
    if (e.lhs->isString()) {
      result = queue.append(e.comparator == "<"
                                ? makeInstMove<InstLdLo>(dst, reg, result)
                                : makeInstMove<InstLdHs>(dst, reg, result));
    } else {
      result = queue.append(e.comparator == "<"
                                ? makeInstMove<InstLdLt>(dst, reg, result)
                                : makeInstMove<InstLdGe>(dst, reg, result));
    }
  } else if (e.comparator == ">" || e.comparator == "<=" ||
             e.comparator == "=<") {
    e.rhs->soak(this);
    auto reg = queue.load(std::move(result));
    auto dst = reg->clone();
    e.lhs->soak(this);
    if (e.lhs->isString()) {
      result = queue.append(e.comparator == ">"
                                ? makeInstMove<InstLdLo>(dst, reg, result)
                                : makeInstMove<InstLdHs>(dst, reg, result));
    } else {
      result = queue.append(e.comparator == ">"
                                ? makeInstMove<InstLdLt>(dst, reg, result)
                                : makeInstMove<InstLdGe>(dst, reg, result));
    }
  } else {
    e.lhs->soak(this);
    auto reg = queue.load(std::move(result));
    auto dst = reg->clone();
    e.rhs->soak(this);
    result = queue.append(e.comparator == "="
                              ? makeInstMove<InstLdEq>(dst, reg, result)
                              : makeInstMove<InstLdNe>(dst, reg, result));
  }
}

void ExprCompiler::absorb(const LeftExpr &e) {
  e.str->soak(this);
  auto reg = queue.load(std::move(result));
  e.len->soak(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstLeft>(reg->clone(), reg->clone(),
                                                   std::move(result)));
}

void ExprCompiler::absorb(const RightExpr &e) {
  e.str->soak(this);
  auto reg = queue.load(std::move(result));
  e.len->soak(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstRight>(reg->clone(), reg->clone(),
                                                    std::move(result)));
}

void ExprCompiler::absorb(const MidExpr &e) {
  e.str->soak(this);
  auto reg = queue.load(std::move(result));
  e.start->soak(this);
  result->castToInt();
  if (e.len) {
    queue.load(std::move(result));
    e.len->soak(this);
    result->castToInt();
    result = queue.append(std::make_unique<InstMidT>(reg->clone(), reg->clone(),
                                                     std::move(result)));
  } else {
    result = queue.append(std::make_unique<InstMid>(reg->clone(), reg->clone(),
                                                    std::move(result)));
  }
}

void ExprCompiler::absorb(const PointExpr &e) {
  e.x->soak(this);
  result->castToInt();
  auto reg = queue.load(std::move(result));
  e.y->soak(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstPoint>(reg->clone(), reg->clone(),
                                                    std::move(result)));
}

void ExprCompiler::absorb(const InkeyExpr & /*expr*/) {
  result =
      std::make_unique<AddressModeReg>(queue.allocRegister(), DataType::Str);
  result = queue.append(std::make_unique<InstInkey>(std::move(result)));
}

void ExprCompiler::absorb(const MemExpr & /*expr*/) {
  result =
      std::make_unique<AddressModeReg>(queue.allocRegister(), DataType::Int);
  result = queue.append(std::make_unique<InstMem>(std::move(result)));
}

void ExprCompiler::absorb(const AdditiveExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;

  if (e.operands.empty()) { // all subtractions.  add all then negate.

    for (auto &invoperand : e.invoperands) {
      if (needLoad) {
        invoperand->soak(this);
        result = queue.load(std::move(result));
        reg = result->clone();
        needLoad = false;
      } else {
        invoperand->soak(this);
        result = queue.append(std::make_unique<InstAdd>(
            reg->clone(), reg->clone(), std::move(result)));
        reg = result->clone(); // make sure datatype is carried over
      }
    }

    result = queue.append(
        std::make_unique<InstNeg>(reg->clone(), std::move(result)));

  } else {

    for (auto &operand : e.operands) {
      if (needLoad) {
        operand->soak(this);
        reg = queue.load(std::move(result));
        needLoad = false;
      } else {
        operand->soak(this);
        result = queue.append(std::make_unique<InstAdd>(
            reg->clone(), reg->clone(), std::move(result)));
        reg = result->clone(); // make sure datatype is carried over
      }
    }

    for (auto &invoperand : e.invoperands) {
      invoperand->soak(this);
      result = queue.append(std::make_unique<InstSub>(
          reg->clone(), reg->clone(), std::move(result)));
      reg = result->clone(); // make sure datatype is carried over
    }
  }
}

void ExprCompiler::absorb(const PowerExpr &e) {
  e.base->soak(this);
  auto reg = queue.load(std::move(result));
  queue.reserve(3);
  e.exponent->soak(this);
  result = queue.append(
      std::make_unique<InstPow>(reg->clone(), reg->clone(), std::move(result)));
}

void ExprCompiler::absorb(const IntegerDivisionExpr &e) {
  // get numerator
  e.dividend->soak(this);

  ConstInspector constInspector;
  auto c = e.divisor->constify(&constInspector);
  if (!result->isFloat() && c && (*c == 5 || *c == 3)) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(*c == 3 ? makeInstMove<InstIDiv3>(dest, result)
                                  : makeInstMove<InstIDiv5>(dest, result));
  } else if (!result->isFloat() && c && *c < 256 && is5Smooth(*c)) {
    auto reg = queue.load(std::move(result));
    e.divisor->soak(this);
    result = queue.append(std::make_unique<InstIDiv5S>(
        reg->clone(), reg->clone(), std::move(result)));
  } else {
    auto reg = queue.load(std::move(result));
    queue.reserve(1);
    e.divisor->soak(this);
    result = queue.append(std::make_unique<InstIDiv>(reg->clone(), reg->clone(),
                                                     std::move(result)));
  }
}

void ExprCompiler::absorb(const MultiplicativeExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  if (e.operands.empty()) { // all divisions. multiply all then negate.
    for (auto &invoperand : e.invoperands) {
      if (needLoad) {
        invoperand->soak(this);
        result = queue.load(std::move(result));
        reg = result->clone();
        needLoad = false;
      } else {
        invoperand->soak(this);
        result = queue.append(std::make_unique<InstMul>(
            reg->clone(), reg->clone(), std::move(result)));
        reg = result->clone(); // make sure datatype is carried over
      }
    }
    result = queue.append(
        std::make_unique<InstInv>(reg->clone(), std::move(result)));
  } else {
    for (auto &operand : e.operands) {
      if (needLoad) {
        operand->soak(this);
        reg = queue.load(std::move(result));
        needLoad = false;
      } else {
        operand->soak(this);
        result = queue.append(std::make_unique<InstMul>(
            reg->clone(), reg->clone(), std::move(result)));
        reg = result->clone(); // make sure datatype is carried over
      }
    }
    for (auto &invoperand : e.invoperands) {
      invoperand->soak(this);
      result = queue.append(std::make_unique<InstDiv>(
          reg->clone(), reg->clone(), std::move(result)));
      reg = result->clone(); // make sure datatype is carried over
      queue.reserve(1);      // need additional phantom reg for div
    }
  }
}

void ExprCompiler::absorb(const OrExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->soak(this);
      result->castToInt();
      reg = queue.load(std::move(result));
      needLoad = false;
    } else {
      operand->soak(this);
      result->castToInt();
      result = queue.append(std::make_unique<InstOr>(reg->clone(), reg->clone(),
                                                     std::move(result)));
    }
  }
}

void ExprCompiler::absorb(const AndExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->soak(this);
      result->castToInt();
      reg = queue.load(std::move(result));
      needLoad = false;
    } else {
      operand->soak(this);
      result->castToInt();
      result = queue.append(std::make_unique<InstAnd>(
          reg->clone(), reg->clone(), std::move(result)));
    }
  }
}
