// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symboltabulator.hpp"

void SymbolTabulator::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
  sortSymbolTable(symbolTable);
}

void SymbolTabulator::operate(Line &l) {
  StatementSymbolTabulator st(symbolTable, l.lineNumber);
  st.delve(l.statements);
}

void StatementSymbolTabulator::inspect(const If &s) const {
  delve(s.consequent);
}

void StatementSymbolTabulator::inspect(const Dim &s) const {
  for (const auto &variable : s.variables) {
    variable->inspect(&exprSymbolTabulator);
  }
}

void StatementSymbolTabulator::inspect(const Read &s) const {
  for (const auto &variable : s.variables) {
    variable->inspect(&exprSymbolTabulator);
  }
}

void StatementSymbolTabulator::inspect(const Let &s) const {
  s.lhs->inspect(&exprSymbolTabulator);
}

void StatementSymbolTabulator::inspect(const Accum &s) const {
  s.lhs->inspect(&exprSymbolTabulator);
}

void StatementSymbolTabulator::inspect(const Decum &s) const {
  s.lhs->inspect(&exprSymbolTabulator);
}

void StatementSymbolTabulator::inspect(const Necum &s) const {
  s.lhs->inspect(&exprSymbolTabulator);
}

void StatementSymbolTabulator::inspect(const For &s) const {
  s.iter->inspect(&exprSymbolTabulator);
  for (auto &symbol : symbolTable.numVarTable) {
    if (s.iter->varname == symbol.name) {
      symbol.isUsed = true;
    }
  }
}

void StatementSymbolTabulator::inspect(const Input &s) const {
  for (const auto &variable : s.variables) {
    variable->inspect(&exprSymbolTabulator);
  }
}

void StatementSymbolTabulator::delve(
    const std::vector<up<Statement>> &statements) const {
  for (const auto &statement : statements) {
    statement->inspect(this);
  }
}

void ExprSymbolTabulator::addEntry(std::vector<Symbol> &table,
                                   const std::string &symbolName,
                                   std::size_t numDims) const {
  for (Symbol &symbol : table) {
    if (symbol.name == symbolName) {
      if (symbol.numDims == static_cast<int>(numDims)) {
        return;
      }
      fprintf(stderr,
              "error: line %i: Dimension mismatch for array variable %s\n",
              lineNumber, symbol.name.c_str());
      exit(1);
    }
  }

  Symbol s;
  s.name = symbolName;
  s.numDims = static_cast<int>(numDims);
  table.push_back(s);
}

void ExprSymbolTabulator::inspect(const NumericVariableExpr &e) const {
  addEntry(symbolTable.numVarTable, e.varname, 0);
}

void ExprSymbolTabulator::inspect(const StringVariableExpr &e) const {
  addEntry(symbolTable.strVarTable, e.varname, 0);
}

void ExprSymbolTabulator::inspect(const NumericArrayExpr &e) const {
  addEntry(symbolTable.numArrTable, e.varexp->varname,
           e.indices->operands.size());
}

void ExprSymbolTabulator::inspect(const StringArrayExpr &e) const {
  addEntry(symbolTable.strArrTable, e.varexp->varname,
           e.indices->operands.size());
}
