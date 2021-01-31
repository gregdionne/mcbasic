// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "compiler.hpp"
#include "lister.hpp"

#include <utility>

template <typename T> static inline std::string list(T &t) {
  StatementLister that;
  that.generatePredicates = false;
  t.operate(&that);
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
      std::make_unique<AddressModeLin>(l.lineNumber), generateLines));
  StatementCompiler that(constTable, symbolTable, dataTable, queue, firstLine,
                         itCurrentLine, generateLines);
  for (auto &statement : l.statements) {
    statement->operate(&that);
  }
}

void StatementCompiler::operate(Rem &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
}

void StatementCompiler::operate(For &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  // perform LET
  queue.clearRegisters();
  ExprCompiler iter(constTable, symbolTable, queue);
  ExprCompiler from(constTable, symbolTable, queue);

  s.iter->operate(&iter); // iter.result will be extended.
  s.from->operate(&from);

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
  s.to->operate(&to);
  if (castToToInt) {
    to.result->castToInt();
  }

  queue.append(std::make_unique<InstTo>(result->clone(), std::move(to.result),
                                        generateLines));

  // get STEP operand (if any)
  if (s.step) {
    queue.clearRegisters();
    ExprCompiler step(constTable, symbolTable, queue);
    s.step->operate(&step);
    step.result = queue.load(std::move(step.result));
    queue.append(
        std::make_unique<InstStep>(std::move(result), std::move(step.result)));
  }
}

void StatementCompiler::operate(Go &s) {
  queue.append(std::make_unique<InstComment>(list(s)));

  auto lineNumber = std::make_unique<AddressModeLbl>(s.lineNumber);

  queue.append(s.isSub
                   ? makeInst<InstGoSub>(std::move(lineNumber), generateLines)
                   : makeInst<InstGoTo>(std::move(lineNumber)));
}

void StatementCompiler::operate(When &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler cond(constTable, symbolTable, queue);
  s.predicate->operate(&cond);

  auto lineNumber = std::make_unique<AddressModeLbl>(s.lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(std::move(cond.result));
  }

  queue.append(s.isSub ? makeInst<InstJsrIfNotEqual>(std::move(cond.result),
                                                     std::move(lineNumber))
                       : makeInst<InstJmpIfNotEqual>(std::move(cond.result),
                                                     std::move(lineNumber)));
}

void StatementCompiler::operate(If &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler cond(constTable, symbolTable, queue);
  s.predicate->operate(&cond);

  auto lineNumber =
      std::make_unique<AddressModeLbl>((*std::next(itCurrentLine))->lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(std::move(cond.result));
  }

  queue.append(std::make_unique<InstJmpIfEqual>(std::move(cond.result),
                                                std::move(lineNumber)));

  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementCompiler::operate(Data & /*statement*/) {
  queue.append(std::make_unique<InstComment>("DATA ..."));
}

void StatementCompiler::operate(Print &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler value(constTable, symbolTable, queue);
  if (s.at) {
    queue.clearRegisters();
    s.at->operate(&value);
    value.result->castToInt(); // override
    queue.append(std::make_unique<InstPrAt>(std::move(value.result)));
  }
  for (auto &expr : s.printExpr) {
    queue.clearRegisters();
    expr->operate(&value);
    // print if not handled by PrTab or PrComma or PrCR
    if (value.result && value.result->exists()) {
      queue.append(std::make_unique<InstPr>(std::move(value.result)));
    }
  }
}

void StatementCompiler::operate(Input &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler value(constTable, symbolTable, queue);

  if (s.prompt) {
    s.prompt->operate(&value);
    queue.append(std::make_unique<InstPr>(std::move(value.result)));
  }

  queue.append(std::make_unique<InstInputBuf>());

  for (auto &variable : s.variables) {
    queue.clearRegisters();
    value.arrayRef = !variable->isVar();
    variable->operate(&value);
    queue.append(std::make_unique<InstReadBuf>(std::move(value.result)));
  }

  queue.append(std::make_unique<InstIgnoreExtra>());
}

void StatementCompiler::operate(End &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstEnd>());
}

