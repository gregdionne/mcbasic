// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "uninitsymbolpruner.hpp"

template <typename T> void prune(T &expr, ExprUninitSymbolPruner *that) {
  that->reset();
  expr->mutate(that);
  if (that->isMissing()) {
    that->reset();
    if (expr->isString()) {
      expr = makeup<StringConstantExpr>("");
    } else {
      expr = makeup<NumericConstantExpr>(0);
    }
  }
}

template <typename T> void numPrune(T &expr, ExprUninitSymbolPruner *that) {
  that->reset();
  expr->mutate(that);
  if (that->isMissing()) {
    that->reset();
    expr = makeup<NumericConstantExpr>(0);
  }
}

template <typename T> void strPrune(T &expr, ExprUninitSymbolPruner *that) {
  that->reset();
  expr->mutate(that);
  if (that->isMissing()) {
    that->reset();
    expr = makeup<StringConstantExpr>("");
  }
}

void UninitSymbolPruner::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void UninitSymbolPruner::operate(Line &l) {
  StatementUninitSymbolPruner ss(symbolTable, l.lineNumber, announcer);
  for (auto &statement : l.statements) {
    statement->mutate(&ss);
  }
}

void ExprUninitSymbolPruner::mutate(PrintCRExpr & /*expr*/) {}

void ExprUninitSymbolPruner::mutate(PrintSpaceExpr & /*expr*/) {}

void ExprUninitSymbolPruner::mutate(PrintCommaExpr & /*expr*/) {}

void ExprUninitSymbolPruner::mutate(NumericConstantExpr & /*expr*/) {}

void ExprUninitSymbolPruner::mutate(StringConstantExpr & /*expr*/) {}

void ExprUninitSymbolPruner::mutate(NumericVariableExpr &e) {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      return;
    }
  }

  missing = true;

  announcer.start(lineNumber);
  announcer.finish("\"%s\" not found in variable table.  Is it ever "
                   "initialized?",
                   e.varname.c_str());
}

void ExprUninitSymbolPruner::mutate(StringVariableExpr &e) {
  for (auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      return;
    }
  }

  missing = true;

  announcer.start(lineNumber);
  announcer.finish("\"%s$\" not found in variable table.  Is it ever "
                   "initialized?",
                   e.varname.c_str());
}

void ExprUninitSymbolPruner::mutate(PowerExpr &e) {
  numPrune(e.base, this);
  numPrune(e.exponent, this);
}

void ExprUninitSymbolPruner::mutate(IntegerDivisionExpr &e) {
  numPrune(e.dividend, this);
  numPrune(e.divisor, this);
}

void ExprUninitSymbolPruner::mutate(NaryNumericExpr &e) {
  if (!e.operands.empty()) {
    for (auto &operand : e.operands) {
      numPrune(operand, this);
    }
  }

  if (!e.invoperands.empty()) {
    for (auto &invoperand : e.invoperands) {
      numPrune(invoperand, this);
    }
  }
}

void ExprUninitSymbolPruner::mutate(AdditiveExpr &e) {
  e.NaryNumericExpr::mutate(this);
}

void ExprUninitSymbolPruner::mutate(MultiplicativeExpr &e) {
  e.NaryNumericExpr::mutate(this);
}

void ExprUninitSymbolPruner::mutate(AndExpr &e) {
  e.NaryNumericExpr::mutate(this);
}

void ExprUninitSymbolPruner::mutate(OrExpr &e) {
  e.NaryNumericExpr::mutate(this);
}

void ExprUninitSymbolPruner::mutate(StringConcatenationExpr &e) {
  for (auto &operand : e.operands) {
    strPrune(operand, this);
  }
}

void ExprUninitSymbolPruner::mutate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    numPrune(operand, this);
  }
}

void ExprUninitSymbolPruner::mutate(PrintTabExpr &e) {
  numPrune(e.tabstop, this);
}

void ExprUninitSymbolPruner::mutate(NumericArrayExpr &e) {
  // indices are never pruned, but their contents can be
  e.indices->mutate(this);

  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      return;
    }
  }

  missing = true;

  announcer.start(lineNumber);
  announcer.finish("\"%s()\" not found in variable table.  Is it ever "
                   "initialized?",
                   e.varexp->varname.c_str());
}

void ExprUninitSymbolPruner::mutate(StringArrayExpr &e) {
  // indices are never pruned, but their contents can be
  e.indices->mutate(this);

  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      return;
    }
  }

  missing = true;

  announcer.start(lineNumber);
  announcer.finish("\"%s$()\" not found in variable table.  Is it ever "
                   "initialized?",
                   e.varexp->varname.c_str());
}

void ExprUninitSymbolPruner::mutate(ShiftExpr &e) {
  numPrune(e.expr, this);
  numPrune(e.count, this);
}

void ExprUninitSymbolPruner::mutate(ComplementedExpr &e) {
  numPrune(e.expr, this);
}

