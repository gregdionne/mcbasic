// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_OPTIMISTICSTATEMENTCHECKER_HPP
#define AST_OPTIMISTICSTATEMENTCHECKER_HPP

#include "statement.hpp"

class OptimisticStatementChecker : public StatementInspector<bool> {
public:
  OptimisticStatementChecker() = default;
  OptimisticStatementChecker(const OptimisticStatementChecker &) = delete;
  OptimisticStatementChecker(OptimisticStatementChecker &&) = delete;
  OptimisticStatementChecker &
  operator=(const OptimisticStatementChecker &) = delete;
  OptimisticStatementChecker &operator=(OptimisticStatementChecker &&) = delete;
  ~OptimisticStatementChecker() override = default;

  bool inspect(const Rem & /*s*/) const override { return true; }
  bool inspect(const For & /*s*/) const override { return true; }
  bool inspect(const Go & /*s*/) const override { return true; }
  bool inspect(const When & /*s*/) const override { return true; }
  bool inspect(const If & /*s*/) const override { return true; }
  bool inspect(const Data & /*s*/) const override { return true; }
  bool inspect(const Print & /*s*/) const override { return true; }
  bool inspect(const Input & /*s*/) const override { return true; }
  bool inspect(const End & /*s*/) const override { return true; }
  bool inspect(const On & /*s*/) const override { return true; }
  bool inspect(const Next & /*s*/) const override { return true; }
  bool inspect(const Dim & /*s*/) const override { return true; }
  bool inspect(const Read & /*s*/) const override { return true; }
  bool inspect(const Let & /*s*/) const override { return true; }
  bool inspect(const Accum & /*s*/) const override { return true; }
  bool inspect(const Decum & /*s*/) const override { return true; }
  bool inspect(const Necum & /*s*/) const override { return true; }
  bool inspect(const Eval & /*s*/) const override { return true; }
  bool inspect(const Run & /*s*/) const override { return true; }
  bool inspect(const Restore & /*s*/) const override { return true; }
  bool inspect(const Return & /*s*/) const override { return true; }
  bool inspect(const Stop & /*s*/) const override { return true; }
  bool inspect(const Poke & /*s*/) const override { return true; }
  bool inspect(const Clear & /*s*/) const override { return true; }
  bool inspect(const Set & /*s*/) const override { return true; }
  bool inspect(const Reset & /*s*/) const override { return true; }
  bool inspect(const Cls & /*s*/) const override { return true; }
  bool inspect(const Sound & /*s*/) const override { return true; }
  bool inspect(const Exec & /*s*/) const override { return true; }
  bool inspect(const Error & /*s*/) const override { return true; }
};

#endif
