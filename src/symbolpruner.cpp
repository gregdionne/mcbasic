// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symbolpruner.hpp"

template <typename T> void prune(T &expr, ExprSymbolPruner *that) {
  that->isMissing = false;
  expr->operate(that);
  if (that->isMissing) {
    that->isMissing = false;
    if (expr->isString()) {
      expr = std::make_unique<StringConstantExpr>("");
    } else {
      expr = std::make_unique<NumericConstantExpr>(0);
    }
  }
}

template <typename T> void numPrune(T &expr, ExprSymbolPruner *that) {
  that->isMissing = false;
  expr->operate(that);
  if (that->isMissing) {
    that->isMissing = false;
    expr = std::make_unique<NumericConstantExpr>(0);
  }
}

template <typename T> void strPrune(T &expr, ExprSymbolPruner *that) {
  that->isMissing = false;
  expr->operate(that);
  if (that->isMissing) {
    that->isMissing = false;
    expr = std::make_unique<StringConstantExpr>("");
  }
}

void SymbolPruner::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void SymbolPruner::operate(Line &l) {
  StatementSymbolPruner ss(symbolTable, l.lineNumber, warn);
  for (auto &statement : l.statements) {
    statement->operate(&ss);
  }
}

void ExprSymbolPruner::operate(NumericVariableExpr &e) {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      return;
    }
  }

  isMissing = true;

  if (warn) {
    fprintf(stderr,
            "Wuninit: line %i: \"%s\" not found in variable table.  Is it ever "
            "initialized?\n",
            lineNumber, e.varname.c_str());
  }
}

void ExprSymbolPruner::operate(StringVariableExpr &e) {
  for (auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      return;
    }
  }

  isMissing = true;

  if (warn) {
    fprintf(
        stderr,
        "Wuninit: line %i: \"%s$\" not found in variable table.  Is it ever "
        "initialized?\n",
        lineNumber, e.varname.c_str());
  }
}

void ExprSymbolPruner::operate(PowerExpr &e) {
  numPrune(e.base, this);
  numPrune(e.exponent, this);
}

void ExprSymbolPruner::operate(IntegerDivisionExpr &e) {
  numPrune(e.dividend, this);
  numPrune(e.divisor, this);
}

void ExprSymbolPruner::operate(NaryNumericExpr &e) {
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

void ExprSymbolPruner::operate(StringConcatenationExpr &e) {
  for (auto &operand : e.operands) {
    strPrune(operand, this);
  }
}

void ExprSymbolPruner::operate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    numPrune(operand, this);
  }
}

void ExprSymbolPruner::operate(PrintTabExpr &e) { numPrune(e.tabstop, this); }

void ExprSymbolPruner::operate(NumericArrayExpr &e) {
  // indices are never pruned, but their contents can be
  e.indices->operate(this);

  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      return;
    }
  }

  isMissing = true;

  if (warn) {
    fprintf(stderr,
            "Wuninit: line %i: \"%s()\" not found in array table.  Is it ever "
            "initialized?\n",
            lineNumber, e.varexp->varname.c_str());
  }
}

void ExprSymbolPruner::operate(StringArrayExpr &e) {
  // indices are never pruned, but their contents can be
  e.indices->operate(this);

  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      return;
    }
  }

  isMissing = true;

  if (warn) {
    fprintf(stderr,
            "Wuninit: line %i: \"%s$()\" not found in array table.  Is it ever "
            "initialized?\n",
            lineNumber, e.varexp->varname.c_str());
  }
}

void ExprSymbolPruner::operate(ShiftExpr &e) {
  numPrune(e.expr, this);
  numPrune(e.count, this);
}

void ExprSymbolPruner::operate(NegatedExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(ComplementedExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(SgnExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(IntExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(AbsExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(RndExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(PeekExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(LenExpr &e) { strPrune(e.expr, this); }

void ExprSymbolPruner::operate(StrExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(ValExpr &e) { strPrune(e.expr, this); }

void ExprSymbolPruner::operate(AscExpr &e) { strPrune(e.expr, this); }

void ExprSymbolPruner::operate(ChrExpr &e) { numPrune(e.expr, this); }

void ExprSymbolPruner::operate(RelationalExpr &e) {
  prune(e.lhs, this);
  prune(e.rhs, this);
}

void ExprSymbolPruner::operate(LeftExpr &e) {
  strPrune(e.str, this);
  numPrune(e.len, this);
}

void ExprSymbolPruner::operate(RightExpr &e) {
  strPrune(e.str, this);
  numPrune(e.len, this);
}

void ExprSymbolPruner::operate(MidExpr &e) {
  strPrune(e.str, this);
  numPrune(e.start, this);
  if (e.len) {
    numPrune(e.len, this);
  }
}

void ExprSymbolPruner::operate(PointExpr &e) {
  numPrune(e.x, this);
  numPrune(e.y, this);
}

void StatementSymbolPruner::operate(For &s) {
  // iteration variable cannot be pruned
  numPrune(s.from, that);
  numPrune(s.to, that);
  if (s.step) {
    numPrune(s.step, that);
  }
}

void StatementSymbolPruner::operate(When &s) { numPrune(s.predicate, that); }

void StatementSymbolPruner::operate(If &s) {
  numPrune(s.predicate, that);
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementSymbolPruner::operate(Print &s) {
  if (s.at) {
    numPrune(s.at, that);
  }
  for (auto &expr : s.printExpr) {
    strPrune(expr, that);
  }
}

void StatementSymbolPruner::operate(Input &s) {
  if (s.prompt) {
    strPrune(s.prompt, that);
  }
  for (auto &variable : s.variables) {
    prune(variable, that);
  }
}

void StatementSymbolPruner::operate(On &s) { numPrune(s.branchIndex, that); }

void StatementSymbolPruner::operate(Next &s) {
  for (auto &variable : s.variables) {
    // for completeness sake only
    variable->operate(that);
  }
}

void StatementSymbolPruner::operate(Dim &s) {
  for (auto &variable : s.variables) {
    variable->operate(that);
  }
}

void StatementSymbolPruner::operate(Read &s) {
  for (auto &variable : s.variables) {
    variable->operate(that);
  }
}

void StatementSymbolPruner::operate(Let &s) {
  s.lhs->operate(that);
  prune(s.rhs, that);
}

void StatementSymbolPruner::operate(Inc &s) {
  s.lhs->operate(that);
  numPrune(s.rhs, that);
}

void StatementSymbolPruner::operate(Dec &s) {
  s.lhs->operate(that);
  numPrune(s.rhs, that);
}

void StatementSymbolPruner::operate(Poke &s) {
  numPrune(s.dest, that);
  numPrune(s.val, that);
}

void StatementSymbolPruner::operate(Clear &s) {
  if (s.size) {
    numPrune(s.size, that);
  }
}

void StatementSymbolPruner::operate(Set &s) {
  numPrune(s.x, that);
  numPrune(s.y, that);
  if (s.c) {
    numPrune(s.c, that);
  }
}

void StatementSymbolPruner::operate(Reset &s) {
  numPrune(s.x, that);
  numPrune(s.y, that);
}

void StatementSymbolPruner::operate(Cls &s) {
  if (s.color) {
    numPrune(s.color, that);
  }
}

void StatementSymbolPruner::operate(Sound &s) {
  numPrune(s.pitch, that);
  numPrune(s.duration, that);
}
