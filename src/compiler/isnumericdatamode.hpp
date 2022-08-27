// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISNUMERICDATAMODE_HPP
#define OPTIMIZER_ISNUMERICDATAMODE_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsNumericDataMode : public PessimisticExprChecker {
public:
  bool inspect(const NumericConstantExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const NumericVariableExpr & /*expr*/) const override {
    return true;
  }
  bool inspect(const IntExpr &expr) const override {
    return expr.expr->check(this);
  }
};

#endif
