// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isequal.hpp"

bool IsEqual::inspect(const NumericConstantExpr &expr) const {
  const auto *tgt = dynamic_cast<const NumericConstantExpr *>(target);
  return tgt && tgt->value == expr.value;
}

bool IsEqual::inspect(const StringConstantExpr &expr) const {
  const auto *tgt = dynamic_cast<const StringConstantExpr *>(target);
  return tgt && tgt->value == expr.value;
}

bool IsEqual::inspect(const NumericVariableExpr &expr) const {
  const auto *tgt = dynamic_cast<const NumericVariableExpr *>(target);
  return tgt && tgt->varname == expr.varname;
}

bool IsEqual::inspect(const StringVariableExpr &expr) const {
  const auto *tgt = dynamic_cast<const StringVariableExpr *>(target);
  return tgt && tgt->varname == expr.varname;
}

bool IsEqual::inspect(const ArrayIndicesExpr &expr) const {
  const auto *tgt = dynamic_cast<const ArrayIndicesExpr *>(target);
  bool result = tgt;
  for (std::size_t i = 0; result && i < expr.operands.size(); i++) {
    IsEqual isIndexEqual(tgt->operands[i].get());
    result &= expr.operands[i]->check(&isIndexEqual);
  }
  return result;
}

bool IsEqual::inspect(const NumericArrayExpr &expr) const {
  const auto *tgt = dynamic_cast<const NumericArrayExpr *>(target);
  bool result = tgt && tgt->varexp->varname == expr.varexp->varname;
  if (result) {
    IsEqual areIndicesEqual(tgt->indices.get());
    result &= expr.indices->check(&areIndicesEqual);
  }
  return result;
}

bool IsEqual::inspect(const StringArrayExpr &expr) const {
  const auto *tgt = dynamic_cast<const StringArrayExpr *>(target);
  bool result = tgt && tgt->varexp->varname == expr.varexp->varname;
  if (result) {
    IsEqual areIndicesEqual(tgt->indices.get());
    result &= expr.indices->check(&areIndicesEqual);
  }
  return result;
}

bool IsEqual::checkOps(const std::vector<up<NumericExpr>> &lhs,
                       const std::vector<up<NumericExpr>> &rhs) {
  if (lhs.size() != rhs.size()) {
    return false;
  }

  std::vector<bool> matched(rhs.size(), false);

  for (const auto &lop : lhs) {
    bool found = false;
    IsEqual isEqual(lop.get());
    for (size_t i = 0; i < rhs.size(); ++i) {
      if (!matched[i] && rhs[i]->check(&isEqual)) {
        matched[i] = true;
        found = true;
        break;
      }
    }
    if (!found) {
      return false;
    }
  }

  return true;
}

bool IsEqual::inspect(const NaryNumericExpr &expr) const {
  const auto *tgt = dynamic_cast<const NaryNumericExpr *>(target);
  return tgt && tgt->funcName == expr.funcName &&
         checkOps(tgt->operands, expr.operands) &&
         checkOps(tgt->invoperands, expr.invoperands);
}

bool IsEqual::inspect(const AdditiveExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}

bool IsEqual::inspect(const MultiplicativeExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}
bool IsEqual::inspect(const AndExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}

bool IsEqual::inspect(const OrExpr &expr) const {
  return expr.NaryNumericExpr::check(this);
}