void StatementCompiler::operate(On &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler value(constTable, symbolTable, queue);
  s.branchIndex->operate(&value);
  value.result = queue.load(std::move(value.result));
  value.result->castToInt(); // override
  queue.append(s.isSub ? makeInst<InstOnGoSub>(
                             std::move(value.result),
                             std::make_unique<AddressModeStk>(s.branchTable))
                       : makeInst<InstOnGoTo>(
                             std::move(value.result),
                             std::make_unique<AddressModeStk>(s.branchTable)));
}

void StatementCompiler::operate(Next &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  if (s.variables.empty()) {
    queue.append(std::make_unique<InstNext>(generateLines));
  } else {
    for (auto &variable : s.variables) {
      queue.clearRegisters();
      ExprCompiler var(constTable, symbolTable, queue);
      variable->operate(&var);
      queue.append(
          std::make_unique<InstNextVar>(std::move(var.result), generateLines));
      queue.append(std::make_unique<InstNext>(generateLines));
    }
  }
}

void StatementCompiler::operate(Dim &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  for (auto &variable : s.variables) {
    queue.clearRegisters();
    ExprCompiler var(constTable, symbolTable, queue);
    var.arrayDim = true;
    variable->operate(&var);
  }
}

void StatementCompiler::operate(Read &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  for (auto &variable : s.variables) {
    queue.clearRegisters();

    ExprCompiler dest(constTable, symbolTable, queue);

    dest.arrayRef = !variable->isVar();
    variable->operate(
        &dest); // dest.result will be either indirect or extended.

    auto inst = std::make_unique<InstRead>(std::move(dest.result));
    inst->pureUnsigned = dataTable.pureUnsigned;
    inst->pureByte = dataTable.pureByte;
    inst->pureWord = dataTable.pureWord;
    inst->pureNumeric = dataTable.pureNumeric;
    queue.append(std::move(inst));
  }
}

void StatementCompiler::operate(Let &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->operate(&dest); // dest.result will be either indirect or extended.

  queue.clearRegisters();
  s.rhs->operate(&value); // accum

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstLd>(std::move(dest.result),
                                        std::move(value.result)));
}

void StatementCompiler::operate(Inc &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->operate(&dest); // dest.result will be either indirect or extended.

  queue.clearRegisters();
  s.rhs->operate(&value); // accum

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstAdd>(
      dest.result->clone(), dest.result->clone(), std::move(value.result)));
}

void StatementCompiler::operate(Dec &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->operate(&dest); // dest.result will be either indirect or extended.

  queue.clearRegisters();
  s.rhs->operate(&value); // accum

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstSub>(
      dest.result->clone(), dest.result->clone(), std::move(value.result)));
}

void StatementCompiler::operate(Run &s) {
  auto lineNumber = std::make_unique<AddressModeLbl>(
      s.hasLineNumber ? s.lineNumber : firstLine);

  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstClear>());
  queue.append(std::make_unique<InstGoTo>(std::move(lineNumber)));
}

void StatementCompiler::operate(Restore &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstRestore>());
}

void StatementCompiler::operate(Return &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstReturn>(generateLines));
}

void StatementCompiler::operate(Stop &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.append(std::make_unique<InstStop>());
}

void StatementCompiler::operate(Poke &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler dest(constTable, symbolTable, queue);
  s.dest->operate(&dest);
  dest.result->castToInt();

  ExprCompiler value(constTable, symbolTable, queue);
  s.val->operate(&value);
  value.result->castToInt();

  if (value.result->modeType != AddressMode::ModeType::Reg &&
      value.result->modeType == dest.result->modeType) {
    value.result = queue.load(std::move(value.result));
  }

  queue.append(std::make_unique<InstPoke>(std::move(dest.result),
                                          std::move(value.result)));
}

void StatementCompiler::operate(Clear &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  // arguments are ignored
  queue.append(std::make_unique<InstClear>());
}

void StatementCompiler::operate(Set &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler x(constTable, symbolTable, queue);
  ExprCompiler y(constTable, symbolTable, queue);

  s.x->operate(&x);
  x.result->castToInt();
  x.result = queue.load(std::move(x.result));
  s.y->operate(&y);
  y.result->castToInt();
  y.result = queue.load(std::move(y.result));
  if (s.c) {
    ExprCompiler c(constTable, symbolTable, queue);
    s.c->operate(&c);
    c.result->castToInt();
    queue.append(std::make_unique<InstSetC>(
        std::move(x.result), std::move(y.result), std::move(c.result)));
  } else {
    queue.append(
        std::make_unique<InstSet>(std::move(x.result), std::move(y.result)));
  }
}

