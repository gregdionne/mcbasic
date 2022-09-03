// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symbolusagetabulator.hpp"

void SymbolUsageInspector::operate(Program &p) {

  clearUsage(symbolTable);

  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void SymbolUsageInspector::operate(Line &l) {
  StatementSymbolUsageInspector ss(symbolTable);
  for (auto &statement : l.statements) {
    statement->inspect(&ss);
  }
}

void ExprSymbolUsageTabulator::inspect(const PrintCRExpr & /*expr*/) const {}

void ExprSymbolUsageTabulator::inspect(const PrintSpaceExpr & /*expr*/) const {}

void ExprSymbolUsageTabulator::inspect(const PrintCommaExpr & /*expr*/) const {}

void ExprSymbolUsageTabulator::inspect(
    const NumericConstantExpr & /*expr*/) const {}

void ExprSymbolUsageTabulator::inspect(
    const StringConstantExpr & /*expr*/) const {}

void ExprSymbolUsageTabulator::inspect(const NumericVariableExpr &e) const {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void ExprSymbolUsageTabulator::inspect(const StringVariableExpr &e) const {
  for (auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void ExprSymbolUsageTabulator::inspect(const NumericArrayExpr &e) const {
  e.indices->inspect(this);

  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void ExprSymbolUsageTabulator::inspect(const StringArrayExpr &e) const {
  e.indices->inspect(this);

  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void ExprSymbolUsageTabulator::inspect(const PowerExpr &e) const {
  e.base->inspect(this);
  e.exponent->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const IntegerDivisionExpr &e) const {
  e.dividend->inspect(this);
  e.divisor->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const NaryNumericExpr &e) const {
  if (!e.operands.empty()) {
    for (const auto &operand : e.operands) {
      operand->inspect(this);
    }
  }

  if (!e.invoperands.empty()) {
    for (const auto &invoperand : e.invoperands) {
      invoperand->inspect(this);
    }
  }
}

void ExprSymbolUsageTabulator::inspect(const AdditiveExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const MultiplicativeExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const AndExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const OrExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const StringConcatenationExpr &e) const {
  for (const auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void ExprSymbolUsageTabulator::inspect(const ArrayIndicesExpr &e) const {
  for (const auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void ExprSymbolUsageTabulator::inspect(const PrintTabExpr &e) const {
  e.tabstop->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const ShiftExpr &e) const {
  e.expr->inspect(this);
  e.count->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const ComplementedExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const SgnExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const IntExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const AbsExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const RndExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const PeekExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const LenExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const StrExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const ValExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const AscExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const ChrExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const CosExpr &e) const {
  e.expr->inspect(this);
}
void ExprSymbolUsageTabulator::inspect(const SinExpr &e) const {
  e.expr->inspect(this);
}
void ExprSymbolUsageTabulator::inspect(const TanExpr &e) const {
  e.expr->inspect(this);
}
void ExprSymbolUsageTabulator::inspect(const ExpExpr &e) const {
  e.expr->inspect(this);
}
void ExprSymbolUsageTabulator::inspect(const LogExpr &e) const {
  e.expr->inspect(this);
}
void ExprSymbolUsageTabulator::inspect(const SqrExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const MemExpr & /*expr*/) const {}
void ExprSymbolUsageTabulator::inspect(const PeekWordExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const PosExpr & /*unused*/) const {}

void ExprSymbolUsageTabulator::inspect(const InkeyExpr & /*unused*/) const {}

void ExprSymbolUsageTabulator::inspect(const TimerExpr & /*unused*/) const {}

void ExprSymbolUsageTabulator::inspect(const RelationalExpr &e) const {
  e.lhs->inspect(this);
  e.rhs->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const LeftExpr &e) const {
  e.str->inspect(this);
  e.len->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const RightExpr &e) const {
  e.str->inspect(this);
  e.len->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const MidExpr &e) const {
  e.str->inspect(this);
  e.start->inspect(this);
  if (e.len) {
    e.len->inspect(this);
  }
}

void ExprSymbolUsageTabulator::inspect(const PointExpr &e) const {
  e.x->inspect(this);
  e.y->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const SquareExpr &e) const {
  e.expr->inspect(this);
}

void ExprSymbolUsageTabulator::inspect(const FractExpr &e) const {
  e.expr->inspect(this);
}

void StatementSymbolUsageInspector::inspect(const Rem & /*s*/) const {}

void AssignSymbolUsageInspector::inspect(const NumericArrayExpr &e) const {
  e.indices->inspect(&exprSymbolUsageTabulator);
}

void AssignSymbolUsageInspector::inspect(const StringArrayExpr &e) const {
  e.indices->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const For &s) const {
  // always mark iteration variable as used
  s.iter->inspect(&exprSymbolUsageTabulator);

  s.from->inspect(&exprSymbolUsageTabulator);
  s.to->inspect(&exprSymbolUsageTabulator);
  if (s.step) {
    s.step->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Go & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const When &s) const {
  s.predicate->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Data & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const If &s) const {
  s.predicate->inspect(&exprSymbolUsageTabulator);
  for (const auto &statement : s.consequent) {
    statement->inspect(this);
  }
}

void StatementSymbolUsageInspector::inspect(const Print &s) const {
  if (s.at) {
    s.at->inspect(&exprSymbolUsageTabulator);
  }

  for (const auto &expr : s.printExpr) {
    expr->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Input &s) const {
  if (s.prompt) {
    // for comleteness sake only
    // prompt can only be a constant string expression
    s.prompt->inspect(&exprSymbolUsageTabulator);
  }
  for (const auto &variable : s.variables) {
    // always mark INPUT variable as used
    variable->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const End & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const On &s) const {
  s.branchIndex->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Next &s) const {
  for (const auto &variable : s.variables) {
    // for completeness sake only
    // for-loop variables are always marked as used
    variable->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Dim &s) const {
  // don't mark simple variables as used
  for (const auto &variable : s.variables) {
    variable->inspect(&assignSymbolUsageInspector);
  }
}

void StatementSymbolUsageInspector::inspect(const Read &s) const {
  for (const auto &variable : s.variables) {
    // always mark READ variable as used
    variable->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Let &s) const {
  // don't mark simple lhs variables as used
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Accum &s) const {
  // don't mark simple lhs variables as used
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Decum &s) const {
  // don't mark simple lhs variables as used
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Necum &s) const {
  // don't mark simple lhs variables as used
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Eval &s) const {
  for (const auto &operand : s.operands) {
    operand->inspect(&exprSymbolUsageTabulator);
  }
}
void StatementSymbolUsageInspector::inspect(const Poke &s) const {
  s.dest->inspect(&exprSymbolUsageTabulator);
  s.val->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Run & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const Restore & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const Return & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const Stop & /*s*/) const {}

void StatementSymbolUsageInspector::inspect(const Clear &s) const {
  if (s.size) {
    s.size->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Set &s) const {
  s.x->inspect(&exprSymbolUsageTabulator);
  s.y->inspect(&exprSymbolUsageTabulator);
  if (s.c) {
    s.c->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Reset &s) const {
  s.x->inspect(&exprSymbolUsageTabulator);
  s.y->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Cls &s) const {
  if (s.color) {
    s.color->inspect(&exprSymbolUsageTabulator);
  }
}

void StatementSymbolUsageInspector::inspect(const Sound &s) const {
  s.pitch->inspect(&exprSymbolUsageTabulator);
  s.duration->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Exec &s) const {
  s.address->inspect(&exprSymbolUsageTabulator);
}

void StatementSymbolUsageInspector::inspect(const Error & /*s*/) const {}
