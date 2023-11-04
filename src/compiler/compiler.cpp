// Copyright (C) 2021-2022 Greg Dionne
// Distributed under MIT License
#include "compiler.hpp"
#include "ast/lister.hpp"
#include "consttable/fixedpoint.hpp"
#include "isnumericdatamode.hpp"
#include "optimizer/constinspector.hpp"
#include "optimizer/iscmpeqzero.hpp"
#include "optimizer/iscmpnezero.hpp"
#include "optimizer/isfloat.hpp"
#include "optimizer/nonzerobranchselector.hpp"
#include "utils/memutils.hpp"
#include <array>

static inline std::string list(const Statement *t) {
  StatementLister that;
  that.generatePredicates = false;
  t->soak(&that);
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

  for (int i : p) {
    while (n % i == 0) {
      n /= i;
    }
  }

  return n == 1;
}

InstQueue Compiler::compile(Program &p) {
  InstQueue queue;
  queue.append(makeup<InstBegin>());
  queue.append(makeup<InstClear>());

  int firstLine = 0;

  auto itLine = p.lines.begin();
  if (itLine != p.lines.end()) {
    firstLine = (*itLine)->lineNumber;
  }

  while (itLine != p.lines.end()) {
    queue.append(makeup<InstLabel>(
        makeup<AddressModeLin>((*itLine)->lineNumber),
        generateLines.isEnabled() &&
            (*itLine)->lineNumber != constants::unlistedLineNumber));

    StatementCompiler that(text, queue, firstLine, itLine,
                           generateLines.isEnabled());

    for (auto &statement : (*itLine)->statements) {
      statement->soak(&that);
    }
    ++itLine;
  }
  return queue;
}

void StatementCompiler::absorb(const Rem &s) {
  queue.append(makeup<InstComment>(list(&s)));
}

void StatementCompiler::absorb(const For &s) {
  queue.append(makeup<InstComment>(list(&s)));
  // perform LET
  queue.clearRegisters();
  ExprCompiler iter(text, queue);
  ExprCompiler from(text, queue);

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

  ExprCompiler to(text, queue);
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
    ExprCompiler step(text, queue);
    s.step->soak(&step);
    step.result = queue.load(mv(step.result));
    queue.append(makeup<InstStep>(mv(result), mv(step.result)));
  }
}

void StatementCompiler::absorb(const Go &s) {
  queue.append(makeup<InstComment>(list(&s)));

  auto lineNumber = makeup<AddressModeLbl>(s.lineNumber);

  queue.append(s.isSub ? makeupInst<InstGoSub>(mv(lineNumber), generateLines)
                       : makeupInst<InstGoTo>(mv(lineNumber)));
}

void StatementCompiler::absorb(const When &s) {
  queue.append(makeup<InstComment>(list(&s)));
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

  ExprCompiler cond(text, queue);
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
  queue.append(makeup<InstComment>(list(&s)));
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

  ExprCompiler cond(text, queue);
  predicate->soak(&cond);

  auto lineNumber =
      makeup<AddressModeLbl>((*std::next(itCurrentLine))->lineNumber);

  if (cond.result->isExtended() || cond.result->isIndirect()) {
    cond.result = queue.load(mv(cond.result));
  }

  queue.append(needEq
                   ? makeupInstMv<InstJmpIfEqual>(cond.result, lineNumber)
                   : makeupInstMv<InstJmpIfNotEqual>(cond.result, lineNumber));

  for (const auto &statement : s.consequent) {
    statement->soak(this);
  }
}

void StatementCompiler::absorb(const Data & /*statement*/) {
  queue.append(makeup<InstComment>("DATA ..."));
}

void StatementCompiler::absorb(const Print &s) {
  queue.append(makeup<InstComment>(list(&s)));
  if (s.isLPrint) {
    queue.append(makeup<InstLPrintOn>());
  }

  ExprCompiler value(text, queue);
  if (s.at) {
    queue.clearRegisters();
    s.at->soak(&value);
    value.result->castToInt(); // override
    queue.append(makeup<InstPrAt>(mv(value.result)));
  }
  for (const auto &expr : s.printExpr) {
    queue.clearRegisters();
    expr->soak(&value);
    // print if not handled by PrTab or PrComma or PrCR
    if (value.result && value.result->exists()) {
      queue.append(makeup<InstPr>(mv(value.result)));
    }
  }
  if (s.isLPrint) {
    queue.append(makeup<InstLPrintOff>());
  }
}

