// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_WHENIFIER_HPP
#define OPTIMIZER_WHENIFIER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// replace IF .. THEN GOTO/GOSUB at end of line
// with WHEN .. GOTO/GOSUB
//
// This provides a hint to the compiler that
// the alternate branch can be omitted in favor
// of fallthrough to the next BASIC line.

class StatementWhenifier : public NullStatementTransmutator {
public:
  StatementWhenifier(const Announcer &a, int linenum)
      : announcer(a), lineNumber(linenum) {}
  up<Statement> mutate(If &s) override;

  void whenify(std::vector<up<Statement>> &statements);

private:
  using NullStatementTransmutator::mutate;
  const Announcer &announcer;
  const int lineNumber;
};

class Whenifier : public ProgramOp {
public:
  explicit Whenifier(const BinaryOption &option) : announcer(option) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
};

#endif
