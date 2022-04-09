// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "whenifier.hpp"

void Whenifier::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Whenifier::operate(Line &l) {
  auto gls = StatementWhenifier(announcer, l.lineNumber);
  gls.whenify(l.statements);
}

up<Statement> StatementWhenifier::mutate(If &s) {

  if (s.consequent.size() == 1) {
    if (auto *go = dynamic_cast<Go *>(s.consequent.back().get())) {
      announcer.start(lineNumber);
      announcer.finish("trailing IF..%s replaced with WHEN..%s",
                       go->statementName().c_str(),
                       go->statementName().c_str());
      auto when = makeup<When>();
      when->isSub = go->isSub;
      when->predicate = mv(s.predicate);
      when->lineNumber = go->lineNumber;
      return when;
    }
  }

  whenify(s.consequent);

  return up<Statement>();
}

void StatementWhenifier::whenify(std::vector<up<Statement>> &statements) {
  for (auto &statement : statements) {
    if (auto when = statement->transmutate(this)) {
      statement = mv(when);
    }
  }
}
