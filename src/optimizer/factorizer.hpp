// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_FACTORIZER_HPP
#define OPTIMIZER_FACTORIZER_HPP

#include "ast/nullexprmutator.hpp"

// factorizes expressions of form
//   F*X + F*Y
//   (F AND X)  OR  (F AND Y)
//   (F OR X)  AND  (F OR Y)

class Factorizer : public NullExprMutator {
public:
  Factorizer() = default;
  Factorizer(const Factorizer &) = delete;
  Factorizer(Factorizer &&) = delete;
  Factorizer &operator=(const Factorizer &) = delete;
  Factorizer &operator=(Factorizer &&) = delete;
  ~Factorizer() override = default;

  void mutate(AdditiveExpr &expr) override;
  void mutate(AndExpr &expr) override;
  void mutate(OrExpr &expr) override;

  bool factorize(NumericExpr *nexp);

private:
  using NullExprMutator::mutate;

  template <typename OuterExpr, typename InnerExpr>
  up<NumericExpr>
  factorize(up<NumericExpr> &lhs, up<NumericExpr> &rhs,
            std::vector<up<NumericExpr>> &(*lhsops)(NaryNumericExpr *),
            std::vector<up<NumericExpr>> &(*rhsops)(NaryNumericExpr *));

  bool factorized{false};
};

#endif
