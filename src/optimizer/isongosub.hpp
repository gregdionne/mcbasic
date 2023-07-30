// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISONGOSUB_HPP
#define OPTIMIZER_ISONGOSUB_HPP

#include "ast/pessimisticstatementchecker.hpp"

// returns true if statement is GOSUB
class IsOnGosubStatement : public PessimisticStatementChecker {
public:
  bool inspect(const On &s) const override { return s.isSub; }

private:
  using PessimisticStatementChecker::inspect;
};

#endif
