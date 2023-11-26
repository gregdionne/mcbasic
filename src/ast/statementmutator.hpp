// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_STATEMENTMUTATOR_HPP
#define AST_STATEMENTMUTATOR_HPP

#include "fwddeclstatement.hpp"

// StatementMutater
//   change a statement in-place

template <typename T> class StatementMutator {
public:
  StatementMutator() = default;
  StatementMutator(const StatementMutator &) = delete;
  StatementMutator(StatementMutator &&) = delete;
  StatementMutator &operator=(const StatementMutator &) = delete;
  StatementMutator &operator=(StatementMutator &&) = delete;
  virtual ~StatementMutator() = default;

  virtual T mutate(Rem & /*s*/) = 0;
  virtual T mutate(For & /*s*/) = 0;
  virtual T mutate(Go & /*s*/) = 0;
  virtual T mutate(When & /*s*/) = 0;
  virtual T mutate(If & /*s*/) = 0;
  virtual T mutate(Data & /*s*/) = 0;
  virtual T mutate(Print & /*s*/) = 0;
  virtual T mutate(Input & /*s*/) = 0;
  virtual T mutate(End & /*s*/) = 0;
  virtual T mutate(On & /*s*/) = 0;
  virtual T mutate(Next & /*s*/) = 0;
  virtual T mutate(Dim & /*s*/) = 0;
  virtual T mutate(Read & /*s*/) = 0;
  virtual T mutate(Let & /*s*/) = 0;
  virtual T mutate(Accum & /*s*/) = 0;
  virtual T mutate(Decum & /*s*/) = 0;
  virtual T mutate(Necum & /*s*/) = 0;
  virtual T mutate(Eval & /*s*/) = 0;
  virtual T mutate(Run & /*s*/) = 0;
  virtual T mutate(Restore & /*s*/) = 0;
  virtual T mutate(Return & /*s*/) = 0;
  virtual T mutate(Stop & /*s*/) = 0;
  virtual T mutate(Poke & /*s*/) = 0;
  virtual T mutate(Clear & /*s*/) = 0;
  virtual T mutate(CLoadM & /*s*/) = 0;
  virtual T mutate(CLoadStar & /*s*/) = 0;
  virtual T mutate(CSaveStar & /*s*/) = 0;
  virtual T mutate(Set & /*s*/) = 0;
  virtual T mutate(Reset & /*s*/) = 0;
  virtual T mutate(Cls & /*s*/) = 0;
  virtual T mutate(Sound & /*s*/) = 0;
  virtual T mutate(Exec & /*s*/) = 0;
  virtual T mutate(Error & /*s*/) = 0;
};

#endif
