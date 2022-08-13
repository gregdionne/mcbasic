// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symbolpruner.hpp"

template <typename T> void prune(T &expr, ExprSymbolPruner *that) {
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

template <typename T> void numPrune(T &expr, ExprSymbolPruner *that) {
  that->reset();
  expr->mutate(that);
  if (that->isMissing()) {
    that->reset();
    expr = makeup<NumericConstantExpr>(0);
  }
}

template <typename T> void strPrune(T &expr, ExprSymbolPruner *that) {
  that->reset();
  expr->mutate(that);
  if (that->isMissing()) {
    that->reset();
    expr = makeup<StringConstantExpr>("");
  }
}

void SymbolPruner::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void SymbolPruner::operate(Line &l) {
  StatementSymbolPruner ss(symbolTable, l.lineNumber, announcer);
  for (auto &statement : l.statements) {
    statement->mutate(&ss);
  }
}

void ExprSymbolPruner::mutate(PrintCRExpr & /*expr*/) {}

void ExprSymbolPruner::mutate(PrintSpaceExpr & /*expr*/) {}

void ExprSymbolPruner::mutate(PrintCommaExpr & /*expr*/) {}

void ExprSymbolPruner::mutate(NumericConstantExpr & /*expr*/) {}

void ExprSymbolPruner::mutate(StringConstantExpr & /*expr*/) {}

void ExprSymbolPruner::mutate(NumericVariableExpr &e) {
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

void ExprSymbolPruner::mutate(StringVariableExpr &e) {
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

void ExprSymbolPruner::mutate(PowerExpr &e) {
  numPrune(e.base, this);
  numPrune(e.exponent, this);
}

void ExprSymbolPruner::mutate(IntegerDivisionExpr &e) {
  numPrune(e.dividend, this);
  numPrune(e.divisor, this);
}

void ExprSymbolPruner::mutate(NaryNumericExpr &e) {
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

void ExprSymbolPruner::mutate(AdditiveExpr &e) {
  e.NaryNumericExpr::mutate(this);
}

void ExprSymbolPruner::mutate(MultiplicativeExpr &e) {
  e.NaryNumericExpr::mutate(this);
}

void ExprSymbolPruner::mutate(AndExpr &e) { e.NaryNumericExpr::mutate(this); }

void ExprSymbolPruner::mutate(OrExpr &e) { e.NaryNumericExpr::mutate(this); }

void ExprSymbolPruner::mutate(StringConcatenationExpr &e) {
  for (auto &operand : e.operands) {
    strPrune(operand, this);
  }
}

void ExprSymbolPruner::mutate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    numPrune(operand, this);
  }
}

void ExprSymbolPruner::mutate(PrintTabExpr &e) { numPrune(e.tabstop, this); }

void ExprSymbolPruner::mutate(NumericArrayExpr &e) {
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

void ExprSymbolPruner::mutate(StringArrayExpr &e) {
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

void ExprSymbolPruner::mutate(ShiftExpr &e) {
  numPrune(e.expr, this);
  numPrune(e.count, this);
}

void ExprSymbolPruner::mutate(ComplementedExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(SgnExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(IntExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(AbsExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(RndExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(PeekExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(LenExpr &e) { strPrune(e.expr, this); }

void ExprSymbolPruner::mutate(StrExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(ValExpr &e) { strPrune(e.expr, this); }

void ExprSymbolPruner::mutate(AscExpr &e) { strPrune(e.expr, this); }

void ExprSymbolPruner::mutate(ChrExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(CosExpr &e) { numPrune(e.expr, this); }
void ExprSymbolPruner::mutate(SinExpr &e) { numPrune(e.expr, this); }
void ExprSymbolPruner::mutate(TanExpr &e) { numPrune(e.expr, this); }
void ExprSymbolPruner::mutate(ExpExpr &e) { numPrune(e.expr, this); }
void ExprSymbolPruner::mutate(LogExpr &e) { numPrune(e.expr, this); }
void ExprSymbolPruner::mutate(SqrExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(MemExpr & /*e*/) {}
void ExprSymbolPruner::mutate(PeekWordExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::mutate(PosExpr & /*e*/) {}

void ExprSymbolPruner::mutate(InkeyExpr & /*e*/) {}

void ExprSymbolPruner::mutate(TimerExpr & /*e*/) {}

void ExprSymbolPruner::mutate(RelationalExpr &e) {
  prune(e.lhs, this);
  prune(e.rhs, this);
}

void ExprSymbolPruner::mutate(LeftExpr &e) {
  strPrune(e.str, this);
  numPrune(e.len, this);
}

void ExprSymbolPruner::mutate(RightExpr &e) {
  strPrune(e.str, this);
  numPrune(e.len, this);
}

void ExprSymbolPruner::mutate(MidExpr &e) {
  strPrune(e.str, this);
  numPrune(e.start, this);
  if (e.len) {
    numPrune(e.len, this);
  }
}

void ExprSymbolPruner::mutate(PointExpr &e) {
  numPrune(e.x, this);
  numPrune(e.y, this);
}

void ExprSymbolPruner::mutate(SquareExpr &e) { numPrune(e.expr, this); }

void StatementSymbolPruner::mutate(Rem & /*s*/) {}

void StatementSymbolPruner::mutate(For &s) {
  // iteration variable cannot be pruned
  numPrune(s.from, that);
  numPrune(s.to, that);
  if (s.step) {
    numPrune(s.step, that);
  }
}

void StatementSymbolPruner::mutate(Go & /*s*/) {}

void StatementSymbolPruner::mutate(When &s) { numPrune(s.predicate, that); }

void StatementSymbolPruner::mutate(Data & /*s*/) {}

void StatementSymbolPruner::mutate(If &s) {
  numPrune(s.predicate, that);
  for (auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementSymbolPruner::mutate(Print &s) {
  if (s.at) {
    numPrune(s.at, that);
  }
  for (auto &expr : s.printExpr) {
    strPrune(expr, that);
  }
}

void StatementSymbolPruner::mutate(Input &s) {
  if (s.prompt) {
    strPrune(s.prompt, that);
  }
  for (auto &variable : s.variables) {
    prune(variable, that);
  }
}

void StatementSymbolPruner::mutate(End & /*s*/) {}

void StatementSymbolPruner::mutate(On &s) { numPrune(s.branchIndex, that); }

void StatementSymbolPruner::mutate(Next &s) {
  for (auto &variable : s.variables) {
    // for completeness sake only
    variable->mutate(that);
  }
}

void StatementSymbolPruner::mutate(Dim &s) {
  for (auto &variable : s.variables) {
    variable->mutate(that);
  }
}

void StatementSymbolPruner::mutate(Read &s) {
  for (auto &variable : s.variables) {
    variable->mutate(that);
  }
}

void StatementSymbolPruner::mutate(Let &s) {
  s.lhs->mutate(that);
  prune(s.rhs, that);
}

void StatementSymbolPruner::mutate(Accum &s) {
  s.lhs->mutate(that);
  numPrune(s.rhs, that);
}

void StatementSymbolPruner::mutate(Decum &s) {
  s.lhs->mutate(that);
  numPrune(s.rhs, that);
}

void StatementSymbolPruner::mutate(Necum &s) {
  s.lhs->mutate(that);
  numPrune(s.rhs, that);
}

void StatementSymbolPruner::mutate(Poke &s) {
  numPrune(s.dest, that);
  numPrune(s.val, that);
}

void StatementSymbolPruner::mutate(Run & /*s*/) {}

void StatementSymbolPruner::mutate(Restore & /*s*/) {}

void StatementSymbolPruner::mutate(Return & /*s*/) {}

void StatementSymbolPruner::mutate(Stop & /*s*/) {}

void StatementSymbolPruner::mutate(Clear &s) {
  if (s.size) {
    numPrune(s.size, that);
  }
}

void StatementSymbolPruner::mutate(Set &s) {
  numPrune(s.x, that);
  numPrune(s.y, that);
  if (s.c) {
    numPrune(s.c, that);
  }
}

void StatementSymbolPruner::mutate(Reset &s) {
  numPrune(s.x, that);
  numPrune(s.y, that);
}

void StatementSymbolPruner::mutate(Cls &s) {
  if (s.color) {
    numPrune(s.color, that);
  }
}

void StatementSymbolPruner::mutate(Sound &s) {
  numPrune(s.pitch, that);
  numPrune(s.duration, that);
}

void StatementSymbolPruner::mutate(Exec &s) { numPrune(s.address, that); }

void StatementSymbolPruner::mutate(Error & /*s*/) {}
