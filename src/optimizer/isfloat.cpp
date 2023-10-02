// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isfloat.hpp"
#include "constinspector.hpp"
#include "consttable/fixedpoint.hpp"
#include "ischar.hpp"
#include "isdecimalfree.hpp"

bool IsFloat::inspect(const ValExpr &e) const {
  IsChar isChar;
  IsDecimalFree isDecimalFree(symbolTable);
  return !e.expr->check(&isChar) && !e.expr->check(&isDecimalFree);
}

bool IsFloat::inspect(const AbsExpr &e) const { return e.expr->check(this); }

bool IsFloat::inspect(const ShiftExpr &e) const {
  ConstInspector constInspector;
  auto value = e.count->constify(&constInspector);
  return !value || !FixedPoint(*value).isPosWord() || e.expr->check(this);
}

bool IsFloat::inspect(const PowerExpr &e) const {
  ConstInspector constInspector;
  auto value = e.exponent->constify(&constInspector);
  return !value || !FixedPoint(*value).isPosWord() || e.base->check(this);
}

bool IsFloat::inspect(const MultiplicativeExpr &e) const {
  if (!e.invoperands.empty()) {
    return true;
  }

  for (const auto &operand : e.operands) {
    if (operand->check(this)) {
      return true;
    }
  }

  return false;
}

bool IsFloat::inspect(const AdditiveExpr &e) const {
  for (const auto &operand : e.operands) {
    if (operand->check(this)) {
      return true;
    }
  }

  for (const auto &operand : e.invoperands) {
    if (operand->check(this)) {
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
  return !value || *value < 1;
}

bool IsFloat::inspect(const NumericConstantExpr &e) const {
  return !FixedPoint(e.value).isInteger();
}

bool IsFloat::inspect(const NumericVariableExpr &e) const {
  for (const auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      return symbol.isFloat;
    }
  }
  return false;
}

bool IsFloat::inspect(const NumericArrayExpr &e) const {
  for (const auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      return symbol.isFloat;
    }
  }
  return false;
}

bool IsFloat::inspect(const SquareExpr &e) const { return e.expr->check(this); }

bool IsFloat::inspect(const FractExpr &e) const { return e.expr->check(this); }
