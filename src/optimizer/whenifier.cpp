// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "whenifier.hpp"

void Whenifier::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Whenifier::operate(Line &l) {
  auto gls = StatementWhenifier();
  gls.whenify(l.statements);
}

std::unique_ptr<Statement> StatementWhenifier::mutate(If &s) {

  if (s.consequent.size() == 1) {
    if (auto *go = dynamic_cast<Go *>(s.consequent.back().get())) {
      auto when = std::make_unique<When>();
      when->isSub = go->isSub;
      when->predicate = std::move(s.predicate);
      when->lineNumber = go->lineNumber;
      return when;
    }
  }

  whenify(s.consequent);

  return std::unique_ptr<Statement>();
}

void StatementWhenifier::whenify(
    std::vector<std::unique_ptr<Statement>> &statements) {
  for (auto &statement : statements) {
    if (auto when = statement->mutate(this)) {
      statement = std::move(when);
    }
  }
}
