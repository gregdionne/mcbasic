// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_REACHCHECKER_HPP
#define OPTIMIZER_REACHCHECKER_HPP

#include "ast/nullstatementinspector.hpp"
#include "ast/optimisticstatementchecker.hpp"
#include "ast/pessimisticstatementchecker.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// warn when an executable statement follows GOTO,END, or STOP
// REM and DATA statements are not considered executable

class StatementReachChecker : public NullStatementInspector {
public:
  explicit StatementReachChecker(const Announcer &a, int linenum)
      : announcer(a), lineNumber(linenum) {}
  void inspect(const If &s) const override;
  void validate(const std::vector<up<Statement>> &statements) const;

private:
  using NullStatementInspector::inspect;
  const Announcer &announcer;
  const int lineNumber;
};

class ReachChecker : public ProgramOp {
public:
  explicit ReachChecker(const Announcer &&a) : announcer(a) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
};

#endif
