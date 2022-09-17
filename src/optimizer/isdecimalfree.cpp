// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isdecimalfree.hpp"
#include "isfloat.hpp"

#include <string>
#include <algorithm>

bool IsDecimalFree::inspect(const StringConstantExpr &e) const {
  return e.value.find_first_of('.') == std::string::npos &&
         e.value.find_first_of('E') == std::string::npos;
}

bool IsDecimalFree::inspect(const StringConcatenationExpr &e) const {
  return std::all_of(e.operands.cbegin(), e.operands.cend(), [this](const up<StringExpr> &expr) { return expr->check(this); }); }

bool IsDecimalFree::inspect(const LeftExpr &e) const {
  return e.str->check(this);
}

bool IsDecimalFree::inspect(const MidExpr &e) const {
  return e.str->check(this);
}

bool IsDecimalFree::inspect(const RightExpr &e) const {
  return e.str->check(this);
}

bool IsDecimalFree::inspect(const StrExpr &e) const {
  IsFloat isFloat(symbolTable);
  return e.expr->check(&isFloat);
}
