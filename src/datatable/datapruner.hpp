// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef DATATABLE_DATAPRUNER_HPP
#define DATATABLE_DATAPRUNER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/pessimisticstatementchecker.hpp"
#include "ast/program.hpp"

// Excise DATA from the program AST

class IsDataStatementChecker : public PessimisticStatementChecker {
public:
  bool inspect(const Data & /*s*/) const { return true; };

private:
  using PessimisticStatementChecker::inspect;
};

class DataPruner : public ProgramOp {
public:
  void operate(Program &p) override;
  void operate(Line &l) override;
};

class StatementDataPruner : public NullStatementMutator {
public:
  void mutate(If &s) override;
  void prune(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;
  IsDataStatementChecker isData;
};

#endif
