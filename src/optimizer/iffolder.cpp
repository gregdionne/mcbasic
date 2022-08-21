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
  IfStatementFolder iff(l.lineNumber, announcer);
  iff.fold(l.statements);
}

void IfStatementFolder::mutate(If &s) {
  // process consequent first...
  fold(s.consequent);

  ConstInspector constInspector;
  auto value = s.predicate->constify(&constInspector);
  needsReplacement = value.has_value();

  if (needsReplacement) {
    replacement.clear();
    if (*value != 0) {
      replacement.insert(replacement.begin(),
                         std::make_move_iterator(s.consequent.begin()),
                         std::make_move_iterator(s.consequent.end()));
    }

    return;
  }

  needsReplacement = false;
}

void IfStatementFolder::fold(std::vector<up<Statement>> &statements) {
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
