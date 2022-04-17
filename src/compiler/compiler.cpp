// Copyright (C) 2021-2022 Greg Dionne
// Distributed under MIT License
#include "compiler.hpp"
#include "ast/lister.hpp"
#include "consttable/fixedpoint.hpp"
#include "optimizer/constinspector.hpp"
#include "optimizer/ischar.hpp"
#include "optimizer/iscmpeqzero.hpp"
#include "optimizer/iscmpnezero.hpp"
#include "optimizer/nonzerobranchselector.hpp"
#include "utils/memutils.hpp"
#include <array>

template <typename T> static inline std::string list(T &t) {
  StatementLister that;
  that.generatePredicates = false;
  t.soak(&that);
  return that.result;
}

// C++ expects the return values of the ternary (conditional) operator
// to be of the same type.  We use this to simplify conditional object
// construction by casting the result to up<BaseType>.

template <typename T, typename... Args>
static inline up<AddressMode> makeupAM(Args &&...args) {
  return makeup<T>(std::forward<Args>(args)...);
}

template <typename T, typename... Args>
static inline up<Instruction> makeupInst(Args &&...args) {
  return makeup<T>(std::forward<Args>(args)...);
}

template <typename T, typename... Args>
static inline up<Instruction> makeupInstMv(Args &&...args) {
  return makeupInst<T>(mv<Args>(args)...);
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
  queue.append(makeup<InstBegin>());
  queue.append(makeup<InstClear>());
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
  queue.append(makeup<InstLabel>(
      makeup<AddressModeLin>(l.lineNumber),
      generateLines && l.lineNumber != constants::unlistedLineNumber));

  StatementCompiler that(constTable, symbolTable, dataTable, queue, firstLine,
                         itCurrentLine, generateLines);

  for (auto &statement : l.statements) {
    statement->soak(&that);
  }
}

void StatementCompiler::absorb(const Rem &s) {
  queue.append(makeup<InstComment>(list(s)));
}

void StatementCompiler::absorb(const For &s) {
  queue.append(makeup<InstComment>(list(s)));
  // perform LET
  queue.clearRegisters();
  ExprCompiler iter(constTable, symbolTable, queue);
  ExprCompiler from(constTable, symbolTable, queue);

  s.iter->soak(&iter); // iter.result will be extended.

  // result (of type ptr) keeps track of int/flt iter argument
  auto result = ([this, &s, &iter, &from]() -> up<AddressMode> {
    s.from->soak(&from);

    ConstInspector constInspector;

    if (constInspector.isEqual(s.from.get(), 1)) {
      return queue.append(makeup<InstForOne>(mv(iter.result)));
    }

    if (constInspector.isEqual(s.from.get(), -1)) {
      return queue.append(makeup<InstForTrue>(mv(iter.result)));
    }

    if (constInspector.isEqual(s.from.get(), 0)) {
      return queue.append(makeup<InstForClr>(mv(iter.result)));
    }

    if (iter.result->isExtended() && from.result->isExtended()) {
      iter.result =
          makeup<AddressModeDex>(iter.result->dataType, iter.result->vsymbol());
    } else if (from.result->modeType != AddressMode::ModeType::Imm) {
      from.result = queue.load(mv(from.result));
    }
    return queue.append(
        makeup<InstFor>(iter.result->clone(), from.result->clone()));
  })();

  // get TO operand
  queue.clearRegisters();

  ExprCompiler to(constTable, symbolTable, queue);
  s.to->soak(&to);

  // check to see if we can avoid integer argument to TO if STEP is not
  // specified and FROM is an integer
  if (!s.step && !from.result->isFloat()) {
    to.result->castToInt();
  }

  queue.append(makeup<InstTo>(result->clone(), mv(to.result), generateLines));

  // get STEP operand (if any)
  if (s.step) {
    queue.clearRegisters();
    ExprCompiler step(constTable, symbolTable, queue);
    s.step->soak(&step);
    step.result = queue.load(mv(step.result));
    queue.append(makeup<InstStep>(mv(result), mv(step.result)));
  }
}

void StatementCompiler::absorb(const Go &s) {
  queue.append(makeup<InstComment>(list(s)));

  auto lineNumber = makeup<AddressModeLbl>(s.lineNumber);

  queue.append(s.isSub ? makeupInst<InstGoSub>(mv(lineNumber), generateLines)
                       : makeupInst<InstGoTo>(mv(lineNumber)));
}

void StatementCompiler::absorb(const When &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();

  auto const *predicate = s.predicate.get();
  bool needEq = false;

  IsCmpEqZero isCmpEqZero;
  IsCmpNeZero isCmpNeZero;
  if (predicate->check(&isCmpNeZero)) {
    // remove redundant check
    NonZeroBranchSelector nonZeroBranchSelector;
    predicate = predicate->select(&nonZeroBranchSelector);
  } else if (predicate->check(&isCmpEqZero)) {
    // remove comparison and invert jmp condition
    NonZeroBranchSelector nonZeroBranchSelector;
    predicate = predicate->select(&nonZeroBranchSelector);
    needEq = true;
  }

  ExprCompiler cond(constTable, symbolTable, queue);
  predicate->soak(&cond);

  auto lineNumber = makeup<AddressModeLbl>(s.lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(mv(cond.result));
  }

  queue.append(
      needEq ? s.isSub ? makeupInstMv<InstJsrIfEqual>(cond.result, lineNumber)
                       : makeupInstMv<InstJmpIfEqual>(cond.result, lineNumber)
      : s.isSub ? makeupInstMv<InstJsrIfNotEqual>(cond.result, lineNumber)
                : makeupInstMv<InstJmpIfNotEqual>(cond.result, lineNumber));
}