void StatementCompiler::absorb(const Input &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler value(text, queue);

  if (s.prompt) {
    s.prompt->soak(&value);
    queue.append(makeup<InstPr>(mv(value.result)));
  }

  queue.append(makeup<InstInputBuf>());

  for (const auto &variable : s.variables) {
    queue.clearRegisters();
    value.arrayRef = !variable->isVar();
    variable->soak(&value);
    queue.append(makeup<InstReadBuf>(mv(value.result)));
  }

  queue.append(makeup<InstIgnoreExtra>());
}

void StatementCompiler::absorb(const End &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.append(makeup<InstEnd>());
}

void StatementCompiler::absorb(const On &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler value(text, queue);
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
  queue.append(makeup<InstComment>(list(&s)));
  if (s.variables.empty()) {
    queue.append(makeup<InstNext>(generateLines));
  } else {
    for (const auto &variable : s.variables) {
      queue.clearRegisters();
      ExprCompiler var(text, queue);
      variable->soak(&var);
      queue.append(makeup<InstNextVar>(mv(var.result), generateLines));
      queue.append(makeup<InstNext>(generateLines));
    }
  }
}

void StatementCompiler::absorb(const Dim &s) {
  queue.append(makeup<InstComment>(list(&s)));
  for (const auto &variable : s.variables) {
    queue.clearRegisters();
    ExprCompiler var(text, queue);
    var.arrayDim = true;
    variable->soak(&var);
  }
}

void StatementCompiler::absorb(const Read &s) {
  queue.append(makeup<InstComment>(list(&s)));
  for (const auto &variable : s.variables) {
    queue.clearRegisters();

    ExprCompiler dest(text, queue);

    dest.arrayRef = !variable->isVar();
    variable->soak(&dest); // dest.result will be either indirect or extended.

    auto inst = makeup<InstRead>(mv(dest.result));
    inst->pureUnsigned = text.dataTable.isPureUnsigned();
    inst->pureByte = text.dataTable.isPureByte();
    inst->pureWord = text.dataTable.isPureWord();
    inst->pureNumeric = text.dataTable.isPureNumeric();
    queue.append(mv(inst));
  }
}

