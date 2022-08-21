// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "isunusedsymbol.hpp"

static bool isUnused(const std::vector<Symbol> &table,
                     const std::string &name) {

  for (const auto &symbol : table) {
    if (symbol.name == name) {
      return !symbol.isUsed;
    }
  }

  return false;
}

bool IsUnusedSymbol::inspect(const NumericVariableExpr &e) const {
  return isUnused(symbolTable.numVarTable, e.varname);
}

bool IsUnusedSymbol::inspect(const StringVariableExpr &e) const {
  return isUnused(symbolTable.strVarTable, e.varname);
}

bool IsUnusedSymbol::inspect(const NumericArrayExpr &e) const {
  return isUnused(symbolTable.numArrTable, e.varexp->varname);
}

bool IsUnusedSymbol::inspect(const StringArrayExpr &e) const {
  return isUnused(symbolTable.strArrTable, e.varexp->varname);
}
