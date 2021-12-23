// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_WHENFOLDER_HPP
#define OPTIMIZER_WHENFOLDER_HPP

#include "ast/nullstatementtransmutator.hpp"
#include "ast/program.hpp"
#include "utils/warner.hpp"

// removes WHEN..GOTO and WHEN..GOSUB statements with constant argument

class WhenStatementFolder : public NullStatementTransmutator {
public:
  WhenStatementFolder(int linenum, const Warner &w)
      : lineNumber(linenum), warner(w) {}
  std::unique_ptr<Statement> mutate(If &s) override;
  std::unique_ptr<Statement> mutate(When &s) override;

  void fold(std::vector<std::unique_ptr<Statement>> &statements);
  const int lineNumber;
  const Warner &warner;

private:
  using NullStatementTransmutator::mutate;
};

class WhenFolder : public ProgramOp {
public:
  WhenFolder(Warner w) : warner(w) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

  const Warner warner;
  std::vector<std::unique_ptr<Line>>::iterator itCurrentLine;
};

#endif
