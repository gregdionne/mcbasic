// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_DIMENSIONIZER
#define SYMBOLTABLE_DIMENSIONIZER

#include "ast/nullexprinspector.hpp"
#include "ast/nullstatementinspector.hpp"
#include "ast/program.hpp"
#include "symboltable.hpp"

class ExprDimensionizer : public NullExprInspector {
public:
  ExprDimensionizer(SymbolTable &st, int ln)
      : symbolTable(st), lineNumber(ln) {}
  void inspect(const NumericArrayExpr &e) const override;
  void inspect(const StringArrayExpr &e) const override;

private:
  SymbolTable &symbolTable;
  int lineNumber;
};

class StatementDimensionizer : public NullStatementInspector {
public:
  StatementDimensionizer(SymbolTable &st, int ln) : exprDimensionizer(st, ln) {}
  void inspect(const If &s) const override;
  void inspect(const Dim &s) const override;
  void delve(const std::vector<up<Statement>> &statements) const;

private:
  ExprDimensionizer exprDimensionizer;
};

class Dimensionizer : public ProgramOp {
public:
  explicit Dimensionizer(SymbolTable &st) : symbolTable(st) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  SymbolTable &symbolTable;
};

#endif