void StatementCompiler::operate(Reset &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler x(constTable, symbolTable, queue);
  ExprCompiler y(constTable, symbolTable, queue);

  s.x->operate(&x);
  x.result->castToInt();
  x.result = queue.load(std::move(x.result));
  s.y->operate(&y);
  y.result->castToInt();

  queue.append(
      std::make_unique<InstReset>(std::move(x.result), std::move(y.result)));
}

void StatementCompiler::operate(Cls &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  if (s.color) {
    queue.clearRegisters();
    ExprCompiler color(constTable, symbolTable, queue);
    s.color->operate(&color);
    color.result->castToInt();
    queue.append(std::make_unique<InstClsN>(std::move(color.result)));
  } else {
    queue.append(std::make_unique<InstCls>());
  }
}

void StatementCompiler::operate(Sound &s) {
  queue.append(std::make_unique<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler pitch(constTable, symbolTable, queue);
  s.pitch->operate(&pitch);
  pitch.result->castToInt();
  pitch.result = queue.load(std::move(pitch.result));

  ExprCompiler duration(constTable, symbolTable, queue);
  s.duration->operate(&duration);
  duration.result->castToInt();
  duration.result = queue.load(std::move(duration.result));

  queue.append(std::make_unique<InstSound>(std::move(pitch.result),
                                           std::move(duration.result)));
}

void ExprCompiler::operate(NumericConstantExpr &e) {
  FixedPoint f(e.value);

  result = f.isPosWord()   ? makeAddrMode<AddressModeImm>(false, f.wholenum)
           : f.isNegWord() ? makeAddrMode<AddressModeImm>(true, f.wholenum)
           : f.isInteger()
               ? makeAddrMode<AddressModeExt>(DataType::Int, f.label())
               : makeAddrMode<AddressModeExt>(DataType::Flt, f.label());
}

void ExprCompiler::operate(StringConstantExpr &e) {
  result = std::make_unique<AddressModeStk>(e.value);
}

void ExprCompiler::operate(NumericVariableExpr &e) {
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

void ExprCompiler::operate(StringVariableExpr &e) {
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

void ExprCompiler::operate(StringConcatenationExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->operate(this);
      reg = result->isRegister() ? result->clone()
                                 : std::make_unique<AddressModeReg>(
                                       queue.allocRegister(), result->dataType);
      reg = queue.append(
          std::make_unique<InstStrInit>(reg->clone(), std::move(result)));
      needLoad = false;
    } else {
      operand->operate(this);
      result = queue.append(std::make_unique<InstStrCat>(
          reg->clone(), reg->clone(), std::move(result)));
    }
  }
}

void ExprCompiler::operate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
    result = queue.load(std::move(result));
    result->castToInt();
  }
}

void ExprCompiler::operate(PrintTabExpr &e) {
  e.tabstop->operate(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstPrTab>(std::move(result)));
}

void ExprCompiler::operate(PrintCommaExpr & /*expr*/) {
  result = queue.append(std::make_unique<InstPrComma>());
}

void ExprCompiler::operate(PrintSpaceExpr & /*expr*/) {
  result = queue.append(std::make_unique<InstPrSpace>());
}

void ExprCompiler::operate(PrintCRExpr & /*expr*/) {
  result = queue.append(std::make_unique<InstPrCR>());
}

