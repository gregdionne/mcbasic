// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_BRANCHVALIDATOR_HPP
#define OPTIMIZER_BRANCHVALIDATOR_HPP

#include <unordered_set>

#include "ast/nullstatementinspector.hpp"
#include "ast/program.hpp"

// error if label not found for WHEN,THEN,GOTO,GOSUB,RUN

class StatementBranchValidator : public NullStatementInspector {
public:
  StatementBranchValidator(std::unordered_set<int> &lineNums, int curline,
                           bool ul)
      : lineNumbers(lineNums), currentLineNumber(curline), allowUnlisted(ul) {}
  void inspect(const If &s) const override;
  void inspect(const Go &s) const override;
  void inspect(const On &s) const override;
  void inspect(const When &s) const override;
  void inspect(const Run &s) const override;

  using NullStatementInspector::inspect;

private:
  void validate(const std::string &statementName, int lineNumber) const;
  void ulError(std::string statementName, int ulNumber) const;

  const std::unordered_set<int> &lineNumbers;
  const int currentLineNumber;
  const bool allowUnlisted;
};

class BranchValidator : public ProgramOp {
public:
  BranchValidator(bool ul) : allowUnlisted(ul) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  bool allowUnlisted;
  std::unordered_set<int> lineNumbers;
};

#endif
