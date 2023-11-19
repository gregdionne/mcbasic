// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_NONZEROBRANCHSELECTOR_HPP
#define OPTIMIZER_NONZEROBRANCHSELECTOR_HPP

#include "ast/nullexprselector.hpp"

// checks to see if expression is a relational comparison against zero
// returns non-zero portion if true

class NonZeroBranchSelector : public NullExprSelector {
public:
  const NumericExpr *inspect(const RelationalExpr &e) const override;

private:
  using NullExprSelector::inspect;
};

#endif
