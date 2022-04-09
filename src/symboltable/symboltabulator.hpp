// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABLE_SYMBOLTABULATOR_HPP
#define SYMBOLTABLE_SYMBOLTABULATOR_HPP

#include "ast/nullexprinspector.hpp"
#include "ast/nullstatementinspector.hpp"
#include "ast/program.hpp"
#include "symboltable.hpp"

// Walk the program AST
// Populate the symbol table via:
// * declaration:  DIM (arrays only)
// * assignment:   LET, FOR, READ, and INPUT
//
// A variable that is never initialized:
// * will never be inserted into the symbol table
// * will be replaced with "" if a string variable
// * will be replaced with 0 if a numeric variable

class ExprSymbolTabulator : public NullExprInspector {
public:
  ExprSymbolTabulator(SymbolTable &st, int linenum)
      : symbolTable(st), lineNumber(linenum) {}
  void inspect(const NumericVariableExpr &e) const override;
  void inspect(const StringVariableExpr &e) const override;
  void inspect(const NumericArrayExpr &e) const override;
  void inspect(const StringArrayExpr &e) const override;
  void addEntry(std::vector<Symbol> &table, const std::string &symbolName,
                std::size_t numDims) const;

private:
  SymbolTable &symbolTable;
  int lineNumber;
};

class StatementSymbolTabulator : public NullStatementInspector {
public:
  StatementSymbolTabulator(SymbolTable &st, int linenum)
      : exprSymbolTabulator(st, linenum) {}
  void inspect(const If &s) const override;
  void inspect(const Dim &s) const override;
  void inspect(const Read &s) const override;
  void inspect(const Let &s) const override;
  void inspect(const For &s) const override;
  void inspect(const Input &s) const override;

  void delve(const std::vector<up<Statement>> &statements) const;

private:
  ExprSymbolTabulator exprSymbolTabulator;
};

class SymbolTabulator : public ProgramOp {
public:
  explicit SymbolTabulator(SymbolTable &st) : symbolTable(st) {}
  void operate(Program &p) override;
  void operate(Line &l) override;

private:
  SymbolTable &symbolTable;
};

#endif
