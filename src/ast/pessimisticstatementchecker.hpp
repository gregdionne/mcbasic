// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef AST_PESSIMISTICSTATEMENTCHECKER_HPP
#define AST_PESSIMISTICSTATEMENTCHECKER_HPP

#include "statement.hpp"

class PessimisticStatementChecker : public StatementInspector<bool> {
public:
  PessimisticStatementChecker() = default;
  PessimisticStatementChecker(const PessimisticStatementChecker &) = delete;
  PessimisticStatementChecker(PessimisticStatementChecker &&) = delete;
  PessimisticStatementChecker &
  operator=(const PessimisticStatementChecker &) = delete;
  PessimisticStatementChecker &
  operator=(PessimisticStatementChecker &&) = delete;
  ~PessimisticStatementChecker() override = default;

  bool inspect(const Rem & /*s*/) const override { return false; }
  bool inspect(const For & /*s*/) const override { return false; }
  bool inspect(const Go & /*s*/) const override { return false; }
  bool inspect(const When & /*s*/) const override { return false; }
  bool inspect(const If & /*s*/) const override { return false; }
  bool inspect(const Data & /*s*/) const override { return false; }
  bool inspect(const Print & /*s*/) const override { return false; }
  bool inspect(const Input & /*s*/) const override { return false; }
  bool inspect(const End & /*s*/) const override { return false; }
  bool inspect(const On & /*s*/) const override { return false; }
  bool inspect(const Next & /*s*/) const override { return false; }
  bool inspect(const Dim & /*s*/) const override { return false; }
  bool inspect(const Read & /*s*/) const override { return false; }
  bool inspect(const Let & /*s*/) const override { return false; }
  bool inspect(const Accum & /*s*/) const override { return false; }
  bool inspect(const Decum & /*s*/) const override { return false; }
  bool inspect(const Necum & /*s*/) const override { return false; }
  bool inspect(const Eval & /*s*/) const override { return false; }
  bool inspect(const Run & /*s*/) const override { return false; }
  bool inspect(const Restore & /*s*/) const override { return false; }
  bool inspect(const Return & /*s*/) const override { return false; }
  bool inspect(const Stop & /*s*/) const override { return false; }
  bool inspect(const Poke & /*s*/) const override { return false; }
  bool inspect(const Clear & /*s*/) const override { return false; }
  bool inspect(const CLoadM & /*s*/) const override { return false; }
  bool inspect(const CLoadStar & /*s*/) const override { return false; }
  bool inspect(const CSaveStar & /*s*/) const override { return false; }
  bool inspect(const Set & /*s*/) const override { return false; }
  bool inspect(const Reset & /*s*/) const override { return false; }
  bool inspect(const Cls & /*s*/) const override { return false; }
  bool inspect(const Sound & /*s*/) const override { return false; }
  bool inspect(const Exec & /*s*/) const override { return false; }
  bool inspect(const Error & /*s*/) const override { return false; }
};

#endif
