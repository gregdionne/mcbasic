// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "complementer.hpp"

void Complementer::operate(AndExpr &e) {
  std::unique_ptr<OrExpr> orExpr;

  for (auto &operand : e.operands) {
    operand->operate(this);
    if (!orExpr) {
      orExpr = std::make_unique<OrExpr>(std::move(complement));
    } else {
      orExpr->append(std::move(complement));
    }
  }
  complement = std::move(orExpr);
}

void Complementer::operate(OrExpr &e) {
  std::unique_ptr<AndExpr> andExpr;

  for (auto &operand : e.operands) {
    operand->operate(this);
    if (!andExpr) {
      andExpr = std::make_unique<AndExpr>(std::move(complement));
    } else {
      andExpr->append(std::move(complement));
    }
  }
  complement = std::move(andExpr);
}

void Complementer::operate(ComplementedExpr &e) {
  complement = std::move(e.expr);
}

void Complementer::operate(RelationalExpr &e) {
  e.comparator = e.comparator == "<"                            ? ">="
                 : e.comparator == "<=" || e.comparator == "=<" ? ">"
                 : e.comparator == "="                          ? "<>"
                 : e.comparator == ">=" || e.comparator == "=>" ? "<"
                 : e.comparator == ">"                          ? "<="
                                                                : "=";
  complement = std::make_unique<RelationalExpr>(e.comparator, e.lhs.release(),
                                                e.rhs.release());
}

void Complementer::operate(NumericConstantExpr &e) {
  complement = std::make_unique<NumericConstantExpr>(1 - e.value);
}
