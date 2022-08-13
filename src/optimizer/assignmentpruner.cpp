// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "assignmentpruner.hpp"
#include "ast/lister.hpp"
#include "dimpruner.hpp"
#include "ispure.hpp"
#include "symboltable/symbolusageinspector.hpp"

void AssignmentPruner::prunePureUnusedSymbols(std::vector<Symbol> &table) {
  auto it = table.begin();
  while (it != table.end()) {
    if (!it->isUsed && !it->isImpure) {
      it = table.erase(it);
      pruned = true;
    } else {
      ++it;
    }
  }
}

void AssignmentPruner::operate(Program &p) {
  do {
    SymbolUsageInspector sui(symbolTable);
    p.operate(&sui);

    for (auto &line : p.lines) {
      line->operate(this);
    }

    pruned = false;
    prunePureUnusedSymbols(symbolTable.numVarTable);
    prunePureUnusedSymbols(symbolTable.strVarTable);
    prunePureUnusedSymbols(symbolTable.numArrTable);
    prunePureUnusedSymbols(symbolTable.strArrTable);
    DimPruner dp(symbolTable, announcer);
    p.operate(&dp);
  } while (pruned);
}

void AssignmentPruner::operate(Line &l) {
  StatementAssignmentPruner sap(l.lineNumber, announcer, symbolTable);
  sap.prune(l.statements);
}

void StatementAssignmentPruner::mutate(If &s) { prune(s.consequent); }

bool IsEmptyIf::inspect(const If &s) const { return s.consequent.empty(); }

void StatementAssignmentPruner::prune(std::vector<up<Statement>> &statements) {
  auto it = statements.begin();
  while (it != statements.end()) {
    (*it)->inspect(&markImpureAssignment);
    (*it)->mutate(this);
    if ((*it)->check(&isPrunableAssignment)) {
      StatementLister sl;
      (*it)->soak(&sl);
      announcer.start(lineNumber);
      announcer.finish("unused assignment \"%s\"", sl.result.c_str());
      it = statements.erase(it);
    } else if ((*it)->check(&isEmptyIf)) {
      StatementLister sl;
      sl.generatePredicates = false;
      (*it)->soak(&sl);
      announcer.start(lineNumber);
      announcer.finish("\"%s\" has no consequence.", sl.result.c_str());
      it = statements.erase(it);
    } else {
      ++it;
    }
  }
}

void MarkImpureLHS::inspect(const NumericVariableExpr &e) const {
  for (auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      symbol.isImpure = true;
      return;
    }
  }
}

void MarkImpureLHS::inspect(const StringVariableExpr &e) const {
  for (auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      symbol.isImpure = true;
      return;
    }
  }
}

void MarkImpureLHS::inspect(const NumericArrayExpr &e) const {
  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      symbol.isImpure = true;
      return;
    }
  }
}

void MarkImpureLHS::inspect(const StringArrayExpr &e) const {
  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      symbol.isImpure = true;
      return;
    }
  }
}

void MarkImpureAssignment::inspect(const Let &s) const {
  if (!s.rhs->check(&isPure)) {
    s.lhs->inspect(&markImpureLHS);
  }
}

void MarkImpureAssignment::inspect(const Accum &s) const {
  if (!s.rhs->check(&isPure)) {
    s.lhs->inspect(&markImpureLHS);
  }
}

void MarkImpureAssignment::inspect(const Decum &s) const {
  if (!s.rhs->check(&isPure)) {
    s.lhs->inspect(&markImpureLHS);
  }
}

void MarkImpureAssignment::inspect(const Necum &s) const {
  if (!s.rhs->check(&isPure)) {
    s.lhs->inspect(&markImpureLHS);
  }
}

bool IsPrunableLHS::inspect(const NumericVariableExpr &e) const {
  for (const auto &symbol : symbolTable.numVarTable) {
    if (symbol.name == e.varname) {
      return !symbol.isUsed;
    }
  }

  return false;
}

bool IsPrunableLHS::inspect(const StringVariableExpr &e) const {
  for (const auto &symbol : symbolTable.strVarTable) {
    if (symbol.name == e.varname) {
      return !symbol.isUsed;
    }
  }

  return false;
}

bool IsPrunableLHS::inspect(const NumericArrayExpr &e) const {
  for (const auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      return !symbol.isUsed && e.indices->check(&isPure);
    }
  }

  return false;
}

bool IsPrunableLHS::inspect(const StringArrayExpr &e) const {
  for (const auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      return !symbol.isUsed && e.indices->check(&isPure);
    }
  }

  return false;
}

bool IsPrunableAssignment::inspect(const Let &s) const {
  return s.lhs->check(&isPrunableLHS) && s.rhs->check(&isPure);
}
bool IsPrunableAssignment::inspect(const Accum &s) const {
  return s.lhs->check(&isPrunableLHS) && s.rhs->check(&isPure);
}
bool IsPrunableAssignment::inspect(const Decum &s) const {
  return s.lhs->check(&isPrunableLHS) && s.rhs->check(&isPure);
}
bool IsPrunableAssignment::inspect(const Necum &s) const {
  return s.lhs->check(&isPrunableLHS) && s.rhs->check(&isPure);
}
