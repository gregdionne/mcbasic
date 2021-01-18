// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "whenifier.hpp"

template <typename T>
static inline bool boperate(T &thing, StatementWhenifier *whenifier) {
  whenifier->result = false;
  thing->operate(whenifier);
  return whenifier->result;
}

static inline std::unique_ptr<When> whenify(StatementWhenifier &gls) {
  auto when = std::make_unique<When>();
  when->isSub = gls.isSub;
  when->predicate = std::move(gls.predicate);
  when->lineNumber = gls.lineNumber;
  return when;
}

void Whenifier::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Whenifier::operate(Line &l) {
  auto gls = StatementWhenifier();
  for (auto &statement : l.statements) {
    if (boperate(statement, &gls)) {
      statement = whenify(gls);
    }
  }
}

void StatementWhenifier::operate(If &s) {

  if (s.consequent.size() == 1) {
    auto *go = dynamic_cast<Go *>(s.consequent.back().get());
    if (go != nullptr) {
      isSub = go->isSub;
      predicate = std::move(s.predicate);
      lineNumber = go->lineNumber;
      result = true;
      return;
    }
  }

  auto gls = StatementWhenifier();
  for (auto &statement : s.consequent) {
    if (boperate(statement, &gls)) {
      statement = whenify(gls);
      result = false;
    }
  }
}
