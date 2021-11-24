// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "onmerger.hpp"

#include <cmath>

void OnMerger::operate(Program &p) {
  itCurrentLine = p.lines.begin();
  while (itCurrentLine != p.lines.end()) {
    (*itCurrentLine)->operate(this);
    ++itCurrentLine;
  }
}

void OnMerger::operate(Line &l) {
  auto osm = OnStatementMerger(itCurrentLine, warner);
  auto it = l.statements.begin();
  while (it != l.statements.end()) {
    osm.needsReplacement = false;
    (*it)->operate(&osm);
    if (osm.needsReplacement) {
      warner.start((*itCurrentLine)->lineNumber);
      warner.say("%s ", (*it)->statementName().c_str());
      if (osm.replLine == -1) {
        it = l.statements.erase(it);
        warner.finish("removed.");
      } else {
        auto go = std::make_unique<Go>();
        go->isSub = osm.isSub;
        go->lineNumber = osm.replLine;
        *it = std::move(go);
        warner.finish("replaced with %s %i.", (*it)->statementName().c_str(),
                      osm.replLine);
        ++it;
      }
    } else {
      ++it;
    }
  }
}

void OnStatementMerger::operate(If &s) {
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

void OnStatementMerger::operate(On &s) {
  double item;
  if (s.branchIndex->isConst(item)) {
    item = std::floor(item);
    needsReplacement = true;
    isSub = s.isSub;
    replLine =
        item < 1 || item > s.branchTable.size() ? -1 : s.branchTable[item - 1];
  }
}
