// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "iffolder.hpp"
#include "constinspector.hpp"

#include <cmath>

void IfFolder::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void IfFolder::operate(Line &l) {
  auto iff = IfStatementFolder(l.lineNumber, announcer);
  iff.fold(l.statements);
}

void IfStatementFolder::mutate(If &s) {
  // process consequent first...
  fold(s.consequent);

  ConstInspector constInspector;
  auto value = s.predicate->constify(&constInspector);
  bool gotPredicate = value.has_value();

  if (gotPredicate && *value != 0) {
    needsReplacement = true;
    replacement.clear();
    replacement.insert(replacement.begin(),
                       std::make_move_iterator(s.consequent.begin()),
                       std::make_move_iterator(s.consequent.end()));
    return;
  }

  if (gotPredicate || s.consequent.empty()) {
    needsReplacement = true;
    replacement.clear();
    return;
  }

  needsReplacement = false;
}

void IfStatementFolder::fold(
    std::vector<std::unique_ptr<Statement>> &statements) {
  auto it = statements.begin();
  while (it != statements.end()) {
    needsReplacement = false;
    (*it)->mutate(this);
    if (needsReplacement) {
      announcer.start(lineNumber);
      announcer.finish("%s %s.", (*it)->statementName().c_str(),
                       replacement.empty() ? "entirely optimized away"
                                           : "replaced with consequent");
      auto numInserted = replacement.end() - replacement.begin();
      it = statements.insert(statements.erase(it),
                             std::make_move_iterator(replacement.begin()),
                             std::make_move_iterator(replacement.end()));
      it += numInserted;
    } else {
      ++it;
    }
  }
}
