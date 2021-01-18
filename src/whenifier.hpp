// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#ifndef WHENIFIER_HPP
#define WHENIFIER_HPP

#include "program.hpp"

// replace IF .. THEN GOTO/GOSUB at end of line
// with WHEN .. GOTO/GOSUB
//
// This provides a hint to the compiler that
// the alternate branch can be omitted in favor
// of fallthrough to the next BASIC line.

class StatementWhenifier : public StatementOp {
public:
  StatementWhenifier() = default;
  void operate(If &s) override;
  using StatementOp::operate;

  bool result{false};

  bool isSub{false};
  std::unique_ptr<NumericExpr> predicate;
  int lineNumber{0};
};

class Whenifier : public ProgramOp {
public:
  Whenifier() = default;
  void operate(Program &p) override;
  void operate(Line &l) override;

  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
