// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isequal.hpp"

bool IsEqual::inspect(const NumericConstantExpr &expr) const {
  auto *tgt = dynamic_cast<const NumericConstantExpr *>(target);
  return tgt != nullptr && tgt->value == expr.value;
}

bool IsEqual::inspect(const StringConstantExpr &expr) const {
  auto *tgt = dynamic_cast<const StringConstantExpr *>(target);
  return tgt != nullptr && tgt->value == expr.value;
}

bool IsEqual::inspect(const NumericVariableExpr &expr) const {
  auto *tgt = dynamic_cast<const NumericVariableExpr *>(target);
  return tgt != nullptr && tgt->varname == expr.varname;
}

bool IsEqual::inspect(const StringVariableExpr &expr) const {
  auto *tgt = dynamic_cast<const StringVariableExpr *>(target);
  return tgt != nullptr && tgt->varname == expr.varname;
}

bool IsEqual::inspect(const ArrayIndicesExpr &expr) const {
  auto *tgt = dynamic_cast<const ArrayIndicesExpr *>(target);
  bool result = tgt != nullptr;
  for (std::size_t i = 0; result && i < expr.operands.size(); i++) {
    IsEqual isIndexEqual(tgt->operands[i].get());
    result &= expr.operands[i]->check(&isIndexEqual);
  }
  return result;
}

bool IsEqual::inspect(const NumericArrayExpr &expr) const {
  auto *tgt = dynamic_cast<const NumericArrayExpr *>(target);
  bool result = tgt != nullptr && tgt->varexp->varname == expr.varexp->varname;
  if (result) {
    IsEqual areIndicesEqual(tgt->indices.get());
    result &= expr.indices->check(&areIndicesEqual);
  }
  return result;
}

bool IsEqual::inspect(const StringArrayExpr &expr) const {
  auto *tgt = dynamic_cast<const StringArrayExpr *>(target);
  bool result = tgt != nullptr && tgt->varexp->varname == expr.varexp->varname;
  if (result) {
    IsEqual areIndicesEqual(tgt->indices.get());
    result &= expr.indices->check(&areIndicesEqual);
  }
  return result;
}
