// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "ismissingsymbol.hpp"
#include <algorithm>

bool IsMissingSymbol::inspect(const NumericVariableExpr &e) const {
  return std::all_of(
      symbolTable.numVarTable.begin(), symbolTable.numVarTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varname; });
}

bool IsMissingSymbol::inspect(const StringVariableExpr &e) const {
  return std::all_of(
      symbolTable.strVarTable.begin(), symbolTable.strVarTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varname; });
}

bool IsMissingSymbol::inspect(const NumericArrayExpr &e) const {
  return std::all_of(
      symbolTable.numArrTable.begin(), symbolTable.numArrTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varexp->varname; });
}

bool IsMissingSymbol::inspect(const StringArrayExpr &e) const {
  return std::all_of(
      symbolTable.strArrTable.begin(), symbolTable.strArrTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varexp->varname; });
}
