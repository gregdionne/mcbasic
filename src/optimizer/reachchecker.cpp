// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "reachchecker.hpp"
#include "isexecutable.hpp"
#include "isterminal.hpp"

void ReachChecker::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void ReachChecker::operate(Line &l) {
  auto gls = StatementReachChecker(l.lineNumber);
  gls.validate(l.statements);
}

void StatementReachChecker::inspect(const If &s) const {
  validate(s.consequent);
}

void StatementReachChecker::validate(
    const std::vector<up<Statement>> &statements) const {

  IsExecutableStatement isExecutable;
  IsTerminalStatement isTerminal;

  std::string terminator;

  for (auto &statement : statements) {
    if (statement->check(&isExecutable) && !terminator.empty()) {
      fprintf(stderr, "warning: %s statement not reached after %s at line %i\n",
              statement->statementName().c_str(), terminator.c_str(),
              lineNumber);
      break;
    }

    if (statement->check(&isTerminal)) {
      terminator = statement->statementName();
    }
  }
}
