// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef SYMBOLTABULATOR_HPP
#define SYMBOLTABULATOR_HPP

#include "program.hpp"

// Walk the program AST
// Populate the symbol table via:
//   declaration:  DIM (arrays only)
//   assignment:   LET, FOR, READ, and INPUT
// A variable that is never initialized will not make it to the symbol table.
// The compiler will complain about variables that are never initialized.

class ExprSymbolTabulator : public ExprOp {
public:
  SymbolTable &symbolTable;
  explicit ExprSymbolTabulator(SymbolTable &st) : symbolTable(st) {}
  void operate(NumericVariableExpr &e) override;
  void operate(StringVariableExpr &e) override;
  void operate(NumericArrayExpr &e) override;
  void operate(StringArrayExpr &e) override;
  void addEntry(std::vector<Symbol> &table, std::string &symbolName,
                std::size_t numDims);
  void setLineNumber(int line) { lineNumber = line; }

private:
  int lineNumber;
};

class StatementSymbolTabulator : public StatementOp {
public:
  SymbolTable &symbolTable;
  ExprSymbolTabulator ste;
  ExprOp *that;
  explicit StatementSymbolTabulator(SymbolTable &st)
      : symbolTable(st), ste(st), that(&ste) {}
  void operate(If &s) override;
  void operate(Dim &s) override;
  void operate(Read &s) override;
  void operate(Let &s) override;
  void operate(For &s) override;
  void operate(Input &s) override;
  void setLineNumber(int line) {
    lineNumber = line;
    ste.setLineNumber(line);
  }

private:
  int lineNumber = 0;
};

class SymbolTabulator : public ProgramOp {
public:
  SymbolTable &symbolTable;
  StatementSymbolTabulator sts;
  explicit SymbolTabulator(SymbolTable &st) : symbolTable(st), sts(st) {}
  void operate(Program &p) override;
  void operate(Line &l) override;
};

#endif
