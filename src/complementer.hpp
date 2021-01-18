// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef COMPLEMENTER_HPP
#define COMPLEMENTER_HPP

#include "expression.hpp"

// complements a boolean expression

class Complementer : public ExprOp {
public:
  void operate(NumericConstantExpr &e) override;
  void operate(ComplementedExpr &e) override;
  void operate(AndExpr &e) override;
  void operate(OrExpr &e) override;
  void operate(RelationalExpr &e) override;

  std::unique_ptr<NumericExpr> complement;
};

#endif
