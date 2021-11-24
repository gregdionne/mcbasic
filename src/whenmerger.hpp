// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef WHENMERGER_HPP
#define WHENMERGER_HPP

#include "program.hpp"
#include "warner.hpp"

// removes WHEN..GOTO and WHEN..GOSUB statements with constant argument

class WhenStatementMerger : public StatementOp {
public:
  WhenStatementMerger(std::vector<std::unique_ptr<Line>>::iterator &it,
                      Warner w)
      : itCurrentLine(it), warner(w) {}
  void operate(If &s) override;
  void operate(When &s) override;

  using StatementOp::operate;

  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  Warner warner;

  bool needsReplacement = false;
  int replLine = 0;
  bool isSub = false;
};

class WhenMerger : public ProgramOp {
public:
  WhenMerger(Warner w) : warner(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  Warner warner;
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
