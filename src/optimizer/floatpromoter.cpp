// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#include "floatpromoter.hpp"

void FloatPromoter::operate(Program &p) {
  do {
    gotFloat = false;
    for (auto &line : p.lines) {
      line->operate(this);
    }
  } while (gotFloat);

  sortSymbolTable(symbolTable);
}

void FloatPromoter::operate(Line &l) {
  for (auto &statement : l.statements) {
    fs.setLineNumber(l.lineNumber);
    statement->mutate(&fs);
  }
}

void StatementFloatPromoter::mutate(If &s) {
  for (auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementFloatPromoter::mutate(Let &s) {
  if (s.rhs->check(&isFloat)) {
    fe.setLineNumber(lineNumber);
    s.lhs->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(For &s) {
  // we really don't need s.to
  if (s.from->check(&isFloat) || (s.step && s.step->check(&isFloat))) {
    fe.setLineNumber(lineNumber);
    s.iter->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(Read &s) {
  if (!dataTable.isPureInteger()) {
    for (auto &variable : s.variables) {
      fe.setLineNumber(lineNumber);
      variable->mutate(&fe);
    }
  }
}

void StatementFloatPromoter::mutate(Input &s) {
  for (auto &variable : s.variables) {
    fe.setLineNumber(lineNumber);
    variable->mutate(&fe);
  }
}

bool ExprFloatPromoter::makeFloat(std::vector<Symbol> &table,
                                  std::string &symbolName) {
  for (Symbol &symbol : table) {
    if (symbol.name == symbolName) {
      if (!symbol.isFloat) {
        return symbol.isFloat = gotFloat = true;
      }
      return false;
    }
  }
  return false;
}

void ExprFloatPromoter::mutate(NumericVariableExpr &e) {
  if (makeFloat(symbolTable.numVarTable, e.varname)) {
    announcer.start(lineNumber);
    announcer.finish("variable \"%s\" promoted to float", e.varname.c_str());
  }
}

void ExprFloatPromoter::mutate(NumericArrayExpr &e) {
  if (makeFloat(symbolTable.numArrTable, e.varexp->varname)) {
    announcer.start(lineNumber);
    announcer.finish("%lu-D array \"%s()\" promoted to float",
                     e.indices->operands.size(), e.varexp->varname.c_str());
  }
}
