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

  symbolTable.sort();
}

void FloatPromoter::operate(Line &l) {
  for (auto &statement : l.statements) {
    fs.lineNumber = l.lineNumber;
    statement->mutate(that);
  }
}

void StatementFloatPromoter::mutate(If &s) {
  for (auto &statement : s.consequent) {
    statement->mutate(this);
  }
}

void StatementFloatPromoter::mutate(Let &s) {
  if (s.rhs->inspect(&isFloat)) {
    fe.lineNumber = this->lineNumber;
    s.lhs->mutate(that);
  }
}

void StatementFloatPromoter::mutate(For &s) {
  // we really don't need s.to
  if (s.from->inspect(&isFloat) || (s.step && s.step->inspect(&isFloat))) {
    fe.lineNumber = this->lineNumber;
    s.iter->mutate(that);
  }
}

void StatementFloatPromoter::mutate(Read &s) {
  if (!dataTable.pureInteger) {
    for (auto &variable : s.variables) {
      fe.lineNumber = this->lineNumber;
      variable->mutate(that);
    }
  }
}

void StatementFloatPromoter::mutate(Input &s) {
  for (auto &variable : s.variables) {
    fe.lineNumber = this->lineNumber;
    variable->mutate(that);
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
    warner.start(lineNumber);
    warner.finish("variable \"%s\" promoted to float", e.varname.c_str());
  }
}

void ExprFloatPromoter::mutate(NumericArrayExpr &e) {
  if (makeFloat(symbolTable.numArrTable, e.varexp->varname)) {
    warner.start(lineNumber);
    warner.finish("%lu-D array \"%s()\" promoted to float",
                  e.indices->operands.size(), e.varexp->varname.c_str());
  }
}
