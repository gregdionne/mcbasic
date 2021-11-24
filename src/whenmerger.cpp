// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "whenmerger.hpp"

void WhenMerger::operate(Program &p) {
  itCurrentLine = p.lines.begin();
  while (itCurrentLine != p.lines.end()) {
    (*itCurrentLine)->operate(this);
    ++itCurrentLine;
  }
}

void WhenMerger::operate(Line &l) {
  auto wsm = WhenStatementMerger(itCurrentLine, warner);
  auto it = l.statements.begin();
  while (it != l.statements.end()) {
    wsm.needsReplacement = false;
    (*it)->operate(&wsm);
    if (wsm.needsReplacement) {
      warner.start((*itCurrentLine)->lineNumber);
      warner.say("%s ", (*it)->statementName().c_str());
      if (wsm.replLine == -1) {
        it = l.statements.erase(it);
        warner.finish("removed.");
      } else {
        auto go = std::make_unique<Go>();
        go->isSub = wsm.isSub;
        go->lineNumber = wsm.replLine;
        *it = std::move(go);
        warner.finish("replaced with %s %i.", (*it)->statementName().c_str(),
                      wsm.replLine);
        ++it;
      }
    } else {
      ++it;
    }
  }
}

void WhenStatementMerger::operate(If &s) {
  auto it = s.consequent.begin();
  while (it != s.consequent.end()) {
    needsReplacement = false;
    (*it)->operate(this);
    if (needsReplacement) {
      warner.start((*itCurrentLine)->lineNumber);
      warner.say("%s ", (*it)->statementName().c_str());
      if (replLine == -1) {
        it = s.consequent.erase(it);
        warner.finish("removed.");
      } else {
        auto go = std::make_unique<Go>();
        go->isSub = isSub;
        go->lineNumber = replLine;
        *it = std::move(go);
        warner.finish("replaced with %s %i.", (*it)->statementName().c_str(),
                      replLine);
        ++it;
      }
    } else {
      ++it;
    }
  }
}

void WhenStatementMerger::operate(When &s) {
  double predicate;
  if (s.predicate->isConst(predicate)) {
    needsReplacement = true;
    isSub = s.isSub;
    replLine = predicate == 0 ? -1 : s.lineNumber;
  }
}
