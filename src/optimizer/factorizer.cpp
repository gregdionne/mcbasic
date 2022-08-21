// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#include "factorizer.hpp"
#include "isequal.hpp"

// ( A +  B)( A +  C) -> AA +  A(B+C) + BC.
// (hA +  B)(hA +  C) -> AA + hA(B+C) + BC
// ( A + hB)( A + hC) -> AA + hA(B+C) + BC

static std::vector<up<NumericExpr>> &operands(NaryNumericExpr *expr) {
  return expr->operands;
}

static std::vector<up<NumericExpr>> &invoperands(NaryNumericExpr *expr) {
  return expr->invoperands;
}

template <typename OuterExpr, typename InnerExpr>
up<NumericExpr> Factorizer::factorize(up<NumericExpr> &lhs, up<NumericExpr> &rhs, 
    std::vector<up<NumericExpr>> &(* lhsops)(NaryNumericExpr *),
    std::vector<up<NumericExpr>> &(* rhsops)(NaryNumericExpr *)) {
  auto *lexp = dynamic_cast<InnerExpr *>(lhs.get());
  auto *rexp = dynamic_cast<InnerExpr *>(rhs.get());
  if (lexp && lexp->invoperands.empty() && rexp && rexp->invoperands.empty()) {
    auto itLexp = lexp->operands.begin();
    while (itLexp != lexp->operands.end()) {
      IsEqual isEqual(itLexp->get());
      auto itRexp = rexp->operands.begin();
      while (itRexp != rexp->operands.end()) {
        if ((*itRexp)->check(&isEqual)) {
          auto outerExpr = makeup<InnerExpr>(mv(*itLexp));
          auto innerExpr = makeup<OuterExpr>();
          itLexp = lexp->operands.erase(itLexp);
          itRexp = rexp->operands.erase(itRexp);
          lhsops(innerExpr.get()).emplace_back(mv(lhs));
          rhsops(innerExpr.get()).emplace_back(mv(rhs));
          outerExpr->operands.emplace_back(mv(innerExpr));
          factorized = true;
          return mv(outerExpr);
        }
        ++itRexp;
      }
      ++itLexp;
    }
  }
  return {};
}

void Factorizer::mutate(AdditiveExpr &expr) {
  auto itLHS = expr.operands.begin();
  while (itLHS != expr.operands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.operands.end()) {
      if (auto factor = factorize<AdditiveExpr, MultiplicativeExpr>(*itLHS, *itRHS, operands, operands)) {
        itRHS = expr.operands.erase(itRHS);
        *itLHS = mv(factor);
        return;
      }
      ++itRHS;
    }
    itRHS = expr.invoperands.begin();
    while (itRHS != expr.invoperands.end()) {
      if (auto factor = factorize<AdditiveExpr, MultiplicativeExpr>(*itLHS, *itRHS, operands, invoperands)) {
        itRHS = expr.invoperands.erase(itRHS);
        *itLHS = mv(factor);
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
      if (auto factor = factorize<AdditiveExpr, MultiplicativeExpr>(*itLHS, *itRHS, invoperands, invoperands)) {
        itRHS = expr.invoperands.erase(itRHS);
        *itLHS = mv(factor);
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
}

void Factorizer::mutate(AndExpr &expr) {
  auto itLHS = expr.operands.begin();
  while (itLHS != expr.operands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.operands.end()) {
      if (auto factor = factorize<AndExpr, OrExpr>(*itLHS, *itRHS, operands, operands)) {
        itRHS = expr.operands.erase(itRHS);
        *itLHS = mv(factor);
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
}

void Factorizer::mutate(OrExpr &expr) {
  auto itLHS = expr.operands.begin();
  while (itLHS != expr.operands.end()) {
    auto itRHS = std::next(itLHS);
    while (itRHS != expr.operands.end()) {
      if (auto factor = factorize<OrExpr, AndExpr>(*itLHS, *itRHS, operands, operands)) {
        itRHS = expr.operands.erase(itRHS);
        *itLHS = mv(factor);
        return;
      }
      ++itRHS;
    }
    ++itLHS;
  }
}

// TODO: make a PessimisticExprMutator
bool Factorizer::factorize(NumericExpr *expr) {
  factorized = false;
  expr->mutate(this);
  return factorized;
}