void StatementCompiler::absorb(const Let &s) {
  queue.append(makeup<InstComment>(list(&s)));
  ExprCompiler dest(text, queue);
  ExprCompiler value(text, queue);

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

  if (dynamic_cast<InkeyExpr *>(s.rhs.get())) {
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
  queue.append(makeup<InstComment>(list(&s)));
  ExprCompiler dest(text, queue);
  ExprCompiler value(text, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  const auto *arg = s.rhs->numExpr();

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
  queue.append(makeup<InstComment>(list(&s)));
  ExprCompiler dest(text, queue);
  ExprCompiler value(text, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  const auto *arg = s.rhs->numExpr();

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
  queue.append(makeup<InstComment>(list(&s)));
  ExprCompiler dest(text, queue);
  ExprCompiler value(text, queue);

  queue.clearRegisters();
  dest.arrayRef = !s.lhs->isVar();
  s.lhs->soak(&dest); // dest.result will be either indirect or extended.

  ConstInspector constInspector;
  const auto *arg = s.rhs->numExpr();

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

void StatementCompiler::absorb(const Eval &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler value(text, queue);

  for (const auto &operand : s.operands) {
    queue.clearRegisters();
    operand->soak(&value);
  }
}

void StatementCompiler::absorb(const Run &s) {
  auto lineNumber =
      makeup<AddressModeLbl>(s.hasLineNumber ? s.lineNumber : firstLine);

  queue.append(makeup<InstComment>(list(&s)));
  queue.append(makeup<InstClear>());
  queue.append(makeup<InstGoTo>(mv(lineNumber)));
}

void StatementCompiler::absorb(const Restore &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.append(makeup<InstRestore>());
}

void StatementCompiler::absorb(const Return &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.append(makeup<InstReturn>(generateLines));
}

void StatementCompiler::absorb(const Stop &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.append(makeup<InstStop>());
}

void StatementCompiler::absorb(const Poke &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();

  ExprCompiler dest(text, queue);
  s.dest->soak(&dest);
  dest.result->castToInt();

  ExprCompiler value(text, queue);
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
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  // arguments are ignored
  queue.append(makeup<InstClear>());
}

void StatementCompiler::absorb(const CLoadM &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();

  if (s.filename) {
    ExprCompiler f(text, queue);
    s.filename->soak(&f);
    f.result = queue.load(mv(f.result));
    if (s.offset) {
      ExprCompiler o(text, queue);
      s.offset->soak(&o);
      o.result = queue.load(mv(o.result));
      o.result->castToInt();
      queue.append(makeup<InstCLoadM>(mv(f.result), mv(o.result)));
      return;
    }
    queue.append(makeup<InstCLoadM>(mv(f.result)));
    return;
  }
  queue.append(makeup<InstCLoadM>());
}

void StatementCompiler::absorb(const CLoadStar &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();

  for (auto &symbol : text.symbolTable.numArrTable) {
    if (symbol.name == s.arrayName) {
      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto varLabel = (symbol.isFloat ? "FLTARR_" : "INTARR_") + s.arrayName;
      auto numArrName = makeup<AddressModeExt>(dataType, varLabel);
      int numDims = symbol.numDims ? symbol.numDims : 1;
      auto nDims = makeup<AddressModeImm>(false, numDims);

      if (s.filename) {
        ExprCompiler f(text, queue);
        s.filename->soak(&f);
        f.result = queue.load(mv(f.result));
        queue.append(
            makeup<InstCLoadStar>(mv(numArrName), mv(nDims), mv(f.result)));
        return;
      }

      queue.append(makeup<InstCLoadStar>(mv(numArrName), mv(nDims)));
    }
  }

  fprintf(stderr, "\"%s\" not found in array table.  Is it ever initialized?\n",
          s.arrayName.c_str());
  exit(1);
}

void StatementCompiler::absorb(const CSaveStar &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();

  for (auto &symbol : text.symbolTable.numArrTable) {
    if (symbol.name == s.arrayName) {
      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto varLabel = (symbol.isFloat ? "FLTARR_" : "INTARR_") + s.arrayName;
      auto numArrName = makeup<AddressModeExt>(dataType, varLabel);
      int numDims = symbol.numDims ? symbol.numDims : 1;
      auto nDims = makeup<AddressModeImm>(false, numDims);
      if (s.filename) {
        ExprCompiler f(text, queue);
        s.filename->soak(&f);
        f.result = queue.load(mv(f.result));
        queue.append(
            makeup<InstCSaveStar>(mv(numArrName), mv(nDims), mv(f.result)));
        return;
      }

      queue.append(makeup<InstCSaveStar>(mv(numArrName), mv(nDims)));
    }
  }

  fprintf(stderr, "\"%s\" not found in array table.  Is it ever initialized?\n",
          s.arrayName.c_str());
  exit(1);
}

void StatementCompiler::absorb(const Set &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler x(text, queue);
  ExprCompiler y(text, queue);

  s.x->soak(&x);
  x.result->castToInt();
  x.result = queue.load(mv(x.result));
  s.y->soak(&y);
  y.result->castToInt();
  y.result = queue.load(mv(y.result));
  if (s.c) {
    ExprCompiler c(text, queue);
    s.c->soak(&c);
    c.result->castToInt();
    queue.append(makeup<InstSetC>(mv(x.result), mv(y.result), mv(c.result)));
  } else {
    queue.append(makeup<InstSet>(mv(x.result), mv(y.result)));
  }
}

void StatementCompiler::absorb(const Reset &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler x(text, queue);
  ExprCompiler y(text, queue);

  s.x->soak(&x);
  x.result->castToInt();
  x.result = queue.load(mv(x.result));
  s.y->soak(&y);
  y.result->castToInt();

  queue.append(makeup<InstReset>(mv(x.result), mv(y.result)));
}

void StatementCompiler::absorb(const Cls &s) {
  queue.append(makeup<InstComment>(list(&s)));
  if (s.color) {
    queue.clearRegisters();
    ExprCompiler color(text, queue);
    s.color->soak(&color);
    color.result->castToInt();
    queue.append(makeup<InstClsN>(mv(color.result)));
  } else {
    queue.append(makeup<InstCls>());
  }
}

void StatementCompiler::absorb(const Sound &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();

  ExprCompiler pitch(text, queue);
  s.pitch->soak(&pitch);
  pitch.result->castToInt();
  pitch.result = queue.load(mv(pitch.result));

  ExprCompiler duration(text, queue);
  s.duration->soak(&duration);
  duration.result->castToInt();
  duration.result = queue.load(mv(duration.result));

  queue.append(makeup<InstSound>(mv(pitch.result), mv(duration.result)));
}

void StatementCompiler::absorb(const Exec &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler address(text, queue);
  s.address->soak(&address);
  address.result->castToInt();
  queue.append(makeup<InstExec>(mv(address.result)));
}

void StatementCompiler::absorb(const Error &s) {
  queue.append(makeup<InstComment>(list(&s)));
  queue.clearRegisters();
  ExprCompiler errorCode(text, queue);
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
  for (auto &symbol : text.symbolTable.numVarTable) {
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
  for (auto &symbol : text.symbolTable.strVarTable) {
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
  for (const auto &operand : e.operands) {
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
  for (const auto &operand : e.operands) {
    operand->soak(this);
    if (!result->isExtended() || operand.get() != e.operands.back().get()) {
      result = queue.load(mv(result));
    }
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

  int n = static_cast<int>(e.indices->operands.size());
  if (useDim || !result->isExtended() || n >= 6) {
    result = queue.load(mv(result));
  }

  auto lastReg = queue.alloc(result->clone());
  auto firstReg =
      makeup<AddressModeReg>(lastReg->getRegister() - n + 1, DataType::Int);

  auto lastArg = mv(result);
  if (lastArg->isExtended()) {
    lastArg = makeup<AddressModeDex>(lastArg->dataType, lastArg->vsymbol());
  }

  for (auto &symbol : text.symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      auto count = makeup<AddressModeImm>(false, n);

      auto dataType = symbol.isFloat ? DataType::Flt : DataType::Int;
      auto arrLabel = (symbol.isFloat ? "FLTARR_" : "INTARR_") + symbol.name;
      result = makeup<AddressModeExt>(dataType, arrLabel);

      // Slower than using nested ternary comparison operators but
      // this is considerably easier on the eyes...

      std::string tag = useDim ? "Dim" : useRef ? "Ref" : "Val";
      tag += n < 6 ? std::to_string(n) : std::string("");

      auto inst =
          tag == "Dim1" ? makeupInstMv<InstArrayDim1>(firstReg, result)
          : tag == "Ref1"
              ? makeupInstMv<InstArrayRef1>(firstReg, result, lastArg)
          : tag == "Val1"
              ? makeupInstMv<InstArrayVal1>(firstReg, result, lastArg)
          : tag == "Dim2" ? makeupInstMv<InstArrayDim2>(firstReg, result)
          : tag == "Ref2"
              ? makeupInstMv<InstArrayRef2>(firstReg, result, lastArg)
          : tag == "Val2"
              ? makeupInstMv<InstArrayVal2>(firstReg, result, lastArg)
          : tag == "Dim3" ? makeupInstMv<InstArrayDim3>(firstReg, result)
          : tag == "Ref3"
              ? makeupInstMv<InstArrayRef3>(firstReg, result, lastArg)
          : tag == "Val3"
              ? makeupInstMv<InstArrayVal3>(firstReg, result, lastArg)
          : tag == "Dim4" ? makeupInstMv<InstArrayDim4>(firstReg, result)
          : tag == "Ref4"
              ? makeupInstMv<InstArrayRef4>(firstReg, result, lastArg)
          : tag == "Val4"
              ? makeupInstMv<InstArrayVal4>(firstReg, result, lastArg)
          : tag == "Dim5" ? makeupInstMv<InstArrayDim5>(firstReg, result)
          : tag == "Ref5"
              ? makeupInstMv<InstArrayRef5>(firstReg, result, lastArg)
          : tag == "Val5"
              ? makeupInstMv<InstArrayVal5>(firstReg, result, lastArg)
          : tag == "Dim" ? makeupInstMv<InstArrayDim>(firstReg, result, count)
          : tag == "Ref" ? makeupInstMv<InstArrayRef>(firstReg, result, count)
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

  int n = static_cast<int>(e.indices->operands.size());
  if (useDim || !result->isExtended() || n >= 6) {
    result = queue.load(mv(result));
  }

  auto lastReg = queue.alloc(result->clone());
  auto firstReg =
      makeup<AddressModeReg>(lastReg->getRegister() - n + 1, DataType::Int);

  auto lastArg = mv(result);
  if (lastArg->isExtended()) {
    lastArg = makeup<AddressModeDex>(lastArg->dataType, lastArg->vsymbol());
  }

  for (auto &symbol : text.symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      auto count = makeup<AddressModeImm>(false, n);

      auto dataType = DataType::Str;
      auto arrLabel = "STRARR_" + symbol.name;
      result = makeup<AddressModeExt>(dataType, arrLabel);

      // Slower than using nested ternary comparison operators but
      // this is considerably easier on the eyes...

      std::string tag = useDim ? "Dim" : useRef ? "Ref" : "Val";
      tag += n < 6 ? std::to_string(n) : std::string("");

      auto inst =
          tag == "Dim1" ? makeupInstMv<InstArrayDim1>(firstReg, result)
          : tag == "Ref1"
              ? makeupInstMv<InstArrayRef1>(firstReg, result, lastArg)
          : tag == "Val1"
              ? makeupInstMv<InstArrayVal1>(firstReg, result, lastArg)
          : tag == "Dim2" ? makeupInstMv<InstArrayDim2>(firstReg, result)
          : tag == "Ref2"
              ? makeupInstMv<InstArrayRef2>(firstReg, result, lastArg)
          : tag == "Val2"
              ? makeupInstMv<InstArrayVal2>(firstReg, result, lastArg)
          : tag == "Dim3" ? makeupInstMv<InstArrayDim3>(firstReg, result)
          : tag == "Ref3"
              ? makeupInstMv<InstArrayRef3>(firstReg, result, lastArg)
          : tag == "Val3"
              ? makeupInstMv<InstArrayVal3>(firstReg, result, lastArg)
          : tag == "Dim4" ? makeupInstMv<InstArrayDim4>(firstReg, result)
          : tag == "Ref4"
              ? makeupInstMv<InstArrayRef4>(firstReg, result, lastArg)
          : tag == "Val4"
              ? makeupInstMv<InstArrayVal4>(firstReg, result, lastArg)
          : tag == "Dim5" ? makeupInstMv<InstArrayDim5>(firstReg, result)
          : tag == "Ref5"
              ? makeupInstMv<InstArrayRef5>(firstReg, result, lastArg)
          : tag == "Val5"
              ? makeupInstMv<InstArrayVal5>(firstReg, result, lastArg)
          : tag == "Dim" ? makeupInstMv<InstArrayDim>(firstReg, result, count)
          : tag == "Ref" ? makeupInstMv<InstArrayRef>(firstReg, result, count)
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

  ConstInspector constInspector;
  // dbl?
  if (constInspector.isEqual(e.count.get(), 1)) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(makeup<InstDbl>(mv(dest), mv(result)));
    return;
  }

  // hlf?
  if (constInspector.isEqual(e.count.get(), -1)) {
    auto dest = queue.alloc(result->clone());
    result = queue.append(makeup<InstHlf>(mv(dest), mv(result)));
    return;
  }

  // always load expr
  result = queue.load(mv(result));

  // get shift count
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
  queue.reserve(4); // allocate four phantom regs for intermed vars
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

  // special MC-10 keypoll routine
  ConstInspector constInspector;
  result = queue.append(constInspector.isEqual(e.expr.get(), 2)
                            ? makeupInst<InstPeek2>(mv(dest))
                            : makeupInst<InstPeek>(mv(dest), mv(result)));
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

  IsFloat isFloat(text.symbolTable);
  if (!e.check(&isFloat)) {
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
    if (result->isRegister()) {
      reg = result->clone();
      lhs = mv(result);
      erhs->soak(this);
    } else if (result->isExtended()) {
      lhs = mv(result);
      erhs->soak(this);
      reg = queue.alloc(result->clone());
      if (result->isExtended()) {
        result = makeup<AddressModeDex>(result->dataType, result->vsymbol());
      }
    } else if (result->isImmediate() || result->isStack()) {
      lhs = mv(result);
      erhs->soak(this);
      reg = queue.alloc(result->clone());
    } else {
      lhs = queue.load(mv(result));
      reg = lhs->clone();
      erhs->soak(this);
    }
  };

  auto initRegAndLhsCommutative = [this, &reg, &lhs](const Expr *elhs,
                                                     const Expr *erhs) {
    elhs->soak(this);
    if (result->isRegister()) {
      reg = result->clone();
      lhs = mv(result);
      erhs->soak(this);
    } else if (result->isExtended() && erhs->isVar()) {
      lhs = mv(result);
      erhs->soak(this);
      reg = queue.alloc(result->clone());
      result = makeup<AddressModeDex>(result->dataType, result->vsymbol());
    } else if (result->isExtended()) {
      lhs = mv(result);
      erhs->soak(this);
      if (result->isRegister()) {
        reg = result->clone();
        std::swap(lhs, result);
      } else if (result->isExtended()) {
        reg = queue.alloc(result->clone());
        result = makeup<AddressModeDex>(result->dataType, result->vsymbol());
      } else {
        reg = queue.alloc(result->clone());
      }
    } else if (result->isImmediate()) {
      lhs = mv(result);
      erhs->soak(this);
      reg = queue.alloc(result->clone());
      std::swap(lhs, result);
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
    initRegAndLhsCommutative(e.lhs.get(), e.rhs.get());
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

void ExprCompiler::absorb(const SquareExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstSq>(mv(dest), mv(result)));
}

void ExprCompiler::absorb(const FractExpr &e) {
  e.expr->soak(this);
  auto dest = queue.alloc(result->clone());
  result = queue.append(makeup<InstFract>(mv(dest), mv(result)));
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
// returns true if empty or all operands resolve to an address or a constant
static bool allData(const std::vector<up<NumericExpr>> &operands) {
  IsNumericDataMode isNumericDataMode;

  bool alldata = true;
  for (const auto &operand : operands) {
    alldata &= operand->check(&isNumericDataMode);
  }

  return alldata;
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
  IsNumericDataMode isNumericDataMode;

  auto &result = that->result;
  auto &queue = that->queue;

  auto opval = operand->constify(&constInspector);
  if (opval && *opval == 1) {
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<TposOne>(reg->clone(), mv(result)));
  } else if (opval && *opval == -1) {
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<TnegOne>(reg->clone(), mv(result)));
  } else if (result->isExtended() && !opval &&
             operand->check(&isNumericDataMode)) {
    auto svresult = result->clone();
    reg = queue.alloc(mv(result));
    operand->soak(that);
    if (!result->isExtended()) {
      fprintf(stderr, "internal error: double extended\n");
      exit(1);
    }
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
  for (const auto &operand : operands) {
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

  for (const auto &invoperand : invoperands) {
    addSub<InstDec, InstInc, InstSub>(that, invoperand.get(), reg);
  }
}

void ExprCompiler::absorb(const AdditiveExpr &e) {
  up<AddressMode> reg;

  if (e.operands.size() < 2 && e.invoperands.empty()) {
    ExprLister el;
    e.soak(&el);

    fprintf(stderr, "internal error: %s null additive expression\n",
            el.result.c_str());
    exit(1);
  }

  if (e.operands.empty()) {
    // all subtrahends
    addDelayed(this, e.invoperands);
    reg = queue.alloc(result->clone());
    result = queue.append(makeup<InstNeg>(reg->clone(), mv(result)));
    return;
  }

  if (!allData(e.operands) || allData(e.invoperands)) {
    // avoid reverse subtractions if not needed
    addDelayed(this, e.operands);
    subNow(this, e.invoperands);
    return;
  }

  // add up all the subtrahends via the delayed add
  addDelayed(this, e.invoperands);

  // we know from prior allData check the result
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
    for (const auto &invoperand : e.invoperands) {
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
    for (const auto &operand : e.operands) {
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
    for (const auto &invoperand : e.invoperands) {
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
  for (const auto &operand : e.operands) {
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
  for (const auto &operand : e.operands) {
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
