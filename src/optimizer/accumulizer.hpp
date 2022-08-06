// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ACCUMULIZER_HPP
#define OPTIMIZER_ACCUMULIZER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// perform transformations:
//    Let X = X + expression -> X += expression
//    Let X = X - expression -> X -= expression
//
// where X may be a numeric variable or array reference.

class Accumulizer : public ProgramOp {
public:
  explicit Accumulizer(const Announcer &&a) : announcer(a) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  up<Statement> accumulant;
  const Announcer announcer;
};

class StatementAccumulizer : public NullStatementTransmutator {
public:
  StatementAccumulizer(const Announcer &a, int linenum)
      : announcer(a), lineNumber(linenum) {}
  up<Statement> mutate(If &s) override;
  up<Statement> mutate(Let &s) override;

  void accumulize(std::vector<up<Statement>> &statements);

private:
  using NullStatementTransmutator::mutate;
  const Announcer &announcer;
  const int lineNumber;
};

#endif
