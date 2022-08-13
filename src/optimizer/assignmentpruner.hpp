// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_ASSIGNMENTPRUNER_HPP
#define OPTIMIZER_ASSIGNMENTPRUNER_HPP

#include "ast/nullexprinspector.hpp"
#include "ast/nullstatementinspector.hpp"
#include "ast/nullstatementmutator.hpp"
#include "ast/pessimisticexprchecker.hpp"
#include "ast/pessimisticstatementchecker.hpp"
#include "ast/program.hpp"
#include "ispure.hpp"
#include "symboltable/symboltable.hpp"
#include "utils/announcer.hpp"

// returns true if IF statement has no consequence
class IsEmptyIf : public PessimisticStatementChecker {
public:
  bool inspect(const If &s) const override;

private:
  using PessimisticStatementChecker::inspect;
};

class MarkImpureLHS : public NullExprInspector {
public:
  explicit MarkImpureLHS(SymbolTable &st) : symbolTable(st) {}
  void inspect(const NumericVariableExpr &e) const override;
  void inspect(const StringVariableExpr &e) const override;
  void inspect(const NumericArrayExpr &e) const override;
  void inspect(const StringArrayExpr &e) const override;

private:
  using NullExprInspector::inspect;
  SymbolTable &symbolTable;
};

// marks assignments with side-effects
class MarkImpureAssignment : public NullStatementInspector {
public:
  explicit MarkImpureAssignment(SymbolTable &st) : markImpureLHS(st) {}

private:
  using NullStatementInspector::inspect;
  void inspect(const Let &s) const override;
  void inspect(const Accum &s) const override;
  void inspect(const Decum &s) const override;
  void inspect(const Necum &s) const override;
  const MarkImpureLHS markImpureLHS;
  const IsPure isPure;
};

// returns true for left-hand side of assignments to
// 1. variables that are never read
// 2. arrays that are never read and whose indices have no side effects
class IsPrunableLHS : public PessimisticExprChecker {
public:
  explicit IsPrunableLHS(const SymbolTable &st) : symbolTable(st) {}
  bool inspect(const NumericVariableExpr &e) const override;
  bool inspect(const StringVariableExpr &e) const override;
  bool inspect(const NumericArrayExpr &e) const override;
  bool inspect(const StringArrayExpr &e) const override;

private:
  using PessimisticExprChecker::inspect;
  const SymbolTable &symbolTable;
  const IsPure isPure;
};

// returns true when left-hand side is prunable and right hand side is pure
class IsPrunableAssignment : public PessimisticStatementChecker {
public:
  explicit IsPrunableAssignment(SymbolTable &st) : isPrunableLHS(st) {}
  bool inspect(const Let &s) const override;
  bool inspect(const Accum &s) const override;
  bool inspect(const Decum &s) const override;
  bool inspect(const Necum &s) const override;
  using PessimisticStatementChecker::inspect;

private:
  const IsPure isPure;
  IsPrunableLHS isPrunableLHS;
};

// removes prunable assignment statements
class StatementAssignmentPruner : public NullStatementMutator {
public:
  StatementAssignmentPruner(int linenum, const Announcer &a, SymbolTable &st)
      : lineNumber(linenum), announcer(a), isPrunableAssignment(st),
        markImpureAssignment(st) {}
  void mutate(If &s) override;

  void prune(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;
  const int lineNumber;
  const Announcer &announcer;
  const IsPrunableAssignment isPrunableAssignment;
  const MarkImpureAssignment markImpureAssignment;
  const IsEmptyIf isEmptyIf;
};

// removes prunable assignments from program
class AssignmentPruner : public ProgramOp {
public:
  explicit AssignmentPruner(SymbolTable &st, const Announcer &&a)
      : symbolTable(st), announcer(a) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  void prunePureUnusedSymbols(std::vector<Symbol> &table);
  SymbolTable &symbolTable;
  const Announcer announcer;
  bool pruned{false};
};

#endif