void ExprUninitSymbolPruner::mutate(SgnExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(IntExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(AbsExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(RndExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(PeekExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(LenExpr &e) { strPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(StrExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(ValExpr &e) { strPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(AscExpr &e) { strPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(ChrExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(CosExpr &e) { numPrune(e.expr, this); }
void ExprUninitSymbolPruner::mutate(SinExpr &e) { numPrune(e.expr, this); }
void ExprUninitSymbolPruner::mutate(TanExpr &e) { numPrune(e.expr, this); }
void ExprUninitSymbolPruner::mutate(ExpExpr &e) { numPrune(e.expr, this); }
void ExprUninitSymbolPruner::mutate(LogExpr &e) { numPrune(e.expr, this); }
void ExprUninitSymbolPruner::mutate(SqrExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(MemExpr & /*e*/) {}
void ExprUninitSymbolPruner::mutate(PeekWordExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(PosExpr & /*e*/) {}

void ExprUninitSymbolPruner::mutate(InkeyExpr & /*e*/) {}

void ExprUninitSymbolPruner::mutate(TimerExpr & /*e*/) {}

void ExprUninitSymbolPruner::mutate(RelationalExpr &e) {
  prune(e.lhs, this);
  prune(e.rhs, this);
}

void ExprUninitSymbolPruner::mutate(LeftExpr &e) {
  strPrune(e.str, this);
  numPrune(e.len, this);
}

void ExprUninitSymbolPruner::mutate(RightExpr &e) {
  strPrune(e.str, this);
  numPrune(e.len, this);
}

void ExprUninitSymbolPruner::mutate(MidExpr &e) {
  strPrune(e.str, this);
  numPrune(e.start, this);
  if (e.len) {
    numPrune(e.len, this);
  }
}

void ExprUninitSymbolPruner::mutate(PointExpr &e) {
  numPrune(e.x, this);
  numPrune(e.y, this);
}

void ExprUninitSymbolPruner::mutate(SquareExpr &e) { numPrune(e.expr, this); }

void ExprUninitSymbolPruner::mutate(FractExpr &e) { numPrune(e.expr, this); }

void StatementUninitSymbolPruner::mutate(Rem & /*s*/) {}

void StatementUninitSymbolPruner::mutate(For &s) {
  // iteration variable cannot be pruned
  numPrune(s.from, that);
  numPrune(s.to, that);
  if (s.step) {
    numPrune(s.step, that);
  }
}

void StatementUninitSymbolPruner::mutate(Go & /*s*/) {}

void StatementUninitSymbolPruner::mutate(When &s) {
  numPrune(s.predicate, that);
}

void StatementUninitSymbolPruner::mutate(Data & /*s*/) {}

void StatementUninitSymbolPruner::mutate(If &s) {
  numPrune(s.predicate, that);
  for (auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementUninitSymbolPruner::mutate(Print &s) {
  if (s.at) {
    numPrune(s.at, that);
  }
  for (auto &expr : s.printExpr) {
    strPrune(expr, that);
  }
}

void StatementUninitSymbolPruner::mutate(Input &s) {
  if (s.prompt) {
    strPrune(s.prompt, that);
  }
  for (auto &variable : s.variables) {
    prune(variable, that);
  }
}

void StatementUninitSymbolPruner::mutate(End & /*s*/) {}

void StatementUninitSymbolPruner::mutate(On &s) {
  numPrune(s.branchIndex, that);
}

void StatementUninitSymbolPruner::mutate(Next &s) {
  for (auto &variable : s.variables) {
    // for completeness sake only
    variable->mutate(that);
  }
}

void StatementUninitSymbolPruner::mutate(Dim &s) {
  for (auto &variable : s.variables) {
    variable->mutate(that);
  }
}

void StatementUninitSymbolPruner::mutate(Read &s) {
  for (auto &variable : s.variables) {
    variable->mutate(that);
  }
}

void StatementUninitSymbolPruner::mutate(Let &s) {
  s.lhs->mutate(that);
  prune(s.rhs, that);
}

void StatementUninitSymbolPruner::mutate(Accum &s) {
  s.lhs->mutate(that);
  numPrune(s.rhs, that);
}

void StatementUninitSymbolPruner::mutate(Decum &s) {
  s.lhs->mutate(that);
  numPrune(s.rhs, that);
}

void StatementUninitSymbolPruner::mutate(Necum &s) {
  s.lhs->mutate(that);
  numPrune(s.rhs, that);
}

void StatementUninitSymbolPruner::mutate(Eval &s) {
  for (auto &operand : s.operands) {
    prune(operand, that);
  }
}

void StatementUninitSymbolPruner::mutate(Poke &s) {
  numPrune(s.dest, that);
  numPrune(s.val, that);
}

void StatementUninitSymbolPruner::mutate(Run & /*s*/) {}

void StatementUninitSymbolPruner::mutate(Restore & /*s*/) {}

void StatementUninitSymbolPruner::mutate(Return & /*s*/) {}

void StatementUninitSymbolPruner::mutate(Stop & /*s*/) {}

void StatementUninitSymbolPruner::mutate(Clear &s) {
  if (s.size) {
    numPrune(s.size, that);
  }
}

void StatementUninitSymbolPruner::mutate(CLoadM &s) {
  if (s.filename) {
    strPrune(s.filename, that);
  }
  if (s.offset) {
    numPrune(s.offset, that);
  }
}

void StatementUninitSymbolPruner::mutate(CLoadStar &s) {
  if (s.filename) {
    strPrune(s.filename, that);
  }
}

void StatementUninitSymbolPruner::mutate(CSaveStar &s) {
  if (s.filename) {
    strPrune(s.filename, that);
  }
}

void StatementUninitSymbolPruner::mutate(Set &s) {
  numPrune(s.x, that);
  numPrune(s.y, that);
  if (s.c) {
    numPrune(s.c, that);
  }
}

void StatementUninitSymbolPruner::mutate(Reset &s) {
  numPrune(s.x, that);
  numPrune(s.y, that);
}

void StatementUninitSymbolPruner::mutate(Cls &s) {
  if (s.color) {
    numPrune(s.color, that);
  }
}

void StatementUninitSymbolPruner::mutate(Sound &s) {
  numPrune(s.pitch, that);
  numPrune(s.duration, that);
}

void StatementUninitSymbolPruner::mutate(Exec &s) { numPrune(s.address, that); }

void StatementUninitSymbolPruner::mutate(Error & /*s*/) {}
