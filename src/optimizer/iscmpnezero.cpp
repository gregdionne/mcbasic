// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#include "iscmpnezero.hpp"
#include "constinspector.hpp"

bool IsCmpNeZero::inspect(const RelationalExpr &e) const {
  ConstInspector constInspector;
  return (e.comparator == "<>" || e.comparator == "><") &&
         (constInspector.isEqual(e.lhs.get(), 0) ||
          constInspector.isEqual(e.rhs.get(), 0));
}
