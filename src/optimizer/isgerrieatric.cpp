// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isgerrieatric.hpp"
#include "constinspector.hpp"
#include "isboolean.hpp"

// search for -<boolean>
// search for 1-<boolean>
bool ExprIsGerrieatric::inspect(const AdditiveExpr &e) const {
  IsBoolean isBoolean;
  ConstInspector constInspector;
  return e.invoperands.size() == 1 && e.invoperands[0]->check(&isBoolean) &&
         (e.operands.empty() ||
          (e.operands.size() == 1 &&
           (constInspector.isEqual(e.operands[0].get(), 0) ||
            constInspector.isEqual(e.operands[0].get(), 1))));
}
