// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "consttabulator.hpp"

void ConstTabulator::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
  constTable.sort();
}

void ConstTabulator::operate(Line &l) {
  for (auto &statement : l.statements) {
    statement->operate(that);
  }
}

void StatementConstTabulator::operate(For &s) {
  s.from->operate(that);
  s.to->operate(that);
  if (s.step) {
    s.step->operate(that);
  }
}

void StatementConstTabulator::operate(When &s) { s.predicate->operate(that); }

void StatementConstTabulator::operate(If &s) {
  s.predicate->operate(that);
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementConstTabulator::operate(Print &s) {
  if (s.at) {
    s.at->operate(that);
  }

  for (auto &expr : s.printExpr) {
    expr->operate(that);
  }
}

void StatementConstTabulator::operate(Input &s) {
  if (s.prompt) {
    s.prompt->operate(that);
  }
}

void StatementConstTabulator::operate(On &s) { s.branchIndex->operate(that); }

void StatementConstTabulator::operate(Dim &s) {
  for (auto &variable : s.variables) {
    variable->operate(that);
  }
}

void StatementConstTabulator::operate(Inc &s) { s.rhs->operate(that); }

void StatementConstTabulator::operate(Dec &s) { s.rhs->operate(that); }

void StatementConstTabulator::operate(Let &s) { s.rhs->operate(that); }

void StatementConstTabulator::operate(Poke &s) {
  s.dest->operate(that);
  s.val->operate(that);
}

void StatementConstTabulator::operate(Clear &s) {
  if (s.size) {
    s.size->operate(that);
  }
}

void StatementConstTabulator::operate(Set &s) {
  s.x->operate(that);
  s.y->operate(that);
  if (s.c) {
    s.c->operate(that);
  }
}

void StatementConstTabulator::operate(Reset &s) {
  s.x->operate(that);
  s.y->operate(that);
}

void StatementConstTabulator::operate(Cls &s) {
  if (s.color) {
    s.color->operate(that);
  }
}

void StatementConstTabulator::operate(Sound &s) {
  s.pitch->operate(that);
  s.duration->operate(that);
}

void ExprConstTabulator::operate(StringConstantExpr & /*e*/) {
  // constTable.add(e.value);
}

void ExprConstTabulator::operate(StringArrayExpr &e) {
  e.indices->operate(this);
}

void ExprConstTabulator::operate(StringConcatenationExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
  }
}

void ExprConstTabulator::operate(LeftExpr &e) {
  e.str->operate(this);
  e.len->operate(this);
}

void ExprConstTabulator::operate(RightExpr &e) {
  e.str->operate(this);
  e.len->operate(this);
}

void ExprConstTabulator::operate(MidExpr &e) {
  e.str->operate(this);
  e.start->operate(this);
  if (e.len) {
    e.len->operate(this);
  }
}

void ExprConstTabulator::operate(LenExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(StrExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(ValExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(AscExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(ChrExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(NumericConstantExpr &e) {
  constTable.add(e.value);
}

void ExprConstTabulator::operate(NumericArrayExpr &e) {
  e.indices->operate(this);
}

void ExprConstTabulator::operate(ArrayIndicesExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
  }
}

void ExprConstTabulator::operate(ShiftExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(NegatedExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(ComplementedExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(SgnExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(IntExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(AbsExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(RndExpr &e) {
  e.expr->operate(this);
  ;
}

void ExprConstTabulator::operate(PeekExpr &e) { e.expr->operate(this); }

void ExprConstTabulator::operate(PointExpr &e) {
  e.x->operate(this);
  e.y->operate(this);
}

void ExprConstTabulator::operate(AdditiveExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
  }

  for (auto &invoperand : e.invoperands) {
    invoperand->operate(this);
  }
}

void ExprConstTabulator::operate(MultiplicativeExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
  }

  for (auto &invoperand : e.invoperands) {
    invoperand->operate(this);
  }
}

void ExprConstTabulator::operate(AndExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
  }
}

void ExprConstTabulator::operate(OrExpr &e) {
  for (auto &operand : e.operands) {
    operand->operate(this);
  }
}

void ExprConstTabulator::operate(RelationalExpr &e) {
  e.lhs->operate(this);
  e.rhs->operate(this);
}
