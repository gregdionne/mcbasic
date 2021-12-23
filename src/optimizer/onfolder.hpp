// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ONMERGER_HPP
#define OPTIMIZER_ONMERGER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/warner.hpp"

// removes ON..GOTO and ON..GOSUB statements with constant argument

class OnStatementFolder : public NullStatementTransmutator {
public:
  OnStatementFolder(int linenum, Warner w) : lineNumber(linenum), warner(w) {}
  std::unique_ptr<Statement> mutate(If &s) override;
  std::unique_ptr<Statement> mutate(On &s) override;

  using NullStatementTransmutator::mutate;

  void fold(std::vector<std::unique_ptr<Statement>> &statements);
  const int lineNumber;
  const Warner warner;
};

class OnFolder : public ProgramOp {
public:
  OnFolder(Warner w) : warner(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  const Warner warner;
};

#endif
