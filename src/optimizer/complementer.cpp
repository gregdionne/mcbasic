// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "complementer.hpp"

up<NumericExpr> Complementer::mutate(AndExpr &e) {
  auto orExpr = makeup<OrExpr>();
  for (auto &operand : e.operands) {
    orExpr->operands.emplace_back(operand->transmutate(this));
  }
  return orExpr;
}

up<NumericExpr> Complementer::mutate(OrExpr &e) {
  auto andExpr = makeup<AndExpr>();
  for (auto &operand : e.operands) {
    andExpr->operands.emplace_back(operand->transmutate(this));
  }
  return andExpr;
}

up<NumericExpr> Complementer::mutate(ComplementedExpr &e) { return mv(e.expr); }

up<NumericExpr> Complementer::mutate(RelationalExpr &e) {
  e.comparator = e.comparator == "<"                            ? ">="
                 : e.comparator == "<=" || e.comparator == "=<" ? ">"
                 : e.comparator == "="                          ? "<>"
                 : e.comparator == ">=" || e.comparator == "=>" ? "<"
                 : e.comparator == ">"                          ? "<="
                                                                : "=";
  return makeup<RelationalExpr>(e.comparator, mv(e.lhs), mv(e.rhs));
}

up<NumericExpr> Complementer::mutate(NumericConstantExpr &e) {
  return makeup<NumericConstantExpr>(1 - e.value);
}
