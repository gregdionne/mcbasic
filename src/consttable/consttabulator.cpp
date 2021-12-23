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
    statement->inspect(that);
  }
}

void StatementConstTabulator::inspect(const For &s) const {
  s.from->inspect(that);
  s.to->inspect(that);
  if (s.step) {
    s.step->inspect(that);
  }
}

void StatementConstTabulator::inspect(const When &s) const {
  s.predicate->inspect(that);
}

void StatementConstTabulator::inspect(const If &s) const {
  s.predicate->inspect(that);
  for (auto &statement : s.consequent) {
    statement->inspect(this);
  }
}

void StatementConstTabulator::inspect(const Print &s) const {
  if (s.at) {
    s.at->inspect(that);
  }

  for (auto &expr : s.printExpr) {
    expr->inspect(that);
  }
}

void StatementConstTabulator::inspect(const Input &s) const {
  if (s.prompt) {
    s.prompt->inspect(that);
  }
}

void StatementConstTabulator::inspect(const On &s) const {
  s.branchIndex->inspect(that);
}

void StatementConstTabulator::inspect(const Dim &s) const {
  for (auto &variable : s.variables) {
    variable->inspect(that);
  }
}

void StatementConstTabulator::inspect(const Inc &s) const {
  s.rhs->inspect(that);
}

void StatementConstTabulator::inspect(const Dec &s) const {
  s.rhs->inspect(that);
}

void StatementConstTabulator::inspect(const Let &s) const {
  s.rhs->inspect(that);
}

void StatementConstTabulator::inspect(const Poke &s) const {
  s.dest->inspect(that);
  s.val->inspect(that);
}

void StatementConstTabulator::inspect(const Clear &s) const {
  if (s.size) {
    s.size->inspect(that);
  }
}

void StatementConstTabulator::inspect(const Set &s) const {
  s.x->inspect(that);
  s.y->inspect(that);
  if (s.c) {
    s.c->inspect(that);
  }
}

void StatementConstTabulator::inspect(const Reset &s) const {
  s.x->inspect(that);
  s.y->inspect(that);
}

void StatementConstTabulator::inspect(const Cls &s) const {
  if (s.color) {
    s.color->inspect(that);
  }
}

void StatementConstTabulator::inspect(const Sound &s) const {
  s.pitch->inspect(that);
  s.duration->inspect(that);
}

void ExprConstTabulator::inspect(const StringConstantExpr & /*e*/) const {
  // constTable.add(e.value);
}

void ExprConstTabulator::inspect(const StringArrayExpr &e) const {
  e.indices->inspect(this);
}

void ExprConstTabulator::inspect(const StringConcatenationExpr &e) const {
  for (auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void ExprConstTabulator::inspect(const LeftExpr &e) const {
  e.str->inspect(this);
  e.len->inspect(this);
}

void ExprConstTabulator::inspect(const RightExpr &e) const {
  e.str->inspect(this);
  e.len->inspect(this);
}

void ExprConstTabulator::inspect(const MidExpr &e) const {
  e.str->inspect(this);
  e.start->inspect(this);
  if (e.len) {
    e.len->inspect(this);
  }
}

void ExprConstTabulator::inspect(const LenExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const StrExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const ValExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const AscExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const ChrExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const NumericConstantExpr &e) const {
  constTable.add(e.value);
}

void ExprConstTabulator::inspect(const NumericArrayExpr &e) const {
  e.indices->inspect(this);
}

void ExprConstTabulator::inspect(const ArrayIndicesExpr &e) const {
  for (auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void ExprConstTabulator::inspect(const PrintTabExpr &e) const {
  e.tabstop->inspect(this);
}

void ExprConstTabulator::inspect(const ShiftExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const NegatedExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const ComplementedExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const SgnExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const IntExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const AbsExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const SqrExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const ExpExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const LogExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const SinExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const CosExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const TanExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const PeekExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const RndExpr &e) const {
  e.expr->inspect(this);
}

void ExprConstTabulator::inspect(const PointExpr &e) const {
  e.x->inspect(this);
  e.y->inspect(this);
}

void ExprConstTabulator::inspect(const AdditiveExpr &e) const {
  for (auto &operand : e.operands) {
    operand->inspect(this);
  }

  for (auto &invoperand : e.invoperands) {
    invoperand->inspect(this);
  }
}

void ExprConstTabulator::inspect(const PowerExpr &e) const {
  e.base->inspect(this);
  e.exponent->inspect(this);
}

void ExprConstTabulator::inspect(const IntegerDivisionExpr &e) const {
  e.dividend->inspect(this);
  e.divisor->inspect(this);
}

void ExprConstTabulator::inspect(const MultiplicativeExpr &e) const {
  for (auto &operand : e.operands) {
    operand->inspect(this);
  }

  for (auto &invoperand : e.invoperands) {
    invoperand->inspect(this);
  }
}

void ExprConstTabulator::inspect(const AndExpr &e) const {
  for (auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void ExprConstTabulator::inspect(const OrExpr &e) const {
  for (auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void ExprConstTabulator::inspect(const RelationalExpr &e) const {
  e.lhs->inspect(this);
  e.rhs->inspect(this);
}
