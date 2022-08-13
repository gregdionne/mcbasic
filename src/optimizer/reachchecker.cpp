// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "reachchecker.hpp"
#include "ast/lister.hpp"
#include "isexecutable.hpp"
#include "isterminal.hpp"

void ReachChecker::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void ReachChecker::operate(Line &l) {
  StatementReachChecker src(announcer, l.lineNumber);
  src.validate(l.statements);
}

void StatementReachChecker::inspect(const If &s) const {
  validate(s.consequent);
}

void StatementReachChecker::validate(
    const std::vector<up<Statement>> &statements) const {

  IsExecutableStatement isExecutable;
  IsTerminalStatement isTerminal;

  std::string terminator;

  for (const auto &statement : statements) {
    if (statement->check(&isExecutable) && !terminator.empty()) {
      announcer.start(lineNumber);
      announcer.say("%s statement not reached after %s\n",
                    statement->statementName().c_str(), terminator.c_str());
      break;
    }

    if (statement->check(&isTerminal)) {
      StatementLister sl;
      statement->soak(&sl);
      terminator = sl.result;
    }
  }
}