void StatementCompiler::absorb(const If &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();

  auto const *predicate = s.predicate.get();
  bool needEq = true;

  IsCmpEqZero isCmpEqZero;
  IsCmpNeZero isCmpNeZero;
  if (predicate->check(&isCmpNeZero)) {
    // remove redundant check
    NonZeroBranchSelector nonZeroBranchSelector;
    predicate = predicate->select(&nonZeroBranchSelector);
  } else if (predicate->check(&isCmpEqZero)) {
    // remove comparison and invert jmp condition
    NonZeroBranchSelector nonZeroBranchSelector;
    predicate = predicate->select(&nonZeroBranchSelector);
    needEq = false;
  }

  ExprCompiler cond(constTable, symbolTable, queue);
  predicate->soak(&cond);

  auto lineNumber =
      makeup<AddressModeLbl>((*std::next(itCurrentLine))->lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(mv(cond.result));
  }

  queue.append(needEq
                   ? makeupInstMv<InstJmpIfEqual>(cond.result, lineNumber)
                   : makeupInstMv<InstJmpIfNotEqual>(cond.result, lineNumber));

  for (auto &statement : s.consequent) {
    statement->soak(this);
  }
}

void StatementCompiler::absorb(const Data & /*statement*/) {
  queue.append(makeup<InstComment>("DATA ..."));
}

void StatementCompiler::absorb(const Print &s) {
  queue.append(makeup<InstComment>(list(s)));
  ExprCompiler value(constTable, symbolTable, queue);
  if (s.at) {
    queue.clearRegisters();
    s.at->soak(&value);
    value.result->castToInt(); // override
    queue.append(makeup<InstPrAt>(mv(value.result)));
  }
  for (auto &expr : s.printExpr) {
    queue.clearRegisters();
    expr->soak(&value);
    // print if not handled by PrTab or PrComma or PrCR
    if (value.result && value.result->exists()) {
      queue.append(makeup<InstPr>(mv(value.result)));
    }
  }
}

void StatementCompiler::absorb(const Input &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler value(constTable, symbolTable, queue);

  if (s.prompt) {
    s.prompt->soak(&value);
    queue.append(makeup<InstPr>(mv(value.result)));
  }

  queue.append(makeup<InstInputBuf>());

  for (auto &variable : s.variables) {
    queue.clearRegisters();
    value.arrayRef = !variable->isVar();
    variable->soak(&value);
    queue.append(makeup<InstReadBuf>(mv(value.result)));
  }

  queue.append(makeup<InstIgnoreExtra>());
}

void StatementCompiler::absorb(const End &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.append(makeup<InstEnd>());
}

void StatementCompiler::absorb(const On &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler value(constTable, symbolTable, queue);
  s.branchIndex->soak(&value);
  value.result = queue.load(mv(value.result));
  value.result->castToInt(); // override
  queue.append(
      s.isSub ? makeupInst<InstOnGoSub>(mv(value.result),
                                        makeup<AddressModeStk>(s.branchTable),
                                        generateLines)
              : makeupInst<InstOnGoTo>(mv(value.result),
                                       makeup<AddressModeStk>(s.branchTable)));
}

void StatementCompiler::absorb(const Next &s) {
  queue.append(makeup<InstComment>(list(s)));
  if (s.variables.empty()) {
    queue.append(makeup<InstNext>(generateLines));
  } else {
    for (auto &variable : s.variables) {
      queue.clearRegisters();
      ExprCompiler var(constTable, symbolTable, queue);
      variable->soak(&var);
      queue.append(makeup<InstNextVar>(mv(var.result), generateLines));
      queue.append(makeup<InstNext>(generateLines));
    }
  }
}

void StatementCompiler::absorb(const Dim &s) {
  queue.append(makeup<InstComment>(list(s)));
  for (auto &variable : s.variables) {
    queue.clearRegisters();
    ExprCompiler var(constTable, symbolTable, queue);
    var.arrayDim = true;
    variable->soak(&var);
  }
}

void StatementCompiler::absorb(const Read &s) {
  queue.append(makeup<InstComment>(list(s)));
  for (auto &variable : s.variables) {
    queue.clearRegisters();

    ExprCompiler dest(constTable, symbolTable, queue);

    dest.arrayRef = !variable->isVar();
    variable->soak(&dest); // dest.result will be either indirect or extended.

    auto inst = makeup<InstRead>(mv(dest.result));
    inst->pureUnsigned = dataTable.pureUnsigned;
    inst->pureByte = dataTable.pureByte;
    inst->pureWord = dataTable.pureWord;
    inst->pureNumeric = dataTable.pureNumeric;
    queue.append(mv(inst));
  }
}

