// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTTRANSMUTATOR_HPP
#define AST_NULLSTATEMENTTRANSMUTATOR_HPP

#include "statement.hpp"

class NullStatementTransmutator : public StatementMutator<up<Statement>> {
public:
  virtual up<Statement> mutate(Rem & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(For & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Go & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(When & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(If & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Data & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Print & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Input & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(End & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(On & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Next & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Dim & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Read & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Let & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Accum & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Decum & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Necum & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Run & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Restore & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Return & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Stop & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Poke & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Clear & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Set & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Reset & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Cls & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Sound & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Exec & /*s*/) { return up<Statement>(); }
  virtual up<Statement> mutate(Error & /*s*/) { return up<Statement>(); }
};

#endif
