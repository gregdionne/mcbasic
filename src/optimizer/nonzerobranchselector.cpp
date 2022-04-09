// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#include "nonzerobranchselector.hpp"
#include "constinspector.hpp"

const NumericExpr *
NonZeroBranchSelector::inspect(const RelationalExpr &e) const {

  ConstInspector constInspector;

  return constInspector.isEqual(e.lhs.get(), 0)
             ? dynamic_cast<NumericExpr *>(e.rhs.get())
         : constInspector.isEqual(e.rhs.get(), 0)
             ? dynamic_cast<NumericExpr *>(e.lhs.get())
             : nullptr;
}
