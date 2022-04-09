// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "whenfolder.hpp"
#include "constinspector.hpp"

void WhenFolder::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void WhenFolder::operate(Line &l) {
  auto wsf = WhenStatementFolder(l.lineNumber, announcer);
  wsf.fold(l.statements);
}

up<Statement> WhenStatementFolder::mutate(If &s) {
  fold(s.consequent);
  return up<Statement>();
}

up<Statement> WhenStatementFolder::mutate(When &s) {
  ConstInspector constInspector;
  if (auto predicate = s.predicate->constify(&constInspector)) {
    auto go = makeup<Go>();
    go->isSub = s.isSub;
    go->lineNumber = *predicate == 0 ? -1 : s.lineNumber;
    return go;
  }
  return up<Statement>();
}

void WhenStatementFolder::fold(std::vector<up<Statement>> &statements) {
  auto it = statements.begin();
  while (it != statements.end()) {
    if (auto statement = (*it)->transmutate(this)) {
      announcer.start(lineNumber);
      announcer.say("%s ", (*it)->statementName().c_str());
      auto *go = dynamic_cast<Go *>(statement.get());
      if (go == nullptr || go->lineNumber == -1) {
        it = statements.erase(it);
        announcer.finish("removed.");
      } else {
        announcer.finish("replaced with %s %i.", go->statementName().c_str(),
                         go->lineNumber);
        *it = mv(statement);
        ++it;
      }
    } else {
      ++it;
    }
  }
}
