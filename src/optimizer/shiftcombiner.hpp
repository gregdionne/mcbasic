// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_SHIFTCOMBINER_HPP
#define OPTIMIZER_SHIFTCOMBINER_HPP

#include "ast/nullexprmutator.hpp"

// combines expressions of form
//   SHIFT(A,N)  +  SHIFT(B,N)
//   SHIFT(A,N) AND SHIFT(B,N)
//   SHIFT(A,N) OR  SHIFT(B,N)

class ShiftCombiner : public NullExprMutator {
public:
  ShiftCombiner() = default;
  ShiftCombiner(const ShiftCombiner &) = delete;
  ShiftCombiner(ShiftCombiner &&) = delete;
  ShiftCombiner &operator=(const ShiftCombiner &) = delete;
  ShiftCombiner &operator=(ShiftCombiner &&) = delete;
  ~ShiftCombiner() override = default;

  void mutate(AdditiveExpr &expr) override;
  void mutate(AndExpr &expr) override;
  void mutate(OrExpr &expr) override;

  bool combine(NumericExpr *nexp);

private:
  using NullExprMutator::mutate;

  template <typename OuterExpr>
  up<NumericExpr> combine(up<NumericExpr> &lhs, up<NumericExpr> &rhs,
    std::vector<up<NumericExpr>> &(* lhsops)(NaryNumericExpr *),
    std::vector<up<NumericExpr>> &(* rhsops)(NaryNumericExpr *));

  bool combined{false};
};

#endif
