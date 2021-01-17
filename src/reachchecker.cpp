// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "reachchecker.hpp"

void ReachChecker::operate(Program &p) {
  itCurrentLine = p.lines.begin();
  while (itCurrentLine != p.lines.end()) {
    (*itCurrentLine)->operate(this);
    ++itCurrentLine;
  }
}

void ReachChecker::operate(Line &l) {
  auto gls = StatementReachChecker(itCurrentLine);
  for (auto &statement : l.statements) {
    gls.clear = false;
    statement->operate(&gls);
    if (!gls.ok && !gls.clear) {
      fprintf(stderr, "warning: %s statement not reached after %s at line %i\n",
              statement->statementName().c_str(), gls.terminator.c_str(),
              l.lineNumber);
      break;
    }
  }
}

void StatementReachChecker::operate(Go &s) {
  clear |= ok;
  ok &= s.isSub;
  if (!ok)
    terminator = s.statementName();
}

void StatementReachChecker::operate(Run &s) {
  clear |= ok;
  ok = false;
  terminator = s.statementName();
}

void StatementReachChecker::operate(End &s) {
  clear |= ok;
  ok = false;
  terminator = s.statementName();
}

void StatementReachChecker::operate(Stop &s) {
  clear |= ok;
  ok = false;
  terminator = s.statementName();
}

void StatementReachChecker::operate(Rem & /*statement*/) { clear = true; }

void StatementReachChecker::operate(Data & /*statement*/) { clear = true; }

void StatementReachChecker::operate(If &s) {
  for (auto &statement : s.consequent) {
    clear = false;
    statement->operate(this);
    if (!ok && !clear) {
      fprintf(stderr, "warning: %s statement not reached after %s at line %i\n",
              statement->statementName().c_str(), terminator.c_str(),
              (*itCurrentLine)->lineNumber);
      break;
    }
  }
}
