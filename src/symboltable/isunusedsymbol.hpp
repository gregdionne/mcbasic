// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_ISUNUSEDSYMBOL_HPP
#define SYMBOLTABLE_ISUNUSEDSYMBOL_HPP

#include "ast/pessimisticexprchecker.hpp"
#include "symboltable.hpp"

class IsUnusedSymbol : public PessimisticExprChecker {
public:
  explicit IsUnusedSymbol(const SymbolTable &st) : symbolTable(st) {}
  bool inspect(const NumericVariableExpr &e) const override;
  bool inspect(const StringVariableExpr &e) const override;
  bool inspect(const NumericArrayExpr &e) const override;
  bool inspect(const StringArrayExpr &e) const override;

private:
  using PessimisticExprChecker::inspect;
  const SymbolTable &symbolTable;
};

#endif
