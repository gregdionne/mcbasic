// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISEQUAL_HPP
#define OPTIMIZER_ISEQUAL_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsEqual : public PessimisticExprChecker {
public:
  explicit IsEqual(Expr *expr_in) : target(expr_in) {}
  bool inspect(const ArrayIndicesExpr &expr) const override;
  bool inspect(const NumericConstantExpr &expr) const override;
  bool inspect(const StringConstantExpr &expr) const override;
  bool inspect(const NumericArrayExpr &expr) const override;
  bool inspect(const StringArrayExpr &expr) const override;
  bool inspect(const NumericVariableExpr &expr) const override;
  bool inspect(const StringVariableExpr &expr) const override;
  const Expr *target;
};

#endif
