// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "dimpruner.hpp"
#include "ast/lister.hpp"

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
    if ((*it)->check(&isMissingSymbol)) {
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
