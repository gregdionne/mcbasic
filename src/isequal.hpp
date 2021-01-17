// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef ISEQUAL_HPP
#define ISEQUAL_HPP

#include "expression.hpp"

class IsEqual : public ExprOp {
public:
  bool result;
  explicit IsEqual(Expr *expr_in) : result(false), target(expr_in) {}
  void operate(ArrayIndicesExpr &expr) override;
  void operate(NumericConstantExpr &expr) override;
  void operate(StringConstantExpr &expr) override;
  void operate(NumericArrayExpr &expr) override;
  void operate(StringArrayExpr &expr) override;
  void operate(NumericVariableExpr &expr) override;
  void operate(StringVariableExpr &expr) override;
  Expr *target;
};

template <typename T> inline bool boperate(T &thing, IsEqual &isEqual) {
  isEqual.result = false;
  thing->operate(&isEqual);
  return isEqual.result;
}

#endif
