// Copyright (C) 2022 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_WHENIFIER_HPP
#define OPTIMIZER_WHENIFIER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"

// replace IF .. THEN GOTO/GOSUB at end of line
// with WHEN .. GOTO/GOSUB
//
// This provides a hint to the compiler that
// the alternate branch can be omitted in favor
// of fallthrough to the next BASIC line.

class StatementWhenifier : public NullStatementTransmutator {
public:
  std::unique_ptr<Statement> mutate(If &s) override;

  void whenify(std::vector<std::unique_ptr<Statement>> &statements);

private:
  using NullStatementTransmutator::mutate;
};

class Whenifier : public ProgramOp {
public:
  void operate(Program &p) override;
  void operate(Line &l) override;
};

#endif
