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
  auto wsf = WhenStatementFolder(l.lineNumber, warner);
  wsf.fold(l.statements);
}

std::unique_ptr<Statement> WhenStatementFolder::mutate(If &s) {
  fold(s.consequent);
  return std::unique_ptr<Statement>();
}

std::unique_ptr<Statement> WhenStatementFolder::mutate(When &s) {
  ConstInspector constInspector;
  if (auto predicate = s.predicate->constify(&constInspector)) {
    auto go = std::make_unique<Go>();
    go->isSub = s.isSub;
    go->lineNumber = *predicate == 0 ? -1 : s.lineNumber;
    return go;
  }
  return std::unique_ptr<Statement>();
}

void WhenStatementFolder::fold(
    std::vector<std::unique_ptr<Statement>> &statements) {
  auto it = statements.begin();
  while (it != statements.end()) {
    if (auto statement = (*it)->mutate(this)) {
      warner.start(lineNumber);
      warner.say("%s ", (*it)->statementName().c_str());
      auto *go = dynamic_cast<Go *>(statement.get());
      if (go == nullptr || go->lineNumber == -1) {
        it = statements.erase(it);
        warner.finish("removed.");
      } else {
        warner.finish("replaced with %s %i.", go->statementName().c_str(),
                      go->lineNumber);
        *it = std::move(statement);
        ++it;
      }
    } else {
      ++it;
    }
  }
}
