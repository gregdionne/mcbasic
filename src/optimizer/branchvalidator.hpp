// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_BRANCHVALIDATOR_HPP
#define OPTIMIZER_BRANCHVALIDATOR_HPP

#include <unordered_set>

#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"
#include "utils/binaryoption.hpp"

// error if label not found for WHEN,THEN,GOTO,GOSUB,RUN

class StatementBranchValidator : public NullStatementMutator {
public:
  StatementBranchValidator(std::unordered_set<int> &lineNums, int curline,
                           const BinaryOption &ul)
      : lineNumbers(lineNums), currentLineNumber(curline), allowUnlisted(ul),
        announcer(ul) {}
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
  const BinaryOption &allowUnlisted;
  const Announcer announcer;
};

class BranchValidator : public ProgramOp {
public:
  explicit BranchValidator(const BinaryOption &ul) : allowUnlisted(ul) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const BinaryOption &allowUnlisted;
  std::unordered_set<int> lineNumbers;
};

#endif
