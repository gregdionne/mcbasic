// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_COMPLEMENTER_HPP
#define OPTIMIZER_COMPLEMENTER_HPP

#include "ast/nullexprtransmutator.hpp"

// complements a boolean expression

class Complementer : public NullExprTransmutator {
public:
  std::unique_ptr<NumericExpr> mutate(NumericConstantExpr &e) override;
  std::unique_ptr<NumericExpr> mutate(ComplementedExpr &e) override;
  std::unique_ptr<NumericExpr> mutate(AndExpr &e) override;
  std::unique_ptr<NumericExpr> mutate(OrExpr &e) override;
  std::unique_ptr<NumericExpr> mutate(RelationalExpr &e) override;

private:
  using NullExprTransmutator::mutate;
};

#endif
