// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_ISMISSINGSYMBOL
#define SYMBOLTABLE_ISMISSINGSYMBOL

#include "ast/pessimisticexprchecker.hpp"
#include "symboltable.hpp"

// return true when a symbol is not present in the symbol table
class IsMissingSymbol : public PessimisticExprChecker {
public:
  explicit IsMissingSymbol(const SymbolTable &st) : symbolTable(st) {}
  bool inspect(const NumericVariableExpr &e) const override;
  bool inspect(const StringVariableExpr &e) const override;
  bool inspect(const NumericArrayExpr &e) const override;
  bool inspect(const StringArrayExpr &e) const override;

private:
  using PessimisticExprChecker::inspect;
  const SymbolTable &symbolTable;
};

#endif
