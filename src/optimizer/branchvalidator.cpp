// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "branchvalidator.hpp"
#include "mcbasic/constants.hpp"

void BranchValidator::operate(Program &p) {

  for (auto &line : p.lines) {
    lineNumbers.insert(line->lineNumber);
  }

  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void BranchValidator::operate(Line &l) {
  auto sbc = StatementBranchValidator(lineNumbers, l.lineNumber, allowUnlisted);
  for (auto &statement : l.statements) {
    statement->inspect(&sbc);
  }
}

void StatementBranchValidator::inspect(const If &s) const {
  for (auto &statement : s.consequent) {
    statement->inspect(this);
  }
}

void StatementBranchValidator::inspect(const Go &s) const {
  validate(s.statementName(), s.lineNumber);
}

void StatementBranchValidator::inspect(const When &s) const {
  validate(s.statementName(), s.lineNumber);
}

void StatementBranchValidator::inspect(const On &s) const {
  for (const int &branch : s.branchTable) {
    validate(s.statementName(), branch);
  }
}

void StatementBranchValidator::inspect(const Run &s) const {
  if (s.hasLineNumber) {
    validate(s.statementName(), s.lineNumber);
  }
}

void StatementBranchValidator::validate(const std::string &statementName,
                                        int lineNumber) const {
  if (lineNumbers.find(lineNumber) == lineNumbers.end()) {
    if (allowUnlisted) {
      lineNumber = constants::unlistedLineNumber;
    } else {
      ulError(statementName, lineNumber);
    }
  }
}

void StatementBranchValidator::ulError(std::string statementName,
                                       int ulNumber) const {
  fprintf(stderr, "error at %s statement in line %i\n", statementName.c_str(),
          currentLineNumber);
  fprintf(stderr, "branch destination \"%i\" not found\n", ulNumber);
  fprintf(stderr,
          "use '-ul' enable run-time checking of unlisted line numbers.\n");
  exit(1);
}
