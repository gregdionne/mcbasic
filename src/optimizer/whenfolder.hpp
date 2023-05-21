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
  WhenStatementFolder(int linenum, const Announcer &a)
      : lineNumber(linenum), announcer(a) {}
  up<Statement> mutate(If &s) override;
  up<Statement> mutate(When &s) override;

  void fold(std::vector<up<Statement>> &statements);

private:
  using NullStatementTransmutator::mutate;

  const int lineNumber;
  const Announcer &announcer;
};

class WhenFolder : public ProgramOp {
public:
  explicit WhenFolder(const BinaryOption &option) : announcer(option) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
  std::vector<up<Line>>::iterator itCurrentLine;
};

#endif
