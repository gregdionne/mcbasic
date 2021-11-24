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
  auto it = l.statements.begin();
  while (it != l.statements.end()) {
    if (boperate(it->get(), &that)) {
      it = l.statements.erase(it);
    } else {
      ++it;
    }
  }
}

void StatementDataPruner::operate(Data & /*statement*/) { result = true; }

void StatementDataPruner::operate(If &s) {
  auto it = s.consequent.begin();
  while (it != s.consequent.end()) {
    if (boperate(it->get(), this)) {
      it = s.consequent.erase(it);
      result = false;
    } else {
      ++it;
    }
  }
}
