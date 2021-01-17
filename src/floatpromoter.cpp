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
    statement->operate(that);
  }
}

void StatementFloatPromoter::operate(If &s) {
  for (auto &statement : s.consequent) {
    statement->operate(this);
  }
}

void StatementFloatPromoter::operate(Let &s) {
  if (boperate(s.rhs, isFloat)) {
    fe.lineNumber = this->lineNumber;
    s.lhs->operate(that);
  }
}

void StatementFloatPromoter::operate(For &s) {
  // we really don't need s.to
  if (boperate(s.from, isFloat) || (s.step && boperate(s.step, isFloat))) {
    fe.lineNumber = this->lineNumber;
    s.iter->operate(that);
  }
}

void StatementFloatPromoter::operate(Read &s) {
  if (!dataTable.pureInteger) {
    for (auto &variable : s.variables) {
      fe.lineNumber = this->lineNumber;
      variable->operate(that);
    }
  }
}

void StatementFloatPromoter::operate(Input &s) {
  for (auto &variable : s.variables) {
    fe.lineNumber = this->lineNumber;
    variable->operate(that);
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

void ExprFloatPromoter::operate(NumericVariableExpr &e) {
  if (makeFloat(symbolTable.numVarTable, e.varname) && Wfloat) {
    fprintf(stderr, "Wfloat: variable \"%s\" promoted to float in line %i\n",
            e.varname.c_str(), lineNumber);
  }
}

void ExprFloatPromoter::operate(NumericArrayExpr &e) {
  if (makeFloat(symbolTable.numArrTable, e.varexp->varname) && Wfloat) {
    fprintf(stderr,
            "Wfloat: %lu-D array \"%s()\" promoted to float in line %i\n",
            e.indices->operands.size(), e.varexp->varname.c_str(), lineNumber);
  }
}
