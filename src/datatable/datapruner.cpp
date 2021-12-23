// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "datapruner.hpp"

void DataPruner::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void DataPruner::operate(Line &l) {
  StatementDataPruner that;
  that.prune(l.statements);
}

void StatementDataPruner::mutate(If &s) { prune(s.consequent); }

void StatementDataPruner::prune(
    std::vector<std::unique_ptr<Statement>> &statements) {

  auto it = statements.begin();
  while (it != statements.end()) {

    // recursively prune any IF
    (*it)->mutate(this);

    // remove DATA statement
    if ((*it)->check(&isData)) {
      it = statements.erase(it);
    } else {
      ++it;
    }
  }
}
