// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_SYMBOLTABLE_HPP
#define SYMBOLTABLE_SYMBOLTABLE_HPP

#include <string>
#include <vector>

// holds string, float, and integer variables
// isFloat is updated by FloatPromoter
// isUsed is updated by SymbolUsageTabulator

struct Symbol {
  std::string name;
  int numDims{0};
  bool isFloat{false};
  bool isUsed{false};
};

struct SymbolTable {
  std::vector<Symbol> numVarTable;
  std::vector<Symbol> strVarTable;
  std::vector<Symbol> numArrTable;
  std::vector<Symbol> strArrTable;
};

void sortSymbolTable(SymbolTable &table);
bool pruneUnusedSymbols(SymbolTable &table);
void clearUsage(SymbolTable &table);
void removeSymbol(std::vector<Symbol> &table, const std::string &name);

#endif
