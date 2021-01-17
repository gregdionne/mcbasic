// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef ONMERGER_HPP
#define ONMERGER_HPP

#include "program.hpp"

// removes ON..GOTO and ON..GOSUB statements with constant argument

class OnStatementMerger : public StatementOp {
public:
  explicit OnStatementMerger(std::vector<std::unique_ptr<Line>>::iterator &it)
      : itCurrentLine(it), needsReplacement(false) {}
  void operate(If &s) override;
  void operate(On &s) override;

  using StatementOp::operate;

  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  bool needsReplacement;
  int replLine;
  bool isSub;
};

class OnMerger : public ProgramOp {
public:
  OnMerger() = default;
  void operate(Program &p) override;
  void operate(Line &l) override;

  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
