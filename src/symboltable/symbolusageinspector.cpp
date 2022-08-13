// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symbolusageinspector.hpp"

void SymbolUsageInspector::clearUsage(std::vector<Symbol> &table) {
  for (auto &symbol : table) {
    symbol.isUsed = false;
  }
}

void SymbolUsageInspector::operate(Program &p) {

  clearUsage(symbolTable.numVarTable);
  clearUsage(symbolTable.strVarTable);
  clearUsage(symbolTable.numArrTable);
  clearUsage(symbolTable.strArrTable);

  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void SymbolUsageInspector::operate(Line &l) {
  SymbolUsageStatementInspector ss(symbolTable);
  for (auto &statement : l.statements) {
    statement->inspect(&ss);
  }
}

void SymbolUsageExprInspector::inspect(const PrintCRExpr & /*expr*/) const {}

void SymbolUsageExprInspector::inspect(const PrintSpaceExpr & /*expr*/) const {}

void SymbolUsageExprInspector::inspect(const PrintCommaExpr & /*expr*/) const {}

void SymbolUsageExprInspector::inspect(
    const NumericConstantExpr & /*expr*/) const {}

void SymbolUsageExprInspector::inspect(
    const StringConstantExpr & /*expr*/) const {}

void SymbolUsageExprInspector::inspect(const NumericVariableExpr &e) const {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void SymbolUsageExprInspector::inspect(const StringVariableExpr &e) const {
  for (auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void SymbolUsageExprInspector::inspect(const NumericArrayExpr &e) const {
  e.indices->inspect(this);

  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void SymbolUsageExprInspector::inspect(const StringArrayExpr &e) const {
  e.indices->inspect(this);

  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      symbol.isUsed = true;
      return;
    }
  }
}

void SymbolUsageExprInspector::inspect(const PowerExpr &e) const {
  e.base->inspect(this);
  e.exponent->inspect(this);
}

void SymbolUsageExprInspector::inspect(const IntegerDivisionExpr &e) const {
  e.dividend->inspect(this);
  e.divisor->inspect(this);
}

void SymbolUsageExprInspector::inspect(const NaryNumericExpr &e) const {
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

void SymbolUsageExprInspector::inspect(const AdditiveExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void SymbolUsageExprInspector::inspect(const MultiplicativeExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void SymbolUsageExprInspector::inspect(const AndExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void SymbolUsageExprInspector::inspect(const OrExpr &e) const {
  e.NaryNumericExpr::inspect(this);
}

void SymbolUsageExprInspector::inspect(const StringConcatenationExpr &e) const {
  for (const auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void SymbolUsageExprInspector::inspect(const ArrayIndicesExpr &e) const {
  for (const auto &operand : e.operands) {
    operand->inspect(this);
  }
}

void SymbolUsageExprInspector::inspect(const PrintTabExpr &e) const {
  e.tabstop->inspect(this);
}

void SymbolUsageExprInspector::inspect(const ShiftExpr &e) const {
  e.expr->inspect(this);
  e.count->inspect(this);
}

void SymbolUsageExprInspector::inspect(const ComplementedExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const SgnExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const IntExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const AbsExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const RndExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const PeekExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const LenExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const StrExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const ValExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const AscExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const ChrExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const CosExpr &e) const {
  e.expr->inspect(this);
}
void SymbolUsageExprInspector::inspect(const SinExpr &e) const {
  e.expr->inspect(this);
}
void SymbolUsageExprInspector::inspect(const TanExpr &e) const {
  e.expr->inspect(this);
}
void SymbolUsageExprInspector::inspect(const ExpExpr &e) const {
  e.expr->inspect(this);
}
void SymbolUsageExprInspector::inspect(const LogExpr &e) const {
  e.expr->inspect(this);
}
void SymbolUsageExprInspector::inspect(const SqrExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const MemExpr & /*expr*/) const {}
void SymbolUsageExprInspector::inspect(const PeekWordExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageExprInspector::inspect(const PosExpr & /*unused*/) const {}

void SymbolUsageExprInspector::inspect(const InkeyExpr & /*unused*/) const {}

void SymbolUsageExprInspector::inspect(const TimerExpr & /*unused*/) const {}

void SymbolUsageExprInspector::inspect(const RelationalExpr &e) const {
  e.lhs->inspect(this);
  e.rhs->inspect(this);
}

void SymbolUsageExprInspector::inspect(const LeftExpr &e) const {
  e.str->inspect(this);
  e.len->inspect(this);
}

void SymbolUsageExprInspector::inspect(const RightExpr &e) const {
  e.str->inspect(this);
  e.len->inspect(this);
}

void SymbolUsageExprInspector::inspect(const MidExpr &e) const {
  e.str->inspect(this);
  e.start->inspect(this);
  if (e.len) {
    e.len->inspect(this);
  }
}

void SymbolUsageExprInspector::inspect(const PointExpr &e) const {
  e.x->inspect(this);
  e.y->inspect(this);
}

void SymbolUsageExprInspector::inspect(const SquareExpr &e) const {
  e.expr->inspect(this);
}

void SymbolUsageStatementInspector::inspect(const Rem & /*s*/) const {}

void AssignSymbolUsageInspector::inspect(const NumericArrayExpr &e) const {
  e.indices->inspect(&symbolUsageExprInspector);
}

void AssignSymbolUsageInspector::inspect(const StringArrayExpr &e) const {
  e.indices->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const For &s) const {
  // always mark iteration variable as used
  s.iter->inspect(&symbolUsageExprInspector);

  s.from->inspect(&symbolUsageExprInspector);
  s.to->inspect(&symbolUsageExprInspector);
  if (s.step) {
    s.step->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Go & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const When &s) const {
  s.predicate->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Data & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const If &s) const {
  s.predicate->inspect(&symbolUsageExprInspector);
  for (const auto &statement : s.consequent) {
    statement->inspect(this);
  }
}

void SymbolUsageStatementInspector::inspect(const Print &s) const {
  if (s.at) {
    s.at->inspect(&symbolUsageExprInspector);
  }

  for (const auto &expr : s.printExpr) {
    expr->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Input &s) const {
  if (s.prompt) {
    // for comleteness sake only
    // prompt can only be a constant string expression
    s.prompt->inspect(&symbolUsageExprInspector);
  }
  for (const auto &variable : s.variables) {
    // always mark INPUT variable as used
    variable->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const End & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const On &s) const {
  s.branchIndex->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Next &s) const {
  for (const auto &variable : s.variables) {
    // for completeness sake only
    // for-loop variables are always marked as used
    variable->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Dim &s) const {
  for (const auto &variable : s.variables) {
    variable->inspect(&assignSymbolUsageInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Read &s) const {
  for (const auto &variable : s.variables) {
    // always mark READ variable as used
    variable->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Let &s) const {
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Accum &s) const {
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Decum &s) const {
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Necum &s) const {
  s.lhs->inspect(&assignSymbolUsageInspector);
  s.rhs->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Poke &s) const {
  s.dest->inspect(&symbolUsageExprInspector);
  s.val->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Run & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const Restore & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const Return & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const Stop & /*s*/) const {}

void SymbolUsageStatementInspector::inspect(const Clear &s) const {
  if (s.size) {
    s.size->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Set &s) const {
  s.x->inspect(&symbolUsageExprInspector);
  s.y->inspect(&symbolUsageExprInspector);
  if (s.c) {
    s.c->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Reset &s) const {
  s.x->inspect(&symbolUsageExprInspector);
  s.y->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Cls &s) const {
  if (s.color) {
    s.color->inspect(&symbolUsageExprInspector);
  }
}

void SymbolUsageStatementInspector::inspect(const Sound &s) const {
  s.pitch->inspect(&symbolUsageExprInspector);
  s.duration->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Exec &s) const {
  s.address->inspect(&symbolUsageExprInspector);
}

void SymbolUsageStatementInspector::inspect(const Error & /*s*/) const {}
