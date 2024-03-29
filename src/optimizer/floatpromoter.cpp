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
    fe.listStatement(&s);
    s.lhs->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(Accum &s) {
  if (s.rhs->check(&isFloat)) {
    fe.setLineNumber(lineNumber);
    fe.listStatement(&s);
    s.lhs->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(Decum &s) {
  if (s.rhs->check(&isFloat)) {
    fe.setLineNumber(lineNumber);
    fe.listStatement(&s);
    s.lhs->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(Necum &s) {
  if (s.rhs->check(&isFloat)) {
    fe.setLineNumber(lineNumber);
    fe.listStatement(&s);
    s.lhs->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(For &s) {
  // we really don't need s.to
  if (s.from->check(&isFloat) || (s.step && s.step->check(&isFloat))) {
    fe.setLineNumber(lineNumber);
    fe.listStatement(&s);
    s.iter->mutate(&fe);
  }
}

void StatementFloatPromoter::mutate(Read &s) {
  if (!dataTable.isPureInteger()) {
    for (auto &variable : s.variables) {
      fe.setLineNumber(lineNumber);
      fe.listStatement(&s);
      variable->mutate(&fe);
    }
  }
}

void StatementFloatPromoter::mutate(Input &s) {
  for (auto &variable : s.variables) {
    fe.setLineNumber(lineNumber);
    fe.listStatement(&s);
    variable->mutate(&fe);
  }
}

void ExprFloatPromoter::listStatement(const Statement *s) { s->soak(&ls); }

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
    announcer.finish("\"%s\" promoted to float in statement \"%s\"",
                     e.varname.c_str(), ls.result.c_str());
  }
}

void ExprFloatPromoter::mutate(NumericArrayExpr &e) {
  if (makeFloat(symbolTable.numArrTable, e.varexp->varname)) {
    announcer.start(lineNumber);
    announcer.finish("\"%s()\" promoted to float in statement \"%s\"",
                     e.varexp->varname.c_str(), ls.result.c_str());
  }
}
