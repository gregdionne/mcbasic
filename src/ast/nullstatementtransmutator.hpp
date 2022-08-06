// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTTRANSMUTATOR_HPP
#define AST_NULLSTATEMENTTRANSMUTATOR_HPP

#include "statement.hpp"

class NullStatementTransmutator : public StatementMutator<up<Statement>> {
public:
  NullStatementTransmutator() = default;
  NullStatementTransmutator(const NullStatementTransmutator &) = delete;
  NullStatementTransmutator(NullStatementTransmutator &&) = delete;
  NullStatementTransmutator &
  operator=(const NullStatementTransmutator &) = delete;
  NullStatementTransmutator &operator=(NullStatementTransmutator &&) = delete;
  ~NullStatementTransmutator() override = default;

  up<Statement> mutate(Rem & /*s*/) override { return {}; }
  up<Statement> mutate(For & /*s*/) override { return {}; }
  up<Statement> mutate(Go & /*s*/) override { return {}; }
  up<Statement> mutate(When & /*s*/) override { return {}; }
  up<Statement> mutate(If & /*s*/) override { return {}; }
  up<Statement> mutate(Data & /*s*/) override { return {}; }
  up<Statement> mutate(Print & /*s*/) override { return {}; }
  up<Statement> mutate(Input & /*s*/) override { return {}; }
  up<Statement> mutate(End & /*s*/) override { return {}; }
  up<Statement> mutate(On & /*s*/) override { return {}; }
  up<Statement> mutate(Next & /*s*/) override { return {}; }
  up<Statement> mutate(Dim & /*s*/) override { return {}; }
  up<Statement> mutate(Read & /*s*/) override { return {}; }
  up<Statement> mutate(Let & /*s*/) override { return {}; }
  up<Statement> mutate(Accum & /*s*/) override { return {}; }
  up<Statement> mutate(Decum & /*s*/) override { return {}; }
  up<Statement> mutate(Necum & /*s*/) override { return {}; }
  up<Statement> mutate(Run & /*s*/) override { return {}; }
  up<Statement> mutate(Restore & /*s*/) override { return {}; }
  up<Statement> mutate(Return & /*s*/) override { return {}; }
  up<Statement> mutate(Stop & /*s*/) override { return {}; }
  up<Statement> mutate(Poke & /*s*/) override { return {}; }
  up<Statement> mutate(Clear & /*s*/) override { return {}; }
  up<Statement> mutate(Set & /*s*/) override { return {}; }
  up<Statement> mutate(Reset & /*s*/) override { return {}; }
  up<Statement> mutate(Cls & /*s*/) override { return {}; }
  up<Statement> mutate(Sound & /*s*/) override { return {}; }
  up<Statement> mutate(Exec & /*s*/) override { return {}; }
  up<Statement> mutate(Error & /*s*/) override { return {}; }
};

#endif
