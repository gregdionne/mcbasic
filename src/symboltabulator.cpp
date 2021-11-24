// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "symboltabulator.hpp"

void SymbolTabulator::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
  symbolTable.sort();
}

void SymbolTabulator::operate(Line &l) {
  for (auto &statement : l.statements) {
    sts.setLineNumber(l.lineNumber);
    statement->operate(&sts);
  }
}

void StatementSymbolTabulator::operate(If &s) {
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementSymbolTabulator::operate(Dim &s) {
  for (auto &variable : s.variables) {
    variable->operate(that);
  }
}

void StatementSymbolTabulator::operate(Read &s) {
  for (auto &variable : s.variables) {
    variable->operate(that);
  }
}

void StatementSymbolTabulator::operate(Let &s) { s.lhs->operate(that); }

void StatementSymbolTabulator::operate(For &s) { s.iter->operate(that); }

void StatementSymbolTabulator::operate(Input &s) {
  for (auto &variable : s.variables) {
    variable->operate(that);
  }
}

void ExprSymbolTabulator::addEntry(std::vector<Symbol> &table,
                                   std::string &symbolName,
                                   std::size_t numDims) {
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

void ExprSymbolTabulator::operate(NumericVariableExpr &e) {
  addEntry(symbolTable.numVarTable, e.varname, 0);
}

void ExprSymbolTabulator::operate(StringVariableExpr &e) {
  addEntry(symbolTable.strVarTable, e.varname, 0);
}

void ExprSymbolTabulator::operate(NumericArrayExpr &e) {
  addEntry(symbolTable.numArrTable, e.varexp->varname,
           e.indices->operands.size());
}

void ExprSymbolTabulator::operate(StringArrayExpr &e) {
  addEntry(symbolTable.strArrTable, e.varexp->varname,
           e.indices->operands.size());
}
