// Copyright (C) 2021, Greg Dionne
// Distributed by MIT License
#include "dimensionizer.hpp"
#include <cstdio>

void ExprDimensionizer::inspect(const NumericArrayExpr &e) const {
  for (auto &symbol : symbolTable.numArrTable) {
    if (symbol.name == e.varexp->varname) {
      if (!symbol.numDims) {
        symbol.numDims = static_cast<int>(e.indices->operands.size());
      } else if (symbol.numDims !=
                 static_cast<int>(e.indices->operands.size())) {
        fprintf(stderr,
                "line %i: number of dimensions for %s() conflicts with earlier "
                "definition\n",
                lineNumber, symbol.name.c_str());
        exit(1);
      }
    }
  }
}

void ExprDimensionizer::inspect(const StringArrayExpr &e) const {
  for (auto &symbol : symbolTable.strArrTable) {
    if (symbol.name == e.varexp->varname) {
      if (!symbol.numDims) {
        symbol.numDims = static_cast<int>(e.indices->operands.size());
      } else if (symbol.numDims !=
                 static_cast<int>(e.indices->operands.size())) {
        fprintf(
            stderr,
            "line %i: number of dimensions for %s$() conflicts with earlier "
            "definition\n",
            lineNumber, symbol.name.c_str());
        exit(1);
      }
    }
  }
}

void StatementDimensionizer::inspect(const Dim &s) const {
  for (const auto &variable : s.variables) {
    variable->inspect(&exprDimensionizer);
  }
}

void StatementDimensionizer::inspect(const If &s) const { delve(s.consequent); }

void StatementDimensionizer::delve(
    const std::vector<up<Statement>> &statements) const {
  for (const auto &statement : statements) {
    statement->inspect(this);
  }
}

void Dimensionizer::operate(Program &p) {
  for (auto &line : p.lines) {
    line->operate(this);
  }
}

void Dimensionizer::operate(Line &l) {
  StatementDimensionizer d(symbolTable, l.lineNumber);
  d.delve(l.statements);
}
