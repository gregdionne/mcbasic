// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_COMPLEMENTER_HPP
#define OPTIMIZER_COMPLEMENTER_HPP

#include "ast/nullexprtransmutator.hpp"

// complements a boolean expression

class Complementer : public NullExprTransmutator {
public:
  up<NumericExpr> mutate(NumericConstantExpr &e) override;
  up<NumericExpr> mutate(ComplementedExpr &e) override;
  up<NumericExpr> mutate(AndExpr &e) override;
  up<NumericExpr> mutate(OrExpr &e) override;
  up<NumericExpr> mutate(RelationalExpr &e) override;

private:
  using NullExprTransmutator::mutate;
};

#endif
