// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symboltable.hpp"

#include <algorithm>

static bool symCmp(const Symbol &s1, const Symbol &s2) {
  return (!s1.isFloat && s2.isFloat) ||
         (((s1.isFloat ^ s2.isFloat) == 0) && s1.name < s2.name);
}

void sortSymbolTable(SymbolTable &table) {
  std::sort(table.numVarTable.begin(), table.numVarTable.end(), symCmp);
  std::sort(table.numArrTable.begin(), table.numArrTable.end(), symCmp);
  std::sort(table.strVarTable.begin(), table.strVarTable.end(), symCmp);
  std::sort(table.strArrTable.begin(), table.strArrTable.end(), symCmp);
}

void removeSymbol(std::vector<Symbol> &table, const std::string &name) {
  auto it =
      std::find_if(table.begin(), table.end(),
                   [&name](const Symbol &s) -> bool { return name == s.name; });
  if (it != table.end()) {
    table.erase(it);
  }
}
