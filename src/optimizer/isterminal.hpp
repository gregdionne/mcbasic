// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISTERMINAL_HPP
#define OPTIMIZER_ISTERMINAL_HPP

#include "ast/pessimisticstatementchecker.hpp"

class IsTerminalStatement : public PessimisticStatementChecker {
public:
  bool inspect(const Go &s) const override { return !s.isSub; }
  bool inspect(const Run & /*s*/) const override { return true; }
  bool inspect(const Stop & /*s*/) const override { return true; }
  bool inspect(const End & /*s*/) const override { return true; }
  bool inspect(const Error & /*s*/) const override { return true; }

private:
  using PessimisticStatementChecker::inspect;
};

#endif
