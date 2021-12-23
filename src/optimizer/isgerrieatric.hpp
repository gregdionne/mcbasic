// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISGERRIEATRIC_HPP
#define OPTIMIZER_ISGERRIEATRIC_HPP

#include "ast/pessimisticexprchecker.hpp"

// search for "gerrieatric expressions" of the form:
//   -<boolean>
//   1-<boolean>

class ExprIsGerrieatric : public PessimisticExprChecker {
public:
  bool inspect(const AdditiveExpr &e) const override;
  bool inspect(const NegatedExpr &e) const override;
};

#endif
