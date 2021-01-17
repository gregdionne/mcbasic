// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef REACHCHECKER_HPP
#define REACHCHECKER_HPP

#include "program.hpp"

// warn when an executable statement follows GOTO,END, or STOP
// REM and DATA statements are not considered executable

class StatementReachChecker : public StatementOp {
public:
  explicit StatementReachChecker(
      std::vector<std::unique_ptr<Line>>::iterator &it)
      : itCurrentLine(it), clear(false), ok(true) {}
  void operate(If &s) override;
  void operate(Go &s) override;
  void operate(Run &s) override;
  void operate(Stop &s) override;
  void operate(End &s) override;
  void operate(Data &s) override;
  void operate(Rem &s) override;

  using StatementOp::operate;

  std::vector<std::unique_ptr<Line>>::iterator &itCurrentLine;
  bool clear;
  bool ok;
  std::string terminator;
};

class ReachChecker : public ProgramOp {
public:
  ReachChecker() = default;
  void operate(Program &p) override;
  void operate(Line &l) override;

  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
