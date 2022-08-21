// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_DIMPRUNER
#define OPTIMIZER_DIMPRUNER

#include "ast/nullstatementmutator.hpp"
#include "ast/pessimisticexprchecker.hpp"
#include "ast/program.hpp"
#include "symboltable/ismissingsymbol.hpp"
#include "utils/announcer.hpp"

// removes missing symbols from DIM statements
class StatementDimPruner : public NullStatementMutator {
public:
  StatementDimPruner(int line, const SymbolTable &st, const Announcer &a)
      : lineNumber(line), isMissingSymbol(st), announcer(a) {}
  void mutate(If &s) override;
  void mutate(Dim &s) override;
  void prune(std::vector<up<Statement>> &statements);

private:
  using NullStatementMutator::mutate;
  int lineNumber;
  IsMissingSymbol isMissingSymbol;
  const Announcer &announcer;
  bool pruned{false};
};

// removes missing symbols from program
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
