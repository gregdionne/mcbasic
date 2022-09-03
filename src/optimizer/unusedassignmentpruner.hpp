// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_UNUSEDASSIGNMENTPRUNER_HPP
#define OPTIMIZER_UNUSEDASSIGNMENTPRUNER_HPP

#include "ast/nullstatementmutator.hpp"
#include "ast/pessimisticstatementchecker.hpp"
#include "ast/program.hpp"
#include "symboltable/isunusedsymbol.hpp"
#include "symboltable/symboltable.hpp"
#include "utils/announcer.hpp"

// returns true if IF statement has no consequent
class IsEmptyIf : public PessimisticStatementChecker {
public:
  bool inspect(const If &s) const override;

private:
  using PessimisticStatementChecker::inspect;
};

// returns true when left-hand side is unused
class IsUnusedAssignment : public PessimisticStatementChecker {
public:
  explicit IsUnusedAssignment(SymbolTable &st) : isUnusedSymbol(st) {}
  bool inspect(const Let &s) const override;
  bool inspect(const Accum &s) const override;
  bool inspect(const Decum &s) const override;
  bool inspect(const Necum &s) const override;
  using PessimisticStatementChecker::inspect;

private:
  IsUnusedSymbol isUnusedSymbol;
};

// removes unused assignment statements
// use EVAL statement to preserve side effects
class StatementUnusedAssignmentPruner : public NullStatementMutator {
public:
  StatementUnusedAssignmentPruner(int linenum, const Announcer &a,
                                  SymbolTable &st)
      : lineNumber(linenum), announcer(a), isUnusedAssignment(st) {}
  void mutate(If &s) override;

  void prune(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;
  const int lineNumber;
  const Announcer &announcer;
  const IsUnusedAssignment isUnusedAssignment;
  const IsEmptyIf isEmptyIf;
};

// removes unused assignments from program
class UnusedAssignmentPruner : public ProgramOp {
public:
  explicit UnusedAssignmentPruner(SymbolTable &st, const Option &option)
      : symbolTable(st), announcer(option) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  void prunePureUnusedSymbols(std::vector<Symbol> &table);
  SymbolTable &symbolTable;
  const Announcer announcer;
};

#endif
