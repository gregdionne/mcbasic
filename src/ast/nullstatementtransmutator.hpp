// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTTRANSMUTATOR_HPP
#define AST_NULLSTATEMENTTRANSMUTATOR_HPP

#include "statement.hpp"

class NullStatementTransmutator
    : public StatementMutator<std::unique_ptr<Statement>> {
public:
  virtual std::unique_ptr<Statement> mutate(Rem & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(For & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Go & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(When & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(If & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Data & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Print & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Input & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(End & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(On & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Next & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Dim & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Read & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Let & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Inc & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Dec & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Run & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Restore & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Return & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Stop & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Poke & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Clear & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Set & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Reset & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Cls & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Sound & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Exec & /*s*/) {
    return std::unique_ptr<Statement>();
  }
  virtual std::unique_ptr<Statement> mutate(Error & /*s*/) {
    return std::unique_ptr<Statement>();
  }
};

#endif
