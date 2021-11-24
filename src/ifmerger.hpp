// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef IFMERGER_HPP
#define IFMERGER_HPP

#include "program.hpp"
#include "warner.hpp"

// removes IF..THEN statements with constant argument

class IfStatementMerger : public StatementOp {
public:
  IfStatementMerger(std::vector<std::unique_ptr<Line>>::iterator &it, Warner &w)
      : itCurrentLine(it), warner(w) {}
  void operate(If &s) override;

  using StatementOp::operate;

  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  Warner warner;
  bool needsReplacement = false;
  std::vector<std::unique_ptr<Statement>> replacement;
};

class IfMerger : public ProgramOp {
public:
  explicit IfMerger(Warner w) : warner(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  Warner warner;
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