void StatementCompiler::absorb(const Let &s) {
  queue.append(makeup<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  if (constInspector.isEqual(s.rhs.get(), 1)) {
    queue.append(makeup<InstOne>(mv(dest.result)));
    return;
  }

  if (constInspector.isEqual(s.rhs.get(), -1)) {
    queue.append(makeup<InstTrue>(mv(dest.result)));
    return;
  }

  if (constInspector.isEqual(s.rhs.get(), 0)) {
    queue.append(makeup<InstClr>(mv(dest.result)));
    return;
  }

  if (auto rhs = dynamic_cast<InkeyExpr *>(s.rhs.get())) {
    queue.append(makeup<InstInkey>(mv(dest.result)));
    return;
  }

  queue.clearRegisters();
  s.rhs->soak(&value); // accum

  if (dest.result->isExtended() && value.result->isExtended()) {
    dest.result =
        makeup<AddressModeDex>(dest.result->dataType, dest.result->vsymbol());
  } else if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(mv(value.result));
  }

  queue.append(makeup<InstLd>(mv(dest.result), mv(value.result)));
}

void StatementCompiler::absorb(const Accum &s) {
  queue.append(makeup<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  auto arg = dynamic_cast<const NumericExpr *>(s.rhs.get());

  if (arg && constInspector.isEqual(arg, 1)) {
    queue.append(makeup<InstInc>(dest.result->clone(), dest.result->clone()));
    return;
  }

  if (arg && constInspector.isEqual(arg, -1)) {
    queue.append(makeup<InstDec>(dest.result->clone(), dest.result->clone()));
    return;
  }

  queue.clearRegisters();
  s.rhs->soak(&value);

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(mv(value.result));
  }

  queue.append(makeup<InstAdd>(dest.result->clone(), dest.result->clone(),
                               mv(value.result)));
}

void StatementCompiler::absorb(const Decum &s) {
  queue.append(makeup<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  auto arg = dynamic_cast<const NumericExpr *>(s.rhs.get());

  if (arg && constInspector.isEqual(arg, 1)) {
    queue.append(makeup<InstDec>(dest.result->clone(), dest.result->clone()));
    return;
  }

  if (arg && constInspector.isEqual(arg, -1)) {
    queue.append(makeup<InstInc>(dest.result->clone(), dest.result->clone()));
    return;
  }

  queue.clearRegisters();
  s.rhs->soak(&value);

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(mv(value.result));
  }

  queue.append(makeup<InstSub>(dest.result->clone(), dest.result->clone(),
                               mv(value.result)));
}

