// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isequal.hpp"

void IsEqual::operate(NumericConstantExpr &expr) {
  auto *tgt = dynamic_cast<NumericConstantExpr *>(target);
  result = tgt != nullptr && tgt->value == expr.value;
}

void IsEqual::operate(StringConstantExpr &expr) {
  auto *tgt = dynamic_cast<StringConstantExpr *>(target);
  result = tgt != nullptr && tgt->value == expr.value;
}

void IsEqual::operate(NumericVariableExpr &expr) {
  auto *tgt = dynamic_cast<NumericVariableExpr *>(target);
  result = tgt != nullptr && tgt->varname == expr.varname;
}

void IsEqual::operate(StringVariableExpr &expr) {
  auto *tgt = dynamic_cast<StringVariableExpr *>(target);
  result = tgt != nullptr && tgt->varname == expr.varname;
}

void IsEqual::operate(ArrayIndicesExpr &expr) {
  auto *tgt = dynamic_cast<ArrayIndicesExpr *>(target);
  result = tgt != nullptr;
  for (std::size_t i = 0; result && i < expr.operands.size(); i++) {
    IsEqual isIndexEqual(tgt->operands[i].get());
    result &= boperate(expr.operands[i], isIndexEqual);
  }
}

void IsEqual::operate(NumericArrayExpr &expr) {
  auto *tgt = dynamic_cast<NumericArrayExpr *>(target);
  result = tgt != nullptr;
  result = result && tgt->varexp->varname == expr.varexp->varname;
  if (result) {
    IsEqual areIndicesEqual(tgt->indices.get());
    result &= boperate(expr.indices, areIndicesEqual);
  }
}

void IsEqual::operate(StringArrayExpr &expr) {
  auto *tgt = dynamic_cast<StringArrayExpr *>(target);
  result = tgt != nullptr && tgt->varexp->varname == expr.varexp->varname;
  if (result) {
    IsEqual areIndicesEqual(tgt->indices.get());
    result &= boperate(expr.indices, areIndicesEqual);
  }
}
