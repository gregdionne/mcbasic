// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISGOSUB_HPP
#define OPTIMIZER_ISGOSUB_HPP

#include "ast/pessimisticstatementchecker.hpp"

// returns true if statement is GOSUB
class IsGosubStatement : public PessimisticStatementChecker {
public:
  bool inspect(const Go &s) const override { return s.isSub; }

private:
  using PessimisticStatementChecker::inspect;
};

#endif
