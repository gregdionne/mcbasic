// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_STATEMENTABSORBER_HPP
#define AST_STATEMENTABSORBER_HPP

#include "fwddeclstatement.hpp"

// StatementAbsorber
//   changes state as a result of examination

template <typename T> class StatementAbsorber {
public:
  StatementAbsorber() = default;
  StatementAbsorber(const StatementAbsorber &) = delete;
  StatementAbsorber(StatementAbsorber &&) = delete;
  StatementAbsorber &operator=(const StatementAbsorber &) = delete;
  StatementAbsorber &operator=(StatementAbsorber &&) = delete;
  virtual ~StatementAbsorber() = default;

  virtual T absorb(const Rem & /*s*/) = 0;
  virtual T absorb(const For & /*s*/) = 0;
  virtual T absorb(const Go & /*s*/) = 0;
  virtual T absorb(const When & /*s*/) = 0;
  virtual T absorb(const If & /*s*/) = 0;
  virtual T absorb(const Data & /*s*/) = 0;
  virtual T absorb(const Print & /*s*/) = 0;
  virtual T absorb(const Input & /*s*/) = 0;
  virtual T absorb(const End & /*s*/) = 0;
  virtual T absorb(const On & /*s*/) = 0;
  virtual T absorb(const Next & /*s*/) = 0;
  virtual T absorb(const Dim & /*s*/) = 0;
  virtual T absorb(const Read & /*s*/) = 0;
  virtual T absorb(const Let & /*s*/) = 0;
  virtual T absorb(const Accum & /*s*/) = 0;
  virtual T absorb(const Decum & /*s*/) = 0;
  virtual T absorb(const Necum & /*s*/) = 0;
  virtual T absorb(const Eval & /*s*/) = 0;
  virtual T absorb(const Run & /*s*/) = 0;
  virtual T absorb(const Restore & /*s*/) = 0;
  virtual T absorb(const Return & /*s*/) = 0;
  virtual T absorb(const Stop & /*s*/) = 0;
  virtual T absorb(const Poke & /*s*/) = 0;
  virtual T absorb(const Clear & /*s*/) = 0;
  virtual T absorb(const CLoadM & /*s*/) = 0;
  virtual T absorb(const CLoadStar & /*s*/) = 0;
  virtual T absorb(const CSaveStar & /*s*/) = 0;
  virtual T absorb(const Set & /*s*/) = 0;
  virtual T absorb(const Reset & /*s*/) = 0;
  virtual T absorb(const Cls & /*s*/) = 0;
  virtual T absorb(const Sound & /*s*/) = 0;
  virtual T absorb(const Exec & /*s*/) = 0;
  virtual T absorb(const Error & /*s*/) = 0;
};

#endif
