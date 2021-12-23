// Copyright (C) 2021 Greg Dionne
// Distributed under MIT License
#ifndef OPTIMIZER_FLOATPROMOTER_HPP
#define OPTIMIZER_FLOATPROMOTER_HPP

#include "ast/nullexprmutator.hpp"
#include "ast/nullstatementmutator.hpp"
#include "ast/program.hpp"
#include "isfloat.hpp"
#include "utils/warner.hpp"

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

class ExprFloatPromoter : public NullExprMutator {
public:
  bool &gotFloat;
  DataTable &dataTable;
  SymbolTable &symbolTable;
  IsFloat &isFloat;
  Warner &warner;
  int lineNumber;
  ExprFloatPromoter(bool &gf, DataTable &dt, SymbolTable &st, IsFloat &isf,
                    Warner &wf)
      : gotFloat(gf), dataTable(dt), symbolTable(st), isFloat(isf), warner(wf) {
  }
  bool makeFloat(std::vector<Symbol> &table, std::string &symbolName);
  void mutate(NumericVariableExpr &e) override;
  void mutate(NumericArrayExpr &e) override;
};

class StatementFloatPromoter : public NullStatementMutator {
public:
  bool &gotFloat;
  DataTable &dataTable;
  SymbolTable &symbolTable;
  IsFloat &isFloat;
  ExprFloatPromoter fe;
  ExprMutator<void, void> *that;
  int lineNumber;
  StatementFloatPromoter(bool &gf, DataTable &dt, SymbolTable &st, IsFloat &isf,
                         Warner &wf)
      : gotFloat(gf), dataTable(dt), symbolTable(st), isFloat(isf),
        fe(gf, dt, st, isf, wf), that(&fe) {}
  void mutate(If &s) override;
  void mutate(Let &s) override;
  void mutate(For &s) override;
  void mutate(Read &s) override;
  void mutate(Input &s) override;
};

class FloatPromoter : public ProgramOp {
public:
  bool gotFloat;
  DataTable &dataTable;
  SymbolTable &symbolTable;
  IsFloat isFloat;
  StatementFloatPromoter fs;
  NullStatementMutator *that;
  FloatPromoter(DataTable &dt, SymbolTable &st, Warner wf)
      : gotFloat(false), dataTable(dt), symbolTable(st), isFloat(st),
        fs(gotFloat, dt, st, isFloat, wf), that(&fs) {}
  void operate(Program &p) override;
  void operate(Line &l) override;
};

#endif
