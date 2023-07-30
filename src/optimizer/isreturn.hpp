// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISRETURN_HPP
#define OPTIMIZER_ISRETURN_HPP

#include "ast/pessimisticstatementchecker.hpp"

class IsReturnStatement : public PessimisticStatementChecker {
public:
  bool inspect(const Return & /*s*/) const override { return true; }

private:
  using PessimisticStatementChecker::inspect;
  std::string list(const Statement *s) const;
};

#endif