void ExprCompiler::operate(NumericArrayExpr &e) {
  bool useDim(arrayDim); // save state
  bool useRef(arrayRef); // save state
  arrayRef = false;
  e.indices->operate(this);
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

void ExprCompiler::operate(StringArrayExpr &e) {
  bool useDim(arrayDim); // save state
  bool useRef(arrayRef); // save state

  arrayRef = false;
  e.indices->operate(this);
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

void ExprCompiler::operate(ShiftExpr &e) {
  e.expr->operate(this);
  if (e.rhs != 0) {
    result = queue.load(std::move(result));
    auto dest = result->clone();
    result = queue.append(std::make_unique<InstShift>(
        std::move(dest), std::move(result),
        std::make_unique<AddressModeImm>(e.rhs < 0,
                                         e.rhs < 0 ? -e.rhs : e.rhs)));
  }
}

void ExprCompiler::operate(NegatedExpr &e) {
  e.expr->operate(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstNeg>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(ComplementedExpr &e) {
  e.expr->operate(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstCom>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(SgnExpr &e) {
  e.expr->operate(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstSgn>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(IntExpr &e) {
  e.expr->operate(this);
  result->castToInt();
}

void ExprCompiler::operate(AbsExpr &e) {
  e.expr->operate(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstAbs>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(SqrExpr &e) {
  e.expr->operate(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstSqr>(std::move(dest), std::move(result)));
  queue.reserve(2); // allocate two phantom regs for guess and division
}

void ExprCompiler::operate(ExpExpr &e) {
  e.expr->operate(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstExp>(std::move(dest), std::move(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::operate(LogExpr &e) {
  e.expr->operate(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstLog>(std::move(dest), std::move(result)));
  queue.reserve(3); // allocate three phantom regs for target and exp
}

void ExprCompiler::operate(SinExpr &e) {
  e.expr->operate(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstSin>(std::move(dest), std::move(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::operate(CosExpr &e) {
  e.expr->operate(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstCos>(std::move(dest), std::move(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::operate(TanExpr &e) {
  e.expr->operate(this);
  result = queue.load(std::move(result));
  auto dest = result->clone();
  result = queue.append(
      std::make_unique<InstTan>(std::move(dest), std::move(result)));
  queue.reserve(2); // allocate two phantom regs for sin and cos.
}

void ExprCompiler::operate(RndExpr &e) {
  e.expr->operate(this);
  result->castToInt();

  double c; // make result int when result is integer greater than 0.
  if (e.expr->isConst(c) && c > 0) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(
        std::make_unique<InstIRnd>(std::move(dest), std::move(result)));
  } else {
    auto dest = queue.alloc(result->clone());
    result = queue.append(
        std::make_unique<InstRnd>(std::move(dest), std::move(result)));
  }
}

void ExprCompiler::operate(PeekExpr &e) {
  e.expr->operate(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstPeek>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(LenExpr &e) {
  e.expr->operate(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstLen>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(StrExpr &e) {
  e.expr->operate(this);
  auto reg = std::make_unique<AddressModeReg>(
      result->isRegister() ? result->getRegister() : queue.allocRegister(),
      DataType::Str);
  result = queue.append(
      std::make_unique<InstStr>(std::move(reg), std::move(result)));
}

void ExprCompiler::operate(ValExpr &e) {
  e.expr->operate(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstVal>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(AscExpr &e) {
  e.expr->operate(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstAsc>(std::move(dest), std::move(result)));
}

void ExprCompiler::operate(ChrExpr &e) {
  e.expr->operate(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(
      std::make_unique<InstChr>(std::move(dest), std::move(result)));
  if (result->dataType != DataType::Str) {
    exit(1);
  }
}

void ExprCompiler::operate(RelationalExpr &e) {
  if (e.comparator == "<" || e.comparator == ">=" || e.comparator == "=>") {
    e.lhs->operate(this);
    auto reg = queue.load(std::move(result));
    auto dst = reg->clone();
    e.rhs->operate(this);
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
    e.rhs->operate(this);
    auto reg = queue.load(std::move(result));
    auto dst = reg->clone();
    e.lhs->operate(this);
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
    e.lhs->operate(this);
    auto reg = queue.load(std::move(result));
    auto dst = reg->clone();
    e.rhs->operate(this);
    result = queue.append(e.comparator == "="
                              ? makeInstMove<InstLdEq>(dst, reg, result)
                              : makeInstMove<InstLdNe>(dst, reg, result));
  }
}

void ExprCompiler::operate(LeftExpr &e) {
  e.str->operate(this);
  auto reg = queue.load(std::move(result));
  e.len->operate(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstLeft>(reg->clone(), reg->clone(),
                                                   std::move(result)));
}

void ExprCompiler::operate(RightExpr &e) {
  e.str->operate(this);
  auto reg = queue.load(std::move(result));
  e.len->operate(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstRight>(reg->clone(), reg->clone(),
                                                    std::move(result)));
}

void ExprCompiler::operate(MidExpr &e) {
  e.str->operate(this);
  auto reg = queue.load(std::move(result));
  e.start->operate(this);
  result->castToInt();
  if (e.len) {
    queue.load(std::move(result));
    e.len->operate(this);
    result->castToInt();
    result = queue.append(std::make_unique<InstMidT>(reg->clone(), reg->clone(),
                                                     std::move(result)));
  } else {
    result = queue.append(std::make_unique<InstMid>(reg->clone(), reg->clone(),
                                                    std::move(result)));
  }
}

void ExprCompiler::operate(PointExpr &e) {
  e.x->operate(this);
  result->castToInt();
  auto reg = queue.load(std::move(result));
  e.y->operate(this);
  result->castToInt();
  result = queue.append(std::make_unique<InstPoint>(reg->clone(), reg->clone(),
                                                    std::move(result)));
}

void ExprCompiler::operate(InkeyExpr & /*expr*/) {
  result =
      std::make_unique<AddressModeReg>(queue.allocRegister(), DataType::Str);
  result = queue.append(std::make_unique<InstInkey>(std::move(result)));
}

void ExprCompiler::operate(AdditiveExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  if (e.operands.empty()) { // all subtractions.  add all then negate.
    for (auto &invoperand : e.invoperands) {
      if (needLoad) {
        invoperand->operate(this);
        result = queue.load(std::move(result));
        reg = result->clone();
        needLoad = false;
      } else {
        invoperand->operate(this);
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
        operand->operate(this);
        reg = queue.load(std::move(result));
        needLoad = false;
      } else {
        operand->operate(this);
        result = queue.append(std::make_unique<InstAdd>(
            reg->clone(), reg->clone(), std::move(result)));
        reg = result->clone(); // make sure datatype is carried over
      }
    }
    for (auto &invoperand : e.invoperands) {
      invoperand->operate(this);
      result = queue.append(std::make_unique<InstSub>(
          reg->clone(), reg->clone(), std::move(result)));
      reg = result->clone(); // make sure datatype is carried over
    }
  }
}

void ExprCompiler::operate(PowerExpr &e) {
  e.base->operate(this);
  auto reg = queue.load(std::move(result));
  queue.reserve(3);
  e.exponent->operate(this);
  result = queue.append(
      std::make_unique<InstPow>(reg->clone(), reg->clone(), std::move(result)));
}

void ExprCompiler::operate(MultiplicativeExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  if (e.operands.empty()) { // all subtractions.  add all then negate.
    for (auto &invoperand : e.invoperands) {
      if (needLoad) {
        invoperand->operate(this);
        result = queue.load(std::move(result));
        reg = result->clone();
        needLoad = false;
      } else {
        invoperand->operate(this);
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
        operand->operate(this);
        reg = queue.load(std::move(result));
        needLoad = false;
      } else {
        operand->operate(this);
        result = queue.append(std::make_unique<InstMul>(
            reg->clone(), reg->clone(), std::move(result)));
        reg = result->clone(); // make sure datatype is carried over
      }
    }
    for (auto &invoperand : e.invoperands) {
      invoperand->operate(this);
      result = queue.append(std::make_unique<InstDiv>(
          reg->clone(), reg->clone(), std::move(result)));
      reg = result->clone(); // make sure datatype is carried over
      queue.reserve(1);      // need additional phantom reg for div
    }
  }
}

void ExprCompiler::operate(OrExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->operate(this);
      reg = queue.load(std::move(result));
      needLoad = false;
    } else {
      operand->operate(this);
      result = queue.append(std::make_unique<InstOr>(reg->clone(), reg->clone(),
                                                     std::move(result)));
    }
  }
}

void ExprCompiler::operate(AndExpr &e) {
  std::unique_ptr<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->operate(this);
      reg = queue.load(std::move(result));
      needLoad = false;
    } else {
      operand->operate(this);
      result = queue.append(std::make_unique<InstAnd>(
          reg->clone(), reg->clone(), std::move(result)));
    }
  }
}
