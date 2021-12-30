// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isboolean.hpp"

bool IsBoolean::inspect(const NumericConstantExpr &expr) const {
  return expr.value == 0 || expr.value == -1;
}

bool IsBoolean::inspect(const ComplementedExpr &expr) const {
  return expr.inspect(this);
}

bool IsBoolean::inspect(const RelationalExpr & /*expr*/) const { return true; }

bool IsBoolean::inspect(const AndExpr &expr) const {
  for (auto &operand : expr.operands) {
    if (!operand->inspect(this)) {
      return false;
    }
  }
  return true;
}

bool IsBoolean::inspect(const OrExpr &expr) const {
  for (auto &operand : expr.operands) {
    if (!operand->inspect(this)) {
      return false;
    }
  }
  return true;
}