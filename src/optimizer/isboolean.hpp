// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISBOOLEAN_HPP
#define OPTIMIZER_ISBOOLEAN_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsBoolean : public PessimisticExprChecker {
public:
  bool inspect(const NumericConstantExpr &expr) const override;
  bool inspect(const ComplementedExpr &expr) const override;
  bool inspect(const RelationalExpr &expr) const override;
  bool inspect(const AndExpr &expr) const override;
  bool inspect(const OrExpr &expr) const override;
};

#endif
