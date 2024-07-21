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
  StatementBranchValidator sbv(lineNumbers, l.lineNumber, allowUnlisted);
  for (auto &statement : l.statements) {
    statement->mutate(&sbv);
  }
}

void StatementBranchValidator::mutate(If &s) {
  for (const auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementBranchValidator::mutate(Go &s) {
  validate(s.statementName(), s.lineNumber);
}

void StatementBranchValidator::mutate(When &s) {
  validate(s.statementName(), s.lineNumber);
}

void StatementBranchValidator::mutate(On &s) {
  for (int &branch : s.branchTable) {
    validate(s.statementName(), branch);
  }
}

void StatementBranchValidator::mutate(Run &s) {
  if (s.hasLineNumber) {
    validate(s.statementName(), s.lineNumber);
  }
}

void StatementBranchValidator::validate(const std::string &statementName,
                                        int &lineNumber) const {
  if (lineNumbers.find(lineNumber) == lineNumbers.end()) {
    if (allowUnlisted.isEnabled()) {
      announcer.start(currentLineNumber);
      announcer.finish("branch destination \"%i\" not found in %s statement.",
                       lineNumber, statementName.c_str());
      lineNumber = constants::unlistedLineNumber;
    } else {
      ulError(statementName, lineNumber);
    }
  }
}

void StatementBranchValidator::ulError(const std::string &statementName,
                                       int ulNumber) const {
  fprintf(stderr, "error at %s statement in line %i\n", statementName.c_str(),
          currentLineNumber);
  fprintf(stderr, "branch destination \"%i\" not found\n", ulNumber);
  fprintf(stderr,
          "use '-ul' enable run-time checking of unlisted line numbers.\n");
  exit(1);
}
