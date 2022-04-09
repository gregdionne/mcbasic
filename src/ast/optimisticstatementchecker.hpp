// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_OPTIMISTICSTATEMENTCHECKER_HPP
#define AST_OPTIMISTICSTATEMENTCHECKER_HPP

#include "statement.hpp"

class OptimisticStatementChecker : public StatementInspector<bool> {
public:
  virtual bool inspect(const Rem & /*s*/) const { return true; }
  virtual bool inspect(const For & /*s*/) const { return true; }
  virtual bool inspect(const Go & /*s*/) const { return true; }
  virtual bool inspect(const When & /*s*/) const { return true; }
  virtual bool inspect(const If & /*s*/) const { return true; }
  virtual bool inspect(const Data & /*s*/) const { return true; }
  virtual bool inspect(const Print & /*s*/) const { return true; }
  virtual bool inspect(const Input & /*s*/) const { return true; }
  virtual bool inspect(const End & /*s*/) const { return true; }
  virtual bool inspect(const On & /*s*/) const { return true; }
  virtual bool inspect(const Next & /*s*/) const { return true; }
  virtual bool inspect(const Dim & /*s*/) const { return true; }
  virtual bool inspect(const Read & /*s*/) const { return true; }
  virtual bool inspect(const Let & /*s*/) const { return true; }
  virtual bool inspect(const Accum & /*s*/) const { return true; }
  virtual bool inspect(const Decum & /*s*/) const { return true; }
  virtual bool inspect(const Necum & /*s*/) const { return true; }
  virtual bool inspect(const Run & /*s*/) const { return true; }
  virtual bool inspect(const Restore & /*s*/) const { return true; }
  virtual bool inspect(const Return & /*s*/) const { return true; }
  virtual bool inspect(const Stop & /*s*/) const { return true; }
  virtual bool inspect(const Poke & /*s*/) const { return true; }
  virtual bool inspect(const Clear & /*s*/) const { return true; }
  virtual bool inspect(const Set & /*s*/) const { return true; }
  virtual bool inspect(const Reset & /*s*/) const { return true; }
  virtual bool inspect(const Cls & /*s*/) const { return true; }
  virtual bool inspect(const Sound & /*s*/) const { return true; }
  virtual bool inspect(const Exec & /*s*/) const { return true; }
  virtual bool inspect(const Error & /*s*/) const { return true; }
};

#endif
