// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ISEXECUTABLE_HPP
#define OPTIMIZER_ISEXECUTABLE_HPP

#include "ast/statement.hpp"

class IsExecutableStatement : public OptimisticStatementChecker {
public:
  bool inspect(const Rem &) const override { return false; }
  bool inspect(const Data &) const override { return false; }

private:
  using OptimisticStatementChecker::inspect;
};

#endif
