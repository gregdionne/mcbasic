// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#include "iscmpeqzero.hpp"
#include "constinspector.hpp"

bool IsCmpEqZero::inspect(const RelationalExpr &e) const {
  ConstInspector constInspector;
  return e.comparator == "=" && (constInspector.isEqual(e.lhs.get(), 0) ||
                                 constInspector.isEqual(e.rhs.get(), 0));
}
