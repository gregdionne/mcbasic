// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef BRANCHCHECKER_HPP
#define BRANCHCHECKER_HPP

#include <unordered_set>

#include "program.hpp"

// error if label not found for WHEN,THEN,GOTO,GOSUB,RUN

class StatementBranchChecker : public StatementOp {
public:
  StatementBranchChecker(std::unordered_set<int> &lineNums,
                         std::vector<std::unique_ptr<Line>>::iterator &it,
                         bool ul)
      : lineNumbers(lineNums), itCurrentLine(it), allowUnlisted(ul) {}
  void operate(If &s) override;
  void operate(Go &s) override;
  void operate(On &s) override;
  void operate(When &s) override;
  void operate(Run &s) override;

  using StatementOp::operate;

  std::unordered_set<int> lineNumbers;
  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  bool allowUnlisted;
};

class BranchChecker : public ProgramOp {
public:
  BranchChecker(bool ul) : allowUnlisted(ul) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  bool allowUnlisted;
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
  std::unordered_set<int> lineNumbers;
};

#endif
