// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "dimpruner.hpp"
#include "ast/lister.hpp"
#include <algorithm> // std::all_of

void DimPruner::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void DimPruner::operate(Line &l) {
  StatementDimPruner sdp(l.lineNumber, symbolTable, announcer);
  sdp.prune(l.statements);
}

void StatementDimPruner::prune(std::vector<up<Statement>> &statements) {
  auto it = statements.begin();
  while (it != statements.end()) {
    pruned = false;
    (*it)->mutate(this);
    if (pruned) {
      pruned = false;
      announcer.start(lineNumber);
      announcer.finish("empty DIM statement");
      it = statements.erase(it);
    } else {
      ++it;
    }
  }
}

void StatementDimPruner::mutate(If &s) {
  prune(s.consequent);
  pruned = s.consequent.empty();
}

void StatementDimPruner::mutate(Dim &s) {
  auto it = s.variables.begin();
  while (it != s.variables.end()) {
    if ((*it)->check(&isDeadSymbol)) {
      ExprLister el;
      (*it)->soak(&el);
      announcer.start(lineNumber);
      announcer.finish("unused DIM variable/array \"%s\"", el.result.c_str());
      it = s.variables.erase(it);
    } else {
      ++it;
    }
  }
  pruned = s.variables.empty();
}

bool IsDeadSymbol::inspect(const NumericVariableExpr &e) const {
  return std::all_of(
      symbolTable.numVarTable.begin(), symbolTable.numVarTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varname; });
}

bool IsDeadSymbol::inspect(const StringVariableExpr &e) const {
  return std::all_of(
      symbolTable.strVarTable.begin(), symbolTable.strVarTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varname; });
}

bool IsDeadSymbol::inspect(const NumericArrayExpr &e) const {
  return std::all_of(
      symbolTable.numArrTable.begin(), symbolTable.numArrTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varexp->varname; });
}

bool IsDeadSymbol::inspect(const StringArrayExpr &e) const {
  return std::all_of(
      symbolTable.strArrTable.begin(), symbolTable.strArrTable.end(),
      [&e](const Symbol &symbol) { return symbol.name != e.varexp->varname; });
}
