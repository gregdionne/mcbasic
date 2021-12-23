// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isgerrieatric.hpp"
#include "constinspector.hpp"
#include "isboolean.hpp"

// search for -<boolean>
bool ExprIsGerrieatric::inspect(const NegatedExpr &e) const {
  IsBoolean isBoolean;
  return e.expr->inspect(&isBoolean);
}

// search for 1-<boolean>
bool ExprIsGerrieatric::inspect(const AdditiveExpr &e) const {
  IsBoolean isBoolean;
  ConstInspector constInspector;
  return e.operands.size() == 1 &&
         constInspector.isEqual(e.operands[0].get(), 1) &&
         e.invoperands.size() == 1 && e.invoperands[0]->inspect(&isBoolean);
}