void StatementCompiler::absorb(const Necum &s) {
  queue.append(makeup<InstComment>(list(s)));
  ExprCompiler dest(constTable, symbolTable, queue);
  ExprCompiler value(constTable, symbolTable, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  auto arg = dynamic_cast<const NumericExpr *>(s.rhs.get());

  if (arg && constInspector.isEqual(arg, 0)) {
    queue.append(makeup<InstNeg>(dest.result->clone(), dest.result->clone()));
    return;
  }

  queue.clearRegisters();
  s.rhs->soak(&value);

  if (value.result->modeType != AddressMode::ModeType::Imm) {
    value.result = queue.load(mv(value.result));
  }

  queue.append(makeup<InstRSub>(dest.result->clone(), dest.result->clone(),
                                mv(value.result)));
}

void StatementCompiler::absorb(const Run &s) {
  auto lineNumber =
      makeup<AddressModeLbl>(s.hasLineNumber ? s.lineNumber : firstLine);

  queue.append(makeup<InstComment>(list(s)));
  queue.append(makeup<InstClear>());
  queue.append(makeup<InstGoTo>(mv(lineNumber)));
}

void StatementCompiler::absorb(const Restore &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.append(makeup<InstRestore>());
}

void StatementCompiler::absorb(const Return &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.append(makeup<InstReturn>(generateLines));
}

void StatementCompiler::absorb(const Stop &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.append(makeup<InstStop>());
}

void StatementCompiler::absorb(const Poke &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler dest(constTable, symbolTable, queue);
  s.dest->soak(&dest);
  dest.result->castToInt();

  ExprCompiler value(constTable, symbolTable, queue);
  s.val->soak(&value);
  value.result->castToInt();

  if (dest.result->isExtended() && value.result->isExtended()) {
    dest.result =
        makeup<AddressModeDex>(dest.result->dataType, dest.result->vsymbol());
  }

  if (value.result->modeType != AddressMode::ModeType::Reg &&
      value.result->modeType == dest.result->modeType) {
    value.result = queue.load(mv(value.result));
  }

  queue.append(makeup<InstPoke>(mv(dest.result), mv(value.result)));
}

void StatementCompiler::absorb(const Clear &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  // arguments are ignored
  queue.append(makeup<InstClear>());
}

void StatementCompiler::absorb(const Set &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler x(constTable, symbolTable, queue);
  ExprCompiler y(constTable, symbolTable, queue);

  s.x->soak(&x);
  x.result->castToInt();
  x.result = queue.load(mv(x.result));
  s.y->soak(&y);
  y.result->castToInt();
  y.result = queue.load(mv(y.result));
  if (s.c) {
    ExprCompiler c(constTable, symbolTable, queue);
    s.c->soak(&c);
    c.result->castToInt();
    queue.append(makeup<InstSetC>(mv(x.result), mv(y.result), mv(c.result)));
  } else {
    queue.append(makeup<InstSet>(mv(x.result), mv(y.result)));
  }
}

void StatementCompiler::absorb(const Reset &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler x(constTable, symbolTable, queue);
  ExprCompiler y(constTable, symbolTable, queue);

  s.x->soak(&x);
  x.result->castToInt();
  x.result = queue.load(mv(x.result));
  s.y->soak(&y);
  y.result->castToInt();

  queue.append(makeup<InstReset>(mv(x.result), mv(y.result)));
}

void StatementCompiler::absorb(const Cls &s) {
  queue.append(makeup<InstComment>(list(s)));
  if (s.color) {
    queue.clearRegisters();
    ExprCompiler color(constTable, symbolTable, queue);
    s.color->soak(&color);
    color.result->castToInt();
    queue.append(makeup<InstClsN>(mv(color.result)));
  } else {
    queue.append(makeup<InstCls>());
  }
}

void StatementCompiler::absorb(const Sound &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();

  ExprCompiler pitch(constTable, symbolTable, queue);
  s.pitch->soak(&pitch);
  pitch.result->castToInt();
  pitch.result = queue.load(mv(pitch.result));

  ExprCompiler duration(constTable, symbolTable, queue);
  s.duration->soak(&duration);
  duration.result->castToInt();
  duration.result = queue.load(mv(duration.result));

  queue.append(makeup<InstSound>(mv(pitch.result), mv(duration.result)));
}

void StatementCompiler::absorb(const Exec &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler address(constTable, symbolTable, queue);
  s.address->soak(&address);
  address.result->castToInt();
  queue.append(makeup<InstExec>(mv(address.result)));
}

void StatementCompiler::absorb(const Error &s) {
  queue.append(makeup<InstComment>(list(s)));
  queue.clearRegisters();
  ExprCompiler errorCode(constTable, symbolTable, queue);
  s.errorCode->soak(&errorCode);
  queue.append(makeup<InstError>(mv(errorCode.result)));
}

void ExprCompiler::absorb(const NumericConstantExpr &e) {
  FixedPoint f(e.value);

  result = f.isPosWord()   ? makeupAM<AddressModeImm>(false, f.wholenum)
           : f.isNegWord() ? makeupAM<AddressModeImm>(true, f.wholenum)
           : f.isInteger() ? makeupAM<AddressModeExt>(DataType::Int, f.label())
                           : makeupAM<AddressModeExt>(DataType::Flt, f.label());
}

void ExprCompiler::absorb(const StringConstantExpr &e) {
  result = makeup<AddressModeStk>(e.value);
}

void ExprCompiler::absorb(const NumericVariableExpr &e) {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto varLabel = (symbol.isFloat ? "FLTVAR_" : "INTVAR_") + e.varname;
      result = makeup<AddressModeExt>(dataType, varLabel);
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
      result = makeup<AddressModeExt>(dataType, varLabel);
      return;
    }
  }

  fprintf(stderr,
          "\"%s$\" not found in variable table.  Is it ever initialized?\n",
          e.varname.c_str());
  exit(1);
}

void ExprCompiler::absorb(const StringConcatenationExpr &e) {
  up<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->soak(this);
      reg = result->isRegister() ? result->clone()
                                 : makeup<AddressModeReg>(queue.allocRegister(),
                                                          result->dataType);
      reg = queue.append(makeup<InstStrInit>(reg->clone(), mv(result)));
      needLoad = false;
    } else {
      operand->soak(this);
      result = queue.append(
          makeup<InstStrCat>(reg->clone(), reg->clone(), mv(result)));
    }
  }
}

void ExprCompiler::absorb(const ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    operand->soak(this);
    result = queue.load(mv(result));
    result->castToInt();
  }
}

void ExprCompiler::absorb(const PrintTabExpr &e) {
  e.tabstop->soak(this);
  result->castToInt();
  result = queue.append(makeup<InstPrTab>(mv(result)));
}

void ExprCompiler::absorb(const PrintCommaExpr & /*expr*/) {
  result = queue.append(makeup<InstPrComma>());
}

void ExprCompiler::absorb(const PrintSpaceExpr & /*expr*/) {
  result = queue.append(makeup<InstPrSpace>());
}

void ExprCompiler::absorb(const PrintCRExpr & /*expr*/) {
  result = queue.append(makeup<InstPrCR>());
}

