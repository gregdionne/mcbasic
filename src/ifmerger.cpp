// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "ifmerger.hpp"

#include <cmath>

void IfMerger::operate(Program &p) {
  itCurrentLine = p.lines.begin();
  while (itCurrentLine != p.lines.end()) {
    (*itCurrentLine)->operate(this);
    ++itCurrentLine;
  }
}

void IfMerger::operate(Line &l) {
  auto ism = IfStatementMerger(itCurrentLine, warner);
  auto it = l.statements.begin();
  while (it != l.statements.end()) {
    ism.needsReplacement = false;
    (*it)->operate(&ism);
    if (ism.needsReplacement) {
      warner.start((*itCurrentLine)->lineNumber);
      warner.finish("%s %s.", (*it)->statementName().c_str(),
                    ism.replacement.empty() ? "entirely optimized away"
                                            : "replaced with consequent");
      auto numInserted = ism.replacement.end() - ism.replacement.begin();
      it = l.statements.insert(l.statements.erase(it),
                               std::make_move_iterator(ism.replacement.begin()),
                               std::make_move_iterator(ism.replacement.end()));
      it += numInserted;
    } else {
      ++it;
    }
  }
}

void IfStatementMerger::operate(If &s) {
  // process consequent first...
  auto it = s.consequent.begin();
  while (it != s.consequent.end()) {
    needsReplacement = false;
    (*it)->operate(this);
    if (needsReplacement) {
      warner.start((*itCurrentLine)->lineNumber);
      warner.finish("%s %s.", (*it)->statementName().c_str(),
                    replacement.empty() ? "entirely optimized away"
                                        : "replaced with consequent");
      auto numInserted = replacement.end() - replacement.begin();
      it = s.consequent.insert(s.consequent.erase(it),
                               std::make_move_iterator(replacement.begin()),
                               std::make_move_iterator(replacement.end()));
      it += numInserted;
    } else {
      ++it;
    }
  }

  double value = 0;
  bool gotPredicate = s.predicate->isConst(value);

  if (gotPredicate && value != 0) {
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
