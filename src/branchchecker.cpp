// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "branchchecker.hpp"
#include "constants.hpp"

static bool missing(int lineNumber,
                    const std::unordered_set<int> &lineNumbers) {
  return lineNumbers.find(lineNumber) == lineNumbers.end();
}

void BranchChecker::operate(Program &p) {

  for (auto &line : p.lines) {
    lineNumbers.insert(line->lineNumber);
  }

  itCurrentLine = p.lines.begin();
  while (itCurrentLine != p.lines.end()) {
    (*itCurrentLine)->operate(this);
    ++itCurrentLine;
  }
}

void BranchChecker::operate(Line &l) {
  auto sbc = StatementBranchChecker(lineNumbers, itCurrentLine, allowUnlisted);
  for (auto &statement : l.statements) {
    statement->operate(&sbc);
  }
}

void StatementBranchChecker::operate(Go &s) {
  if (missing(s.lineNumber, lineNumbers)) {
    if (allowUnlisted) {
      s.lineNumber = constants::unlistedLineNumber;
    } else {
      fprintf(stderr, "error at GO%s statement in line %i\n",
              s.isSub ? "SUB" : "TO", (*itCurrentLine)->lineNumber);
      fprintf(stderr, "branch destination \"%i\" not found\n", s.lineNumber);
      exit(1);
    }
  }
}

void StatementBranchChecker::operate(When &s) {
  if (missing(s.lineNumber, lineNumbers)) {
    if (allowUnlisted) {
      s.lineNumber = constants::unlistedLineNumber;
    } else {
      fprintf(stderr, "error at GO%s statement in line %i\n",
              s.isSub ? "SUB" : "TO", (*itCurrentLine)->lineNumber);
      fprintf(stderr, "branch destination \"%i\" not found\n", s.lineNumber);
      exit(1);
    }
  }
}

void StatementBranchChecker::operate(On &s) {
  for (int &branch : s.branchTable) {
    if (missing(branch, lineNumbers)) {
      if (allowUnlisted) {
        branch = constants::unlistedLineNumber;
      } else {
        fprintf(
            stderr,
            "error in branch destination of ON..GO%s statement in line %i\n",
            s.isSub ? "SUB" : "TO", (*itCurrentLine)->lineNumber);
        fprintf(stderr, "branch destination \"%i\" not found\n", branch);
        exit(1);
      }
    }
  }
}

void StatementBranchChecker::operate(Run &s) {
  if (s.hasLineNumber && missing(s.lineNumber, lineNumbers)) {
    if (allowUnlisted) {
      s.lineNumber = constants::unlistedLineNumber;
    } else {
      fprintf(stderr, "error at RUN statement in line %i\n",
              (*itCurrentLine)->lineNumber);
      fprintf(stderr, "branch destination \"%i\" not found\n", s.lineNumber);
      exit(1);
    }
  }
}

void StatementBranchChecker::operate(If &s) {
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}
