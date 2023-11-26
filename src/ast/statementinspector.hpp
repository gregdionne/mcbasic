// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_STATEMENTINSPECTOR_HPP
#define AST_STATEMENTINSPECTOR_HPP

#include "fwddeclstatement.hpp"

// StatementInspector
//   provide a result of examination

template <typename T> class StatementInspector {
public:
  StatementInspector() = default;
  StatementInspector(const StatementInspector &) = delete;
  StatementInspector(StatementInspector &&) = delete;
  StatementInspector &operator=(const StatementInspector &) = delete;
  StatementInspector &operator=(StatementInspector &&) = delete;
  virtual ~StatementInspector() = default;

  virtual T inspect(const Rem & /*s*/) const = 0;
  virtual T inspect(const For & /*s*/) const = 0;
  virtual T inspect(const Go & /*s*/) const = 0;
  virtual T inspect(const When & /*s*/) const = 0;
  virtual T inspect(const If & /*s*/) const = 0;
  virtual T inspect(const Data & /*s*/) const = 0;
  virtual T inspect(const Print & /*s*/) const = 0;
  virtual T inspect(const Input & /*s*/) const = 0;
  virtual T inspect(const End & /*s*/) const = 0;
  virtual T inspect(const On & /*s*/) const = 0;
  virtual T inspect(const Next & /*s*/) const = 0;
  virtual T inspect(const Dim & /*s*/) const = 0;
  virtual T inspect(const Read & /*s*/) const = 0;
  virtual T inspect(const Let & /*s*/) const = 0;
  virtual T inspect(const Accum & /*s*/) const = 0;
  virtual T inspect(const Decum & /*s*/) const = 0;
  virtual T inspect(const Necum & /*s*/) const = 0;
  virtual T inspect(const Eval & /*s*/) const = 0;
  virtual T inspect(const Run & /*s*/) const = 0;
  virtual T inspect(const Restore & /*s*/) const = 0;
  virtual T inspect(const Return & /*s*/) const = 0;
  virtual T inspect(const Stop & /*s*/) const = 0;
  virtual T inspect(const Poke & /*s*/) const = 0;
  virtual T inspect(const Clear & /*s*/) const = 0;
  virtual T inspect(const CLoadM & /*s*/) const = 0;
  virtual T inspect(const CLoadStar & /*s*/) const = 0;
  virtual T inspect(const CSaveStar & /*s*/) const = 0;
  virtual T inspect(const Set & /*s*/) const = 0;
  virtual T inspect(const Reset & /*s*/) const = 0;
  virtual T inspect(const Cls & /*s*/) const = 0;
  virtual T inspect(const Sound & /*s*/) const = 0;
  virtual T inspect(const Exec & /*s*/) const = 0;
  virtual T inspect(const Error & /*s*/) const = 0;
};

#endif
