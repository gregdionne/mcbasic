// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISCMPNEZERO_HPP
#define OPTIMIZER_ISCMPNEZERO_HPP

#include "ast/pessimisticexprchecker.hpp"

class IsCmpNeZero : public PessimisticExprChecker {
public:
  bool inspect(const RelationalExpr &e) const override;
};

#endif
