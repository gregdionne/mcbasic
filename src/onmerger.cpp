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
  auto oms = OnStatementMerger(itCurrentLine);
  auto it = l.statements.begin();
  while (it != l.statements.end()) {
    (*it)->operate(&oms);
    if (oms.needsReplacement) {
      fprintf(stderr, "ON..GO%s ", oms.isSub ? "SUB" : "TO");
      if (oms.replLine == -1) {
        l.statements.erase(it);
        fprintf(stderr, "deleted ");
      } else {
        auto go = std::make_unique<Go>();
        go->isSub = oms.isSub;
        go->lineNumber = oms.replLine;
        *it = std::move(go);
        fprintf(stderr, "replaced with GO%s %i ", oms.isSub ? "SUB" : "TO",
                oms.replLine);
        ++it;
      }
      fprintf(stderr, "in line %i\n", (*itCurrentLine)->lineNumber);
    } else {
      ++it;
    }
  }
}

void OnStatementMerger::operate(If &s) {
  for (auto it = s.consequent.begin(); it != s.consequent.end(); ++it) {
    needsReplacement = false;
    (*it)->operate(this);
    if (needsReplacement) {
      fprintf(stderr, "ON..GO%s replaced ", isSub ? "SUB" : "TO");
      if (replLine == -1) {
        s.consequent.erase(it);
      } else {
        auto go = std::make_unique<Go>();
        go->isSub = isSub;
        go->lineNumber = replLine;
        *it = std::move(go);
        fprintf(stderr, "with GO%s %i ", isSub ? "SUB" : "TO", replLine);
      }
      fprintf(stderr, "in line %i\n", (*itCurrentLine)->lineNumber);
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
