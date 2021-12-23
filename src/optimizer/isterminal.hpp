// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISTERMINAL_HPP
#define OPTIMIZER_ISTERMINAL_HPP

#include "ast/statement.hpp"

class IsTerminalStatement : public PessimisticStatementChecker {
public:
  bool inspect(const Go &s) const override { return !s.isSub; }
  bool inspect(const Run &) const override { return true; }
  bool inspect(const Stop &) const override { return true; }
  bool inspect(const End &) const override { return true; }
  bool inspect(const Error &) const override { return true; }

private:
  using PessimisticStatementChecker::inspect;
};

#endif
