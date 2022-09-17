// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISDECIMALFREE_HPP
#define OPTIMIZER_ISDECIMALFREE_HPP

#include "ast/pessimisticexprchecker.hpp"
#include "symboltable/symboltable.hpp"

class IsDecimalFree : public PessimisticExprChecker {
public:
  explicit IsDecimalFree(SymbolTable &st) : symbolTable(st) {}
  bool inspect(const StringConstantExpr &e) const override;
  bool inspect(const StringConcatenationExpr &e) const override;
  bool inspect(const LeftExpr &e) const override;
  bool inspect(const MidExpr &e) const override;
  bool inspect(const RightExpr &e) const override;
  bool inspect(const StrExpr &e) const override;

private:
  SymbolTable &symbolTable;
};

#endif
