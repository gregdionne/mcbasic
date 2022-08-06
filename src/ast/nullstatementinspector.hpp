// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_NULLSTATEMENTINSPECTOR_HPP
#define AST_NULLSTATEMENTINSPECTOR_HPP

#include "statement.hpp"

class NullStatementInspector : public StatementInspector<void> {
public:
  NullStatementInspector() = default;
  NullStatementInspector(const NullStatementInspector &) = delete;
  NullStatementInspector(NullStatementInspector &&) = delete;
  NullStatementInspector &operator=(const NullStatementInspector &) = delete;
  NullStatementInspector &operator=(NullStatementInspector &&) = delete;
  ~NullStatementInspector() override = default;

  void inspect(const Rem & /*s*/) const override {}
  void inspect(const For & /*s*/) const override {}
  void inspect(const Go & /*s*/) const override {}
  void inspect(const When & /*s*/) const override {}
  void inspect(const If & /*s*/) const override {}
  void inspect(const Data & /*s*/) const override {}
  void inspect(const Print & /*s*/) const override {}
  void inspect(const Input & /*s*/) const override {}
  void inspect(const End & /*s*/) const override {}
  void inspect(const On & /*s*/) const override {}
  void inspect(const Next & /*s*/) const override {}
  void inspect(const Dim & /*s*/) const override {}
  void inspect(const Read & /*s*/) const override {}
  void inspect(const Let & /*s*/) const override {}
  void inspect(const Accum & /*s*/) const override {}
  void inspect(const Decum & /*s*/) const override {}
  void inspect(const Necum & /*s*/) const override {}
  void inspect(const Run & /*s*/) const override {}
  void inspect(const Restore & /*s*/) const override {}
  void inspect(const Return & /*s*/) const override {}
  void inspect(const Stop & /*s*/) const override {}
  void inspect(const Poke & /*s*/) const override {}
  void inspect(const Clear & /*s*/) const override {}
  void inspect(const Set & /*s*/) const override {}
  void inspect(const Reset & /*s*/) const override {}
  void inspect(const Cls & /*s*/) const override {}
  void inspect(const Sound & /*s*/) const override {}
  void inspect(const Exec & /*s*/) const override {}
  void inspect(const Error & /*s*/) const override {}
};

#endif
