// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_DIMPRUNER
#define OPTIMIZER_DIMPRUNER

#include "ast/nullstatementmutator.hpp"
#include "ast/pessimisticexprchecker.hpp"
#include "ast/program.hpp"
#include "symboltable/symboltable.hpp"
#include "utils/announcer.hpp"

// return true when a symbol is never read and is only
// assigned to pure expressions having no side effects
class IsDeadSymbol : public PessimisticExprChecker {
public:
  IsDeadSymbol(const SymbolTable &st) : symbolTable(st) {}
  bool inspect(const NumericVariableExpr &e) const override;
  bool inspect(const StringVariableExpr &e) const override;
  bool inspect(const NumericArrayExpr &e) const override;
  bool inspect(const StringArrayExpr &e) const override;

private:
  using PessimisticExprChecker::inspect;
  const SymbolTable &symbolTable;
};

// removes dead symbols from DIM statements
class StatementDimPruner : public NullStatementMutator {
public:
  StatementDimPruner(int line, const SymbolTable &st, const Announcer &a)
      : lineNumber(line), isDeadSymbol(st), announcer(a) {}
  void mutate(If &s) override;
  void mutate(Dim &s) override;
  void prune(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;
  int lineNumber;
  IsDeadSymbol isDeadSymbol;
  const Announcer &announcer;
  bool pruned{false};
};

// removes dead symbols from program
class DimPruner : public ProgramOp {
public:
  explicit DimPruner(const SymbolTable &st, const Announcer &a)
      : symbolTable(st), announcer(a) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  const SymbolTable &symbolTable;
  const Announcer &announcer;
};

#endif
