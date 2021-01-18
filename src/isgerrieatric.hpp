// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef ISGERRIEATRIC_HPP
#define ISGERRIEATRIC_HPP

#include "expression.hpp"

// search for "gerrieatric expressions" of the form:
//   -<boolean>
//   1-<boolean>

class ExprIsGerrieatric : public ExprOp {
public:
  void operate(AdditiveExpr &e) override;
  void operate(NegatedExpr &e) override;
  bool result;
};

template <typename T>
inline bool boperate(T &thing, ExprIsGerrieatric &isGerrieatric) {
  isGerrieatric.result = false;
  thing->operate(&isGerrieatric);
  return isGerrieatric.result;
}

#endif
