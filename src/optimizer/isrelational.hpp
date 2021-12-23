// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISRELATIONAL_HPP
#define OPTIMIZER_ISRELATIONAL_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsRelational : public PessimisticExprChecker {
public:
  bool inspect(const RelationalExpr &expr) const override;
};

#endif
