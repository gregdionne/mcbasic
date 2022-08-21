// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "unusedassignmentpruner.hpp"
#include "ast/lister.hpp"
#include "dimpruner.hpp"
#include "impurityreaper.hpp"
#include "symboltable/symbolusagetabulator.hpp"

void UnusedAssignmentPruner::operate(Program &p) {
  bool pruned = false;
  do {
    SymbolUsageInspector sui(symbolTable);
    p.operate(&sui);

    for (auto &line : p.lines) {
      line->operate(this);
    }

    pruned = pruneUnusedSymbols(symbolTable);
    DimPruner dp(symbolTable, announcer);
    p.operate(&dp);
  } while (pruned);
}

void UnusedAssignmentPruner::operate(Line &l) {
  StatementUnusedAssignmentPruner sap(l.lineNumber, announcer, symbolTable);
  sap.prune(l.statements);
}

void StatementUnusedAssignmentPruner::mutate(If &s) { prune(s.consequent); }

bool IsEmptyIf::inspect(const If &s) const { return s.consequent.empty(); }

void StatementUnusedAssignmentPruner::prune(
    std::vector<up<Statement>> &statements) {
  StatementImpurityReaper impurityReaper;
  auto it = statements.begin();
  while (it != statements.end()) {
    (*it)->mutate(this);
    if ((*it)->check(&isUnusedAssignment)) {
      StatementLister sl;
      (*it)->soak(&sl);
      if (auto eval = (*it)->transmutate(&impurityReaper)) {
        *it = mv(eval);
      } else {
        // announce only if no side effects are needed
        announcer.start(lineNumber);
        announcer.finish("unused assignment \"%s\"", sl.result.c_str());
        it = statements.erase(it);
      }
    } else if ((*it)->check(&isEmptyIf)) {
      StatementLister sl;
      sl.generatePredicates = false;
      (*it)->soak(&sl);
      announcer.start(lineNumber);
      announcer.finish("\"%s\" has no consequent.", sl.result.c_str());
      if (auto eval = (*it)->transmutate(&impurityReaper)) {
        *it = mv(eval);
      } else {
        it = statements.erase(it);
      }
    } else {
      ++it;
    }
  }
}

bool IsUnusedAssignment::inspect(const Let &s) const {
  return s.lhs->check(&isUnusedSymbol);
}
bool IsUnusedAssignment::inspect(const Accum &s) const {
  return s.lhs->check(&isUnusedSymbol);
}
bool IsUnusedAssignment::inspect(const Decum &s) const {
  return s.lhs->check(&isUnusedSymbol);
}
bool IsUnusedAssignment::inspect(const Necum &s) const {
  return s.lhs->check(&isUnusedSymbol);
}
