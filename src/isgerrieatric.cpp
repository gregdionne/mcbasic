// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isgerrieatric.hpp"

void ExprIsGerrieatric::operate(NegatedExpr &e) {
  result = e.expr->isBoolean();
}

void ExprIsGerrieatric::operate(AdditiveExpr &e) {
  double val;
  result = (e.operands.size() == 1 && e.operands[0]->isConst(val) && val == 1 &&
            e.invoperands.size() == 1 && e.invoperands[0]->isBoolean()) ||
           (e.operands.size() == 1 && e.operands[0]->isBoolean() &&
            e.invoperands.size() == 1 && e.invoperands[0]->isConst(val) &&
            val == -1);
}