void ExprCompiler::absorb(const NumericArrayExpr &e) {
  bool useDim(arrayDim); // save state
  bool useRef(arrayRef); // save state
  arrayRef = false;
  e.indices->soak(this);
  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      int n = static_cast<int>(e.indices->operands.size());
      auto count = makeup<AddressModeImm>(false, n);

      auto firstReg =
          makeup<AddressModeReg>(result->getRegister() - n + 1, DataType::Int);

      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto arrLabel = (symbol.isFloat ? "FLTARR_" : "INTARR_") + symbol.name;
      result = makeup<AddressModeExt>(dataType, arrLabel);

      // Slower than using nested ternary comparison operators but
      // this is considerably easier on the eyes...

      std::string tag = useDim ? "Dim" : useRef ? "Ref" : "Val";
      tag += n < 6 ? std::to_string(n) : std::string("");

      auto inst =
          tag == "Dim1"   ? makeupInstMv<InstArrayDim1>(firstReg, result)
          : tag == "Ref1" ? makeupInstMv<InstArrayRef1>(firstReg, result)
          : tag == "Val1" ? makeupInstMv<InstArrayVal1>(firstReg, result)
          : tag == "Dim2" ? makeupInstMv<InstArrayDim2>(firstReg, result)
          : tag == "Ref2" ? makeupInstMv<InstArrayRef2>(firstReg, result)
          : tag == "Val2" ? makeupInstMv<InstArrayVal2>(firstReg, result)
          : tag == "Dim3" ? makeupInstMv<InstArrayDim3>(firstReg, result)
          : tag == "Ref3" ? makeupInstMv<InstArrayRef3>(firstReg, result)
          : tag == "Val3" ? makeupInstMv<InstArrayVal3>(firstReg, result)
          : tag == "Dim4" ? makeupInstMv<InstArrayDim4>(firstReg, result)
          : tag == "Ref4" ? makeupInstMv<InstArrayRef4>(firstReg, result)
          : tag == "Val4" ? makeupInstMv<InstArrayVal4>(firstReg, result)
          : tag == "Dim5" ? makeupInstMv<InstArrayDim5>(firstReg, result)
          : tag == "Ref5" ? makeupInstMv<InstArrayRef5>(firstReg, result)
          : tag == "Val5" ? makeupInstMv<InstArrayVal5>(firstReg, result)
          : tag == "Dim"  ? makeupInstMv<InstArrayDim>(firstReg, result, count)
          : tag == "Ref"  ? makeupInstMv<InstArrayRef>(firstReg, result, count)
                          : makeupInstMv<InstArrayVal>(firstReg, result, count);

      result = queue.append(mv(inst));
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
      auto count = makeup<AddressModeImm>(false, n);

      auto firstReg =
          makeup<AddressModeReg>(result->getRegister() - n + 1, DataType::Int);

      auto dataType = DataType::Str;
      auto arrLabel = "STRARR_" + symbol.name;
      result = makeup<AddressModeExt>(dataType, arrLabel);

      // Slower than using nested ternary comparison operators but
      // this is considerably easier on the eyes...

      std::string tag = useDim ? "Dim" : useRef ? "Ref" : "Val";
      tag += n < 6 ? std::to_string(n) : std::string("");

      auto inst =
          tag == "Dim1"   ? makeupInstMv<InstArrayDim1>(firstReg, result)
          : tag == "Ref1" ? makeupInstMv<InstArrayRef1>(firstReg, result)
          : tag == "Val1" ? makeupInstMv<InstArrayVal1>(firstReg, result)
          : tag == "Dim2" ? makeupInstMv<InstArrayDim2>(firstReg, result)
          : tag == "Ref2" ? makeupInstMv<InstArrayRef2>(firstReg, result)
          : tag == "Val2" ? makeupInstMv<InstArrayVal2>(firstReg, result)
          : tag == "Dim3" ? makeupInstMv<InstArrayDim3>(firstReg, result)
          : tag == "Ref3" ? makeupInstMv<InstArrayRef3>(firstReg, result)
          : tag == "Val3" ? makeupInstMv<InstArrayVal3>(firstReg, result)
          : tag == "Dim4" ? makeupInstMv<InstArrayDim4>(firstReg, result)
          : tag == "Ref4" ? makeupInstMv<InstArrayRef4>(firstReg, result)
          : tag == "Val4" ? makeupInstMv<InstArrayVal4>(firstReg, result)
          : tag == "Dim5" ? makeupInstMv<InstArrayDim5>(firstReg, result)
          : tag == "Ref5" ? makeupInstMv<InstArrayRef5>(firstReg, result)
          : tag == "Val5" ? makeupInstMv<InstArrayVal5>(firstReg, result)
          : tag == "Dim"  ? makeupInstMv<InstArrayDim>(firstReg, result, count)
          : tag == "Ref"  ? makeupInstMv<InstArrayRef>(firstReg, result, count)
                          : makeupInstMv<InstArrayVal>(firstReg, result, count);

      result = queue.append(mv(inst));
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
  result = queue.load(mv(result));

  ConstInspector constInspector;
  if (!constInspector.isEqual(e.count.get(), 0)) {
    auto dest = result->clone();
    e.count->soak(this);
    result = queue.append(
        makeup<InstShift>(dest->clone(), dest->clone(), mv(result)));
  }
}

