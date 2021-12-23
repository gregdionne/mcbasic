// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTMUTATOR_HPP
#define AST_NULLSTATEMENTMUTATOR_HPP

#include "statement.hpp"

class NullStatementMutator : public StatementMutator<void> {
public:
  virtual void mutate(Rem & /*s*/) override {}
  virtual void mutate(For & /*s*/) override {}
  virtual void mutate(Go & /*s*/) override {}
  virtual void mutate(When & /*s*/) override {}
  virtual void mutate(If & /*s*/) override {}
  virtual void mutate(Data & /*s*/) override {}
  virtual void mutate(Print & /*s*/) override {}
  virtual void mutate(Input & /*s*/) override {}
  virtual void mutate(End & /*s*/) override {}
  virtual void mutate(On & /*s*/) override {}
  virtual void mutate(Next & /*s*/) override {}
  virtual void mutate(Dim & /*s*/) override {}
  virtual void mutate(Read & /*s*/) override {}
  virtual void mutate(Let & /*s*/) override {}
  virtual void mutate(Inc & /*s*/) override {}
  virtual void mutate(Dec & /*s*/) override {}
  virtual void mutate(Run & /*s*/) override {}
  virtual void mutate(Restore & /*s*/) override {}
  virtual void mutate(Return & /*s*/) override {}
  virtual void mutate(Stop & /*s*/) override {}
  virtual void mutate(Poke & /*s*/) override {}
  virtual void mutate(Clear & /*s*/) override {}
  virtual void mutate(Set & /*s*/) override {}
  virtual void mutate(Reset & /*s*/) override {}
  virtual void mutate(Cls & /*s*/) override {}
  virtual void mutate(Sound & /*s*/) override {}
  virtual void mutate(Error & /*s*/) override {}
};

#endif
