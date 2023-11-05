// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_UNREACHEDSTATEMENTPRUNER_HPP
#define OPTIMIZER_UNREACHEDSTATEMENTPRUNER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/optimisticstatementchecker.hpp"
#include "ast/pessimisticstatementchecker.hpp"
#include "ast/program.hpp"
#include "utils/announcer.hpp"

// remove executable statements following GOTO,END, or STOP
// REM and DATA statements are not considered executable

class StatementUnreachedPruner : public NullStatementMutator {
public:
  explicit StatementUnreachedPruner(const Announcer &a, int linenum)
      : announcer(a), lineNumber(linenum) {}
  void mutate(If &s) override;
  void prune(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;
  const Announcer &announcer;
  const int lineNumber;
};

class UnreachedStatementPruner : public ProgramOp {
public:
  explicit UnreachedStatementPruner(const BinaryOption &option)
      : announcer(option) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const Announcer announcer;
};

#endif
