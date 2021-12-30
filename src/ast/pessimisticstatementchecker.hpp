// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_PESSIMISTICSTATEMENTCHECKER_HPP
#define AST_PESSIMISTICSTATEMENTCHECKER_HPP

#include "statement.hpp"

class PessimisticStatementChecker : public StatementInspector<bool> {
public:
  virtual bool inspect(const Rem & /*s*/) const { return false; }
  virtual bool inspect(const For & /*s*/) const { return false; }
  virtual bool inspect(const Go & /*s*/) const { return false; }
  virtual bool inspect(const When & /*s*/) const { return false; }
  virtual bool inspect(const If & /*s*/) const { return false; }
  virtual bool inspect(const Data & /*s*/) const { return false; }
  virtual bool inspect(const Print & /*s*/) const { return false; }
  virtual bool inspect(const Input & /*s*/) const { return false; }
  virtual bool inspect(const End & /*s*/) const { return false; }
  virtual bool inspect(const On & /*s*/) const { return false; }
  virtual bool inspect(const Next & /*s*/) const { return false; }
  virtual bool inspect(const Dim & /*s*/) const { return false; }
  virtual bool inspect(const Read & /*s*/) const { return false; }
  virtual bool inspect(const Let & /*s*/) const { return false; }
  virtual bool inspect(const Inc & /*s*/) const { return false; }
  virtual bool inspect(const Dec & /*s*/) const { return false; }
  virtual bool inspect(const Run & /*s*/) const { return false; }
  virtual bool inspect(const Restore & /*s*/) const { return false; }
  virtual bool inspect(const Return & /*s*/) const { return false; }
  virtual bool inspect(const Stop & /*s*/) const { return false; }
  virtual bool inspect(const Poke & /*s*/) const { return false; }
  virtual bool inspect(const Clear & /*s*/) const { return false; }
  virtual bool inspect(const Set & /*s*/) const { return false; }
  virtual bool inspect(const Reset & /*s*/) const { return false; }
  virtual bool inspect(const Cls & /*s*/) const { return false; }
  virtual bool inspect(const Sound & /*s*/) const { return false; }
  virtual bool inspect(const Exec & /*s*/) const { return false; }
  virtual bool inspect(const Error & /*s*/) const { return false; }
};

#endif
