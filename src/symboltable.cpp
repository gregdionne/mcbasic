// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symboltable.hpp"

#include <algorithm>

static bool symCmp(const Symbol &s1, const Symbol &s2) {
  return (!s1.isFloat && s2.isFloat) ||
         (((s1.isFloat ^ s2.isFloat) == 0) && s1.name < s2.name);
}

void SymbolTable::sort() {
  std::sort(numVarTable.begin(), numVarTable.end(), symCmp);
  std::sort(numArrTable.begin(), numArrTable.end(), symCmp);
  std::sort(strVarTable.begin(), strVarTable.end(), symCmp);
  std::sort(strArrTable.begin(), strArrTable.end(), symCmp);
}
