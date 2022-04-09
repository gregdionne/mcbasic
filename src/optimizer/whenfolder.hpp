// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_WHENFOLDER_HPP
#define OPTIMIZER_WHENFOLDER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// removes WHEN..GOTO and WHEN..GOSUB statements with constant argument

class WhenStatementFolder : public NullStatementTransmutator {
public:
  WhenStatementFolder(int linenum, const Announcer &w)
      : lineNumber(linenum), announcer(w) {}
  up<Statement> mutate(If &s) override;
  up<Statement> mutate(When &s) override;

  void fold(std::vector<up<Statement>> &statements);
  const int lineNumber;
  const Announcer &announcer;

private:
  using NullStatementTransmutator::mutate;
};

class WhenFolder : public ProgramOp {
public:
  WhenFolder(Announcer &&w) : announcer(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  const Announcer announcer;
  std::vector<up<Line>>::iterator itCurrentLine;
};

#endif
