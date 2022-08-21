// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTMUTATOR_HPP
#define AST_NULLSTATEMENTMUTATOR_HPP

#include "statement.hpp"

class NullStatementMutator : public StatementMutator<void> {
public:
  NullStatementMutator() = default;
  NullStatementMutator(const NullStatementMutator &) = delete;
  NullStatementMutator(NullStatementMutator &&) = delete;
  NullStatementMutator &operator=(const NullStatementMutator &) = delete;
  NullStatementMutator &operator=(NullStatementMutator &&) = delete;
  ~NullStatementMutator() override = default;

  void mutate(Rem & /*s*/) override {}
  void mutate(For & /*s*/) override {}
  void mutate(Go & /*s*/) override {}
  void mutate(When & /*s*/) override {}
  void mutate(If & /*s*/) override {}
  void mutate(Data & /*s*/) override {}
  void mutate(Print & /*s*/) override {}
  void mutate(Input & /*s*/) override {}
  void mutate(End & /*s*/) override {}
  void mutate(On & /*s*/) override {}
  void mutate(Next & /*s*/) override {}
  void mutate(Dim & /*s*/) override {}
  void mutate(Read & /*s*/) override {}
  void mutate(Let & /*s*/) override {}
  void mutate(Accum & /*s*/) override {}
  void mutate(Decum & /*s*/) override {}
  void mutate(Necum & /*s*/) override {}
  void mutate(Eval & /*s*/) override {}
  void mutate(Run & /*s*/) override {}
  void mutate(Restore & /*s*/) override {}
  void mutate(Return & /*s*/) override {}
  void mutate(Stop & /*s*/) override {}
  void mutate(Poke & /*s*/) override {}
  void mutate(Clear & /*s*/) override {}
  void mutate(Set & /*s*/) override {}
  void mutate(Reset & /*s*/) override {}
  void mutate(Cls & /*s*/) override {}
  void mutate(Sound & /*s*/) override {}
  void mutate(Exec & /*s*/) override {}
  void mutate(Error & /*s*/) override {}
};

#endif
