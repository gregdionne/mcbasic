// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef FLOATPROMOTER_HPP
#define FLOATPROMOTER_HPP

#include "isfloat.hpp"
#include "program.hpp"

// Promotes numeric symbol, <s>, to floating point
// upon assignment for the following cases:
//
// * LET <s> = <expr>
//   when <expr> evaluates to a floating point value
//
// * READ <s>
//   when any data entry in dataTable has a floating point value
//
// * RND(<expr>)
//   when <expr> is not a positive constant.
//
// * FOR <s> = <expr1> TO <expr2> STEP <expr3>
//   when either <start> or <step> has a floating point value.
//
// * INPUT <s>
//   always promotes
//
// The algorithm loops through the program AST and promotes the symbol
// when any of the above conditions are met.  The algorithm stops when no
// more promotions can be made.

class ExprFloatPromoter : public ExprOp {
public:
  bool &gotFloat;
  DataTable &dataTable;
  SymbolTable &symbolTable;
  IsFloat &isFloat;
  bool Wfloat;
  int lineNumber;
  ExprFloatPromoter(bool &gf, DataTable &dt, SymbolTable &st, IsFloat &isf,
                    bool wf)
      : gotFloat(gf), dataTable(dt), symbolTable(st), isFloat(isf), Wfloat(wf) {
  }
  bool makeFloat(std::vector<Symbol> &table, std::string &symbolName);
  void operate(NumericVariableExpr &e) override;
  void operate(NumericArrayExpr &e) override;
};

class StatementFloatPromoter : public StatementOp {
public:
  bool &gotFloat;
  DataTable &dataTable;
  SymbolTable &symbolTable;
  IsFloat &isFloat;
  ExprFloatPromoter fe;
  ExprOp *that;
  int lineNumber;
  StatementFloatPromoter(bool &gf, DataTable &dt, SymbolTable &st, IsFloat &isf,
                         bool wf)
      : gotFloat(gf), dataTable(dt), symbolTable(st), isFloat(isf),
        fe(gf, dt, st, isf, wf), that(&fe) {}
  void operate(If &s) override;
  void operate(Let &s) override;
  void operate(For &s) override;
  void operate(Read &s) override;
  void operate(Input &s) override;
};

class FloatPromoter : public ProgramOp {
public:
  bool gotFloat;
  DataTable &dataTable;
  SymbolTable &symbolTable;
  IsFloat isFloat;
  StatementFloatPromoter fs;
  StatementOp *that;
  FloatPromoter(DataTable &dt, SymbolTable &st, bool wf)
      : gotFloat(false), dataTable(dt), symbolTable(st), isFloat(st),
        fs(gotFloat, dt, st, isFloat, wf), that(&fs) {}
  void operate(Program &p) override;
  void operate(Line &l) override;
};

#endif
