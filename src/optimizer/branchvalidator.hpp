// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_BRANCHVALIDATOR_HPP
#define OPTIMIZER_BRANCHVALIDATOR_HPP

#include <unordered_set>

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "utils/option.hpp"

// error if label not found for WHEN,THEN,GOTO,GOSUB,RUN

class StatementBranchValidator : public NullStatementMutator {
public:
  StatementBranchValidator(std::unordered_set<int> &lineNums, int curline,
                           const Option &ul)
      : lineNumbers(lineNums), currentLineNumber(curline), allowUnlisted(ul) {}
  void mutate(If &s) override;
  void mutate(Go &s) override;
  void mutate(On &s) override;
  void mutate(When &s) override;
  void mutate(Run &s) override;

  using NullStatementMutator::mutate;

private:
  void validate(const std::string &statementName, int &lineNumber) const;
  void ulError(const std::string &statementName, int ulNumber) const;

  const std::unordered_set<int> &lineNumbers;
  const int currentLineNumber;
  const Option &allowUnlisted;
};

class BranchValidator : public ProgramOp {
public:
  explicit BranchValidator(const Option &ul) : allowUnlisted(ul) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Option &allowUnlisted;
  std::unordered_set<int> lineNumbers;
};

#endif
