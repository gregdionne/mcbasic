// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_REACHCHECKER_HPP
#define OPTIMIZER_REACHCHECKER_HPP

#include "ast/nullstatementinspector.hpp"
#include "ast/optimisticstatementchecker.hpp"
#include "ast/pessimisticstatementchecker.hpp"
#include "ast/program.hpp"

// warn when an executable statement follows GOTO,END, or STOP
// REM and DATA statements are not considered executable

class StatementReachChecker : public NullStatementInspector {
public:
  explicit StatementReachChecker(int linenum) : lineNumber(linenum) {}
  void inspect(const If &s) const override;

  using NullStatementInspector::inspect;
  void validate(const std::vector<up<Statement>> &statements) const;

private:
  int lineNumber;
};

class ReachChecker : public ProgramOp {
public:
  void operate(Program &p) override;
  void operate(Line &l) override;
};

#endif
