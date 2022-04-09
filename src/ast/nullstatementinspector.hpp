// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTINSPECTOR_HPP
#define AST_NULLSTATEMENTINSPECTOR_HPP

#include "statement.hpp"

class NullStatementInspector : public StatementInspector<void> {
public:
  virtual void inspect(const Rem & /*s*/) const override {}
  virtual void inspect(const For & /*s*/) const override {}
  virtual void inspect(const Go & /*s*/) const override {}
  virtual void inspect(const When & /*s*/) const override {}
  virtual void inspect(const If & /*s*/) const override {}
  virtual void inspect(const Data & /*s*/) const override {}
  virtual void inspect(const Print & /*s*/) const override {}
  virtual void inspect(const Input & /*s*/) const override {}
  virtual void inspect(const End & /*s*/) const override {}
  virtual void inspect(const On & /*s*/) const override {}
  virtual void inspect(const Next & /*s*/) const override {}
  virtual void inspect(const Dim & /*s*/) const override {}
  virtual void inspect(const Read & /*s*/) const override {}
  virtual void inspect(const Let & /*s*/) const override {}
  virtual void inspect(const Accum & /*s*/) const override {}
  virtual void inspect(const Decum & /*s*/) const override {}
  virtual void inspect(const Necum & /*s*/) const override {}
  virtual void inspect(const Run & /*s*/) const override {}
  virtual void inspect(const Restore & /*s*/) const override {}
  virtual void inspect(const Return & /*s*/) const override {}
  virtual void inspect(const Stop & /*s*/) const override {}
  virtual void inspect(const Poke & /*s*/) const override {}
  virtual void inspect(const Clear & /*s*/) const override {}
  virtual void inspect(const Set & /*s*/) const override {}
  virtual void inspect(const Reset & /*s*/) const override {}
  virtual void inspect(const Cls & /*s*/) const override {}
  virtual void inspect(const Sound & /*s*/) const override {}
  virtual void inspect(const Exec & /*s*/) const override {}
  virtual void inspect(const Error & /*s*/) const override {}
};

#endif
