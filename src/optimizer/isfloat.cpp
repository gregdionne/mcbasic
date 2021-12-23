// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isfloat.hpp"
#include "constinspector.hpp"
#include "consttable/fixedpoint.hpp"

bool IsFloat::inspect(const ValExpr & /*expr*/) const { return true; }

bool IsFloat::inspect(const AbsExpr &e) const { return e.expr->inspect(this); }

bool IsFloat::inspect(const ShiftExpr &e) const {
  ConstInspector constInspector;
  auto value = e.count->constify(&constInspector);
  return !value || !FixedPoint(*value).isPosWord() || e.expr->inspect(this);
}

bool IsFloat::inspect(const NegatedExpr &e) const {
  return e.expr->inspect(this);
}

bool IsFloat::inspect(const PowerExpr &e) const {
  ConstInspector constInspector;
  auto value = e.exponent->constify(&constInspector);
  return !value || !FixedPoint(*value).isPosWord() || e.base->inspect(this);
}

bool IsFloat::inspect(const MultiplicativeExpr &e) const {
  if (!e.invoperands.empty()) {
    return true;
  }

  for (auto &operand : e.operands) {
    if (operand->inspect(this)) {
      return true;
    }
  }

  return false;
}

bool IsFloat::inspect(const AdditiveExpr &e) const {
  for (auto &operand : e.operands) {
    if (operand->inspect(this)) {
      return true;
    }
  }

  for (auto &operand : e.invoperands) {
    if (operand->inspect(this)) {
      return true;
    }
  }

  return false;
}

bool IsFloat::inspect(const SqrExpr & /*e*/) const { return true; }

bool IsFloat::inspect(const ExpExpr & /*e*/) const { return true; }

bool IsFloat::inspect(const LogExpr & /*e*/) const { return true; }

bool IsFloat::inspect(const SinExpr & /*e*/) const { return true; }

bool IsFloat::inspect(const CosExpr & /*e*/) const { return true; }

bool IsFloat::inspect(const TanExpr & /*e*/) const { return true; }

bool IsFloat::inspect(const RndExpr &e) const {
  ConstInspector constInspector;
  auto value = e.expr->constify(&constInspector);
  return !(value && *value >= 1);
}

bool IsFloat::inspect(const NumericConstantExpr &e) const {
  return !FixedPoint(e.value).isInteger();
}

bool IsFloat::inspect(const NumericVariableExpr &e) const {
  for (Symbol &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      return symbol.isFloat;
    }
  }
  return false;
}

bool IsFloat::inspect(const NumericArrayExpr &e) const {
  for (Symbol &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      return symbol.isFloat;
    }
  }
  return false;
}
