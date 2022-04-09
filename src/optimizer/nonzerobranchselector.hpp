// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_NONZEROBRANCHSELECTOR_HPP
#define OPTIMIZER_NONZEROBRANCHSELECTOR_HPP

#include "ast/nullexprselector.hpp"

// complements a boolean expression

class NonZeroBranchSelector : public NullExprSelector {
public:
  const NumericExpr *inspect(const RelationalExpr &e) const override;

private:
  using NullExprSelector::inspect;
};

#endif
