// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef ONMERGER_HPP
#define ONMERGER_HPP

#include "program.hpp"
#include "warner.hpp"

// removes ON..GOTO and ON..GOSUB statements with constant argument

class OnStatementMerger : public StatementOp {
public:
  OnStatementMerger(std::vector<std::unique_ptr<Line>>::iterator &it, Warner w)
      : itCurrentLine(it), warner(w) {}
  void operate(If &s) override;
  void operate(On &s) override;

  using StatementOp::operate;

  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  Warner warner;

  bool needsReplacement = false;
  int replLine = 0;
  bool isSub = false;
};

class OnMerger : public ProgramOp {
public:
  OnMerger(Warner w) : warner(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  Warner warner;
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
