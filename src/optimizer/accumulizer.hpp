// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ACCUMULIZER_HPP
#define OPTIMIZER_ACCUMULIZER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"

// perform transformations:
//    Let X = X + expression -> X += expression
//    Let X = X - expression -> X -= expression
//
// where X may be a numeric variable or array reference.

class Accumulizer : public ProgramOp {
public:
  Accumulizer() = default;
  void operate(Program &p) override;
  void operate(Line &l) override;
  std::unique_ptr<Statement> accumulant;
};

class StatementAccumulizer : public NullStatementTransmutator {
public:
  std::unique_ptr<Statement> mutate(If &s) override;
  std::unique_ptr<Statement> mutate(Let &s) override;

  void accumulize(std::vector<std::unique_ptr<Statement>> &statements);

private:
  using NullStatementTransmutator::mutate;
};

#endif