void ExprCompiler::absorb(const ComplementedExpr &e) {
  e.expr->soak(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstCom>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const SgnExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstSgn>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const IntExpr &e) {
  e.expr->soak(this);
  result->castToInt();
}

void ExprCompiler::absorb(const AbsExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstAbs>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const SqrExpr &e) {
  e.expr->soak(this);
  result = queue.load(mv(result));
  auto dest = result->clone();
  result = queue.append(makeup<InstSqr>(mv(dest), mv(result)));
  queue.reserve(2); // allocate two phantom regs for guess and division
}

void ExprCompiler::absorb(const ExpExpr &e) {
  e.expr->soak(this);
  result = queue.load(mv(result));
  auto dest = result->clone();
  result = queue.append(makeup<InstExp>(mv(dest), mv(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::absorb(const LogExpr &e) {
  e.expr->soak(this);
  result = queue.load(mv(result));
  auto dest = result->clone();
  result = queue.append(makeup<InstLog>(mv(dest), mv(result)));
  queue.reserve(3); // allocate three phantom regs for target and exp
}

void ExprCompiler::absorb(const SinExpr &e) {
  e.expr->soak(this);
  result = queue.load(mv(result));
  auto dest = result->clone();
  result = queue.append(makeup<InstSin>(mv(dest), mv(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::absorb(const CosExpr &e) {
  e.expr->soak(this);
  result = queue.load(mv(result));
  auto dest = result->clone();
  result = queue.append(makeup<InstCos>(mv(dest), mv(result)));
  queue.reserve(1); // allocate phantom reg for division
}

void ExprCompiler::absorb(const TanExpr &e) {
  e.expr->soak(this);
  result = queue.load(mv(result));
  auto dest = result->clone();
  result = queue.append(makeup<InstTan>(mv(dest), mv(result)));
  queue.reserve(2); // allocate two phantom regs for sin and cos.
}

void ExprCompiler::absorb(const RndExpr &e) {
  e.expr->soak(this);
  result->castToInt();

  // make result int when result is integer greater than 0.
  ConstInspector constInspector;
  if (constInspector.isPositive(e.expr.get())) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(makeup<InstIRnd>(mv(dest), mv(result)));
  } else {
    auto dest = queue.alloc(result->clone());
    result = queue.append(makeup<InstRnd>(mv(dest), mv(result)));
  }
}

void ExprCompiler::absorb(const PeekExpr &e) {
  e.expr->soak(this);

  result->castToInt();

  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstPeek>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const LenExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstLen>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const StrExpr &e) {
  e.expr->soak(this);
  auto reg = makeup<AddressModeReg>(
      result->isRegister() ? result->getRegister() : queue.allocRegister(),
      DataType::Str);
  result = queue.append(makeup<InstStr>(mv(reg), mv(result)));
}

void ExprCompiler::absorb(const ValExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstVal>(mv(dest), mv(result)));

  IsChar isChar;
  if (e.expr->check(&isChar)) {
    result->castToInt();
  }
}

void ExprCompiler::absorb(const AscExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstAsc>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const ChrExpr &e) {
  e.expr->soak(this);
  result->castToInt();
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstChr>(mv(dest), mv(result)));
  if (result->dataType != DataType::Str) {
    exit(1);
  }
}

void ExprCompiler::absorb(const RelationalExpr &e) {
  up<AddressMode> reg;
  up<AddressMode> lhs;

  auto initRegAndLhs = [this, &reg, &lhs](const Expr *elhs, const Expr *erhs) {
    elhs->soak(this);
    if (result->isExtended() && erhs->isVar()) {
      lhs = mv(result);
      erhs->soak(this);
      reg = queue.alloc(result->clone());
      result = makeup<AddressModeDex>(result->dataType, result->vsymbol());
    } else {
      lhs = queue.load(mv(result));
      reg = lhs->clone();
      erhs->soak(this);
    }
  };

  if (e.comparator == "<" || e.comparator == ">=" || e.comparator == "=>") {
    initRegAndLhs(e.lhs.get(), e.rhs.get());
    result = queue.append(e.comparator == "<"
                              ? makeupInstMv<InstLdLt>(reg, lhs, result)
                              : makeupInstMv<InstLdGe>(reg, lhs, result));
  } else if (e.comparator == ">" || e.comparator == "<=" ||
             e.comparator == "=<") {
    initRegAndLhs(e.rhs.get(), e.lhs.get());
    result = queue.append(e.comparator == ">"
                              ? makeupInstMv<InstLdLt>(reg, lhs, result)
                              : makeupInstMv<InstLdGe>(reg, lhs, result));
  } else {
    initRegAndLhs(e.lhs.get(), e.rhs.get());
    result = queue.append(e.comparator == "="
                              ? makeupInstMv<InstLdEq>(reg, lhs, result)
                              : makeupInstMv<InstLdNe>(reg, lhs, result));
  }
}

void ExprCompiler::absorb(const LeftExpr &e) {
  e.str->soak(this);
  auto reg = queue.load(mv(result));
  e.len->soak(this);
  result->castToInt();
  result =
      queue.append(makeup<InstLeft>(reg->clone(), reg->clone(), mv(result)));
}

void ExprCompiler::absorb(const RightExpr &e) {
  e.str->soak(this);
  auto reg = queue.load(mv(result));
  e.len->soak(this);
  result->castToInt();
  result =
      queue.append(makeup<InstRight>(reg->clone(), reg->clone(), mv(result)));
}

void ExprCompiler::absorb(const MidExpr &e) {
  e.str->soak(this);
  auto reg = queue.load(mv(result));
  e.start->soak(this);
  result->castToInt();
  if (e.len) {
    queue.load(mv(result));
    e.len->soak(this);
    result->castToInt();
    result =
        queue.append(makeup<InstMidT>(reg->clone(), reg->clone(), mv(result)));
  } else {
    result =
        queue.append(makeup<InstMid>(reg->clone(), reg->clone(), mv(result)));
  }
}

void ExprCompiler::absorb(const PointExpr &e) {
  e.x->soak(this);
  result->castToInt();
  auto reg = queue.load(mv(result));
  e.y->soak(this);
  result->castToInt();
  result =
      queue.append(makeup<InstPoint>(reg->clone(), reg->clone(), mv(result)));
}

void ExprCompiler::absorb(const InkeyExpr & /*expr*/) {
  result = makeup<AddressModeReg>(queue.allocRegister(), DataType::Str);
  result = queue.append(makeup<InstInkey>(mv(result)));
}

void ExprCompiler::absorb(const MemExpr & /*expr*/) {
  result = makeup<AddressModeReg>(queue.allocRegister(), DataType::Int);
  result = queue.append(makeup<InstMem>(mv(result)));
}

void ExprCompiler::absorb(const TimerExpr & /*expr*/) {
  result = makeup<AddressModeReg>(queue.allocRegister(), DataType::Int);
  result = queue.append(makeup<InstTimer>(mv(result)));
}

void ExprCompiler::absorb(const PosExpr & /*expr*/) {
  result = makeup<AddressModeReg>(queue.allocRegister(), DataType::Int);
  result = queue.append(makeup<InstPos>(mv(result)));
}

void ExprCompiler::absorb(const PeekWordExpr &e) {
  e.expr->soak(this);

  result->castToInt();

  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstPeekWord>(mv(dest), mv(result)));
}

// helper function for AdditiveExpr visitor
//
// returns true if any of the operands gets
// returned in a register
static bool needsAlloc(const std::vector<up<NumericExpr>> &operands) {
  ConstInspector constInspector;

  bool allocated = false;
  for (auto &operand : operands) {
    allocated |= !operand->isVar() && !operand->constify(&constInspector);
  }

  return allocated;
}

// helper function for AdditiveExpr visitor
//
// call with InstInc, InstDec, InstAdd when supplying with an addend
// call with InstDec, InstInc, InstSub when supplying with a subtrahend
// result guaranteed to be in a register
template <typename TposOne, typename TnegOne, typename TaddSub>
static void addSub(ExprCompiler *that, const NumericExpr *operand,
                   up<AddressMode> &reg) {
  ConstInspector constInspector;

  auto &result = that->result;
  auto &queue = that->queue;

  auto opval = operand->constify(&constInspector);
  if (opval && *opval == 1) {
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<TposOne>(reg->clone(), mv(result)));
  } else if (opval && *opval == -1) {
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<TnegOne>(reg->clone(), mv(result)));
  } else if (result->isExtended() && operand->isVar()) {
    auto svresult = result->clone();
    reg = queue.alloc(mv(result));
    operand->soak(that);
    result = makeup<AddressModeDex>(result->dataType, result->vsymbol());
    result = queue.append(makeup<TaddSub>(mv(reg), mv(svresult), mv(result)));
  } else if ((result->isImmediate() && operand->isVar()) ||
             (result->isExtended() && opval && FixedPoint(*opval).isWord())) {
    auto svresult = result->clone();
    reg = queue.alloc(mv(result));
    operand->soak(that);
    result = queue.append(makeup<TaddSub>(mv(reg), mv(svresult), mv(result)));
  } else {
    reg = queue.load(mv(result));
    operand->soak(that);
    result =
        queue.append(makeup<TaddSub>(reg->clone(), reg->clone(), mv(result)));
  }
}

// helper function for AdditiveExpr visitor
//
// result not guaranteed to be in a register
static void addDelayed(ExprCompiler *that,
                       const std::vector<up<NumericExpr>> &operands) {
  up<AddressMode> reg;

  bool needLoad = true;
  for (auto &operand : operands) {
    if (needLoad) {
      operand->soak(that);
      needLoad = false;
    } else {
      addSub<InstInc, InstDec, InstAdd>(that, operand.get(), reg);
    }
  }
}

// helper function for AdditiveExpr visitor
//
// result guaranteed to be in a register
static void addNow(ExprCompiler *that,
                   std::vector<up<NumericExpr>>::const_iterator iOp,
                   std::vector<up<NumericExpr>>::const_iterator iOpEnd) {
  up<AddressMode> reg;

  while (++iOp != iOpEnd) {
    addSub<InstInc, InstDec, InstAdd>(that, iOp->get(), reg);
  }
}

// result guaranteed to be in a register
static void subNow(ExprCompiler *that,
                   const std::vector<up<NumericExpr>> &invoperands) {
  up<AddressMode> reg;

  for (auto &invoperand : invoperands) {
    addSub<InstDec, InstInc, InstSub>(that, invoperand.get(), reg);
  }
}

void ExprCompiler::absorb(const AdditiveExpr &e) {
  up<AddressMode> reg;

  if (e.operands.size() < 2 && e.invoperands.empty()) {
    fprintf(stderr, "internal error: null additive expression\n");
    exit(1);
  }

  if (e.operands.empty()) {
    // all subtrahends
    addDelayed(this, e.invoperands);
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<InstNeg>(reg->clone(), mv(result)));
    return;
  }

  if (needsAlloc(e.operands) || !needsAlloc(e.invoperands)) {
    // avoid reverse subtractions if not needed
    addDelayed(this, e.operands);
    subNow(this, e.invoperands);
    return;
  }

  // add up all the subtrahends via the delayed add
  addDelayed(this, e.invoperands);

  // we know from prior needsAlloc check the result
  // gets into a register anyway
  reg = mv(result);

  // reverse-subtract result from the first addend
  auto iOp = e.operands.cbegin();
  (*iOp)->soak(this);
  result =
      queue.append(makeup<InstRSub>(reg->clone(), reg->clone(), mv(result)));

  // add remaining addends
  addNow(this, iOp, e.operands.end());
}

void ExprCompiler::absorb(const PowerExpr &e) {
  e.base->soak(this);
  auto reg = queue.load(mv(result));
  queue.reserve(3);
  e.exponent->soak(this);
  result =
      queue.append(makeup<InstPow>(reg->clone(), reg->clone(), mv(result)));
}

void ExprCompiler::absorb(const IntegerDivisionExpr &e) {
  // get numerator
  e.dividend->soak(this);

  ConstInspector constInspector;
  auto c = e.divisor->constify(&constInspector);
  if (!result->isFloat() && c && (*c == 5 || *c == 3)) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(*c == 3 ? makeupInstMv<InstIDiv3>(dest, result)
                                  : makeupInstMv<InstIDiv5>(dest, result));
  } else if (!result->isFloat() && c && *c < 256 && is5Smooth(*c)) {
    auto reg = queue.load(mv(result));
    e.divisor->soak(this);
    result = queue.append(
        makeup<InstIDiv5S>(reg->clone(), reg->clone(), mv(result)));
  } else {
    auto reg = queue.load(mv(result));
    queue.reserve(1);
    e.divisor->soak(this);
    result =
        queue.append(makeup<InstIDiv>(reg->clone(), reg->clone(), mv(result)));
  }
}

void ExprCompiler::absorb(const MultiplicativeExpr &e) {
  ConstInspector constInspector;
  up<AddressMode> reg;
  bool needLoad = true;
  if (e.operands.empty()) { // all divisions. multiply all then reciprocate.
    for (auto &invoperand : e.invoperands) {
      if (needLoad) {
        invoperand->soak(this);
        needLoad = false;
      } else if (constInspector.isEqual(invoperand.get(), 3)) {
        reg = queue.alloc(result->clone());
        result = queue.append(makeup<InstMul3>(reg->clone(), mv(result)));
      } else {
        reg = queue.load(mv(result));
        invoperand->soak(this);
        result = queue.append(
            makeup<InstMul>(reg->clone(), reg->clone(), mv(result)));
      }
    }
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<InstInv>(reg->clone(), mv(result)));
  } else {
    for (auto &operand : e.operands) {
      if (needLoad) {
        operand->soak(this);
        needLoad = false;
      } else if (constInspector.isEqual(operand.get(), 3)) {
        reg = queue.alloc(result->clone());
        result = queue.append(makeup<InstMul3>(reg->clone(), mv(result)));
      } else {
        reg = queue.load(mv(result));
        operand->soak(this);
        result = queue.append(
            makeup<InstMul>(reg->clone(), reg->clone(), mv(result)));
      }
    }
    for (auto &invoperand : e.invoperands) {
      reg = queue.load(mv(result));
      invoperand->soak(this);
      result =
          queue.append(makeup<InstDiv>(reg->clone(), reg->clone(), mv(result)));
      queue.reserve(1); // need additional phantom reg for div
    }
  }
}

void ExprCompiler::absorb(const OrExpr &e) {
  up<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->soak(this);
      result->castToInt();
      reg = queue.load(mv(result));
      needLoad = false;
    } else {
      operand->soak(this);
      result->castToInt();
      result =
          queue.append(makeup<InstOr>(reg->clone(), reg->clone(), mv(result)));
    }
  }
}

void ExprCompiler::absorb(const AndExpr &e) {
  up<AddressMode> reg;
  bool needLoad = true;
  for (auto &operand : e.operands) {
    if (needLoad) {
      operand->soak(this);
      result->castToInt();
      reg = queue.load(mv(result));
      needLoad = false;
    } else {
      operand->soak(this);
      result->castToInt();
      result =
          queue.append(makeup<InstAnd>(reg->clone(), reg->clone(), mv(result)));
    }
  }
}
