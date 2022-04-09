// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISCMPEQZERO_HPP
#define OPTIMIZER_ISCMPEQZERO_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsCmpEqZero : public PessimisticExprChecker {
public:
  bool inspect(const RelationalExpr &e) const override;
};

#endif
