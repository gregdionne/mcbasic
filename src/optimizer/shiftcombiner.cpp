// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#include "shiftcombiner.hpp"
#include "isequal.hpp"

static std::vector<up<NumericExpr>> &operands(NaryNumericExpr *expr) {
  return expr->operands;
}

static std::vector<up<NumericExpr>> &invoperands(NaryNumericExpr *expr) {
  return expr->invoperands;
}

template <typename OuterExpr>
up<NumericExpr> ShiftCombiner::combine(
    up<NumericExpr> &lhs, up<NumericExpr> &rhs,
    std::vector<up<NumericExpr>> &(*lhsops)(NaryNumericExpr *),
    std::vector<up<NumericExpr>> &(*rhsops)(NaryNumericExpr *)) {
  auto *lexp = dynamic_cast<ShiftExpr *>(lhs.get());
  auto *rexp = dynamic_cast<ShiftExpr *>(rhs.get());
  if (lexp && rexp) {
    IsEqual isEqual(lexp->count.get());
    if (rexp->count->check(&isEqual)) {
      auto innerExpr = makeup<OuterExpr>();
      lhsops(innerExpr.get()).emplace_back(mv(lexp->expr));
      rhsops(innerExpr.get()).emplace_back(mv(rexp->expr));
      combined = true;
      return makeup<ShiftExpr>(mv(innerExpr), mv(lexp->count));
    }
  }
  return {};
}

void ShiftCombiner::mutate(AdditiveExpr &expr) {
  auto itLHS = expr.operands.begin();
  while (itLHS != expr.operands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.operands.end()) {
      if (auto shift =
              combine<AdditiveExpr>(*itLHS, *itRHS, operands, operands)) {
        itRHS = expr.operands.erase(itRHS);
        *itLHS = mv(shift);
        return;
      }
      ++itRHS;
    }
    itRHS = expr.invoperands.begin();
    while (itRHS != expr.invoperands.end()) {
      if (auto shift =
              combine<AdditiveExpr>(*itLHS, *itRHS, operands, invoperands)) {
        itRHS = expr.invoperands.erase(itRHS);
        *itLHS = mv(shift);
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
  itLHS = expr.invoperands.begin();
  while (itLHS != expr.invoperands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.invoperands.end()) {
      if (auto shift =
              combine<AdditiveExpr>(*itLHS, *itRHS, invoperands, invoperands)) {
        itRHS = expr.invoperands.erase(itRHS);
        itLHS = expr.invoperands.erase(itLHS);
        expr.operands.emplace_back(mv(shift));
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
}

void ShiftCombiner::mutate(AndExpr &expr) {
  auto itLHS = expr.operands.begin();
  while (itLHS != expr.operands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.operands.end()) {
      if (auto shift = combine<AndExpr>(*itLHS, *itRHS, operands, operands)) {
        itRHS = expr.operands.erase(itRHS);
        *itLHS = mv(shift);
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
}

void ShiftCombiner::mutate(OrExpr &expr) {
  auto itLHS = expr.operands.begin();
  while (itLHS != expr.operands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.operands.end()) {
      if (auto shift = combine<OrExpr>(*itLHS, *itRHS, operands, operands)) {
        itRHS = expr.operands.erase(itRHS);
        *itLHS = mv(shift);
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
}

// TODO: make a PessimisticExprMutator
bool ShiftCombiner::combine(NumericExpr *expr) {
  combined = false;
  expr->mutate(this);
  return combined;
}
