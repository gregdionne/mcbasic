// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ONMERGER_HPP
#define OPTIMIZER_ONMERGER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// removes ON..GOTO and ON..GOSUB statements with constant argument

class OnStatementFolder : public NullStatementTransmutator {
public:
  OnStatementFolder(int linenum, Announcer w)
      : lineNumber(linenum), announcer(w) {}
  up<Statement> mutate(If &s) override;
  up<Statement> mutate(On &s) override;

  using NullStatementTransmutator::mutate;

  void fold(std::vector<up<Statement>> &statements);
  const int lineNumber;
  const Announcer announcer;
};

class OnFolder : public ProgramOp {
public:
  OnFolder(Announcer &&w) : announcer(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  const Announcer announcer;
};

#endif
