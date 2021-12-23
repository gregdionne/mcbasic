// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "complementer.hpp"

std::unique_ptr<NumericExpr> Complementer::mutate(AndExpr &e) {
  auto orExpr = std::make_unique<OrExpr>();
  for (auto &operand : e.operands) {
    orExpr->operands.emplace_back(operand->transmutate(this));
  }
  return orExpr;
}

std::unique_ptr<NumericExpr> Complementer::mutate(OrExpr &e) {
  auto andExpr = std::make_unique<AndExpr>();
  for (auto &operand : e.operands) {
    andExpr->operands.emplace_back(operand->transmutate(this));
  }
  return andExpr;
}

std::unique_ptr<NumericExpr> Complementer::mutate(ComplementedExpr &e) {
  return std::move(e.expr);
}

std::unique_ptr<NumericExpr> Complementer::mutate(RelationalExpr &e) {
  e.comparator = e.comparator == "<"                            ? ">="
                 : e.comparator == "<=" || e.comparator == "=<" ? ">"
                 : e.comparator == "="                          ? "<>"
                 : e.comparator == ">=" || e.comparator == "=>" ? "<"
                 : e.comparator == ">"                          ? "<="
                                                                : "=";
  return std::make_unique<RelationalExpr>(e.comparator, std::move(e.lhs),
                                          std::move(e.rhs));
}

std::unique_ptr<NumericExpr> Complementer::mutate(NumericConstantExpr &e) {
  return std::make_unique<NumericConstantExpr>(1 - e.value);
}
