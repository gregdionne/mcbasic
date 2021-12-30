// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "onfolder.hpp"
#include "constinspector.hpp"

#include <cmath>

void OnFolder::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void OnFolder::operate(Line &l) {
  auto osf = OnStatementFolder(l.lineNumber, announcer);
  osf.fold(l.statements);
}

std::unique_ptr<Statement> OnStatementFolder::mutate(If &s) {
  fold(s.consequent);
  return std::unique_ptr<Statement>();
}

std::unique_ptr<Statement> OnStatementFolder::mutate(On &s) {
  ConstInspector constInspector;
  if (auto value = s.branchIndex->constify(&constInspector)) {
    double item = std::floor(*value);

    auto go = std::make_unique<Go>();
    go->isSub = s.isSub;
    go->lineNumber =
        item < 1 || item > s.branchTable.size() ? -1 : s.branchTable[item - 1];
    return go;
  }

  return std::unique_ptr<Statement>();
}

void OnStatementFolder::fold(
    std::vector<std::unique_ptr<Statement>> &statements) {
  auto it = statements.begin();
  while (it != statements.end()) {
    if (auto statement = (*it)->mutate(this)) {
      announcer.start(lineNumber);
      announcer.say("%s ", (*it)->statementName().c_str());
      auto *go = dynamic_cast<Go *>(statement.get());
      if (go == nullptr || go->lineNumber == -1) {
        it = statements.erase(it);
        announcer.finish("removed.");
      } else {
        announcer.finish("replaced with %s %i.", go->statementName().c_str(),
                         go->lineNumber);
        *it = std::move(statement);
        ++it;
      }
    } else {
      ++it;
    }
  }
}
